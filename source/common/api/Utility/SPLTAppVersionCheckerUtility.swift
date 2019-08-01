//
//  SPLTAppVersionCheckerUtility.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 24/11/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import UIKit

public enum SPLTSeverityLevelEnum: Int {
    // Funnel Events:
    case level_OK = -1
    case level_0 = 0
    case level_1 = 1
    case level_2 = 2
    case level_3 = 3
    case level_4 = 4
}

open class SPLTAppVersionCheckerUtility: NSObject {
    
    public static let shared = SPLTAppVersionCheckerUtility()
    //var spltChannelWindowUtilityProtocol: SPLTChannelWindowUtilityProtocol?
    
    var viewController: UIViewController?
    var windowObserver: Any?
    var window: UIWindow? {
        didSet {
            if let window_ = window {
                self.windowObserver = window_.observe(\.rootViewController, options: [.new, .old]) { window_, change in
                    print("I'm now called \(window_.rootViewController)")
                    self.checkAndShowAlertOnRootViewController()
                }
            }
        }
    }
    var spltSeverityLevel :SPLTSeverityLevelEnum = .level_OK
    
    public override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    public func checkAppVersionFromWindow(window: UIWindow?, completion: @escaping (_ eSeverityLevel: SPLTSeverityLevelEnum) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        self.window = window
        self.checkLatestAppVersionFromBundleId(completion: completion, completionError: completionError)
    }
//    public func checkAppVersionFromVC(vc: UIViewController?) {
//        if let vc_ = vc {
//            self.viewController = vc_
//        }
////        self.checkLatestAppVersionFromBundleId(completion: completion, completionError: completionError)
//    }
    internal func checkLatestAppVersionFromBundleId(completion: @escaping (_ eSeverityLevel: SPLTSeverityLevelEnum) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTAppVersionCheckerAPI().getLatestAppVersionFromBundleId(completion: { (latestAppVersionDict) in
            // received AppVersion
            self.checkLatestAppVersion(latestAppVersionDict: latestAppVersionDict, completion: completion, completionError: completionError)
        }) { (error) in
            // Error while checking latest app version
            print("error while checking app version")
        }
    }
    
    internal func checkLatestAppVersion(latestAppVersionDict: [String: Any], completion: @escaping (_ eSeverityLevel: SPLTSeverityLevelEnum) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if let strLatestVersion = latestAppVersionDict["version"] as? String,
            let severity_level = latestAppVersionDict["severity_level"] as? Int,
            let appstore_url = latestAppVersionDict["appstore_url"] as? String {
            
            if let eSeverityLevel_ = SPLTSeverityLevelEnum(rawValue: severity_level) {
                self.spltSeverityLevel = eSeverityLevel_
            }
            

            
            self.checkAndPromptForAppVersion(strLatestVersion: strLatestVersion, appstore_url: appstore_url, completion: completion, completionError: completionError)
        } else {
            completionError(NSError(domain: "SPLTAppVersionCheckerUtility", code: 1, userInfo: ["message":"version not found"]))
        }
    }
    func isLatestAppVersionInstalled(strLatestVersion: String) -> Bool {
        if let strAppVersionNumber = SPLTConfig.infoDictionaryBundleMain?["CFBundleShortVersionString"] as? String {
            if strAppVersionNumber == strLatestVersion {
                return true // If both versions are same. latest & installed app version.
            }
            
            let strInstalledAppVersionNos = strAppVersionNumber.components(separatedBy: ".")
            let strLatestAppVersionNos = strLatestVersion.components(separatedBy: ".")
            for index in 0...(strLatestAppVersionNos.count-1) {
                let strLatestAppVersionSubNo = strLatestAppVersionNos[index]
                if index < strInstalledAppVersionNos.count {
                    let strInstalledAppVersionSubNo = strInstalledAppVersionNos[index]
                    if let iLatestAppVersionSubNo = Int(strLatestAppVersionSubNo),
                        let iInstalledAppVersionSubNo = Int(strInstalledAppVersionSubNo) {
                        if iInstalledAppVersionSubNo < iLatestAppVersionSubNo {
                            return false
                        } else if iInstalledAppVersionSubNo > iLatestAppVersionSubNo {
                            return true
                        }
                    }
                }
            }
        }
        return true
    }
    internal func checkAndPromptForAppVersion(strLatestVersion: String, appstore_url: String, completion: @escaping (_ eSeverityLevel: SPLTSeverityLevelEnum) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if self.isLatestAppVersionInstalled(strLatestVersion: strLatestVersion) {
            completion(self.spltSeverityLevel)
        } else {
            self.promptForAppVersion(strLatestVersion: strLatestVersion, appstore_url: appstore_url, completion: completion, completionError: completionError)
        }
    }
    
    var alert: UIAlertController?
    internal func promptForAppVersion(strLatestVersion: String, appstore_url: String, completion: @escaping (_ eSeverityLevel: SPLTSeverityLevelEnum) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
//        var eSeverityLevel: SPLTSeverityLevelEnum = .level_0
//        if let eSeverityLevel_ = SPLTSeverityLevelEnum(rawValue: severity_level) {
//            eSeverityLevel = eSeverityLevel_
//        }
//        self.spltSeverityLevel = eSeverityLevel
        var strTitle = "Update Available"
        var strAlertMessage = "For your app to function properly a required update is now available in the App Store."
        switch self.spltSeverityLevel {
            case .level_OK:
                // Everything is fine. No need to show any prompt to update.
                return
            case .level_0:
                strTitle = "Update Available"
                strAlertMessage = "For your app to function properly a required update is now available in the App Store."
            case .level_1:
                strTitle = "Update Available"
                strAlertMessage = "For your app to function properly a required update is now available in the App Store."
            case .level_2:
                strTitle = "Update Recommended"
                strAlertMessage = "For your app to function properly a required update is now available in the App Store."
            case .level_3:
                strTitle = "Update Required"
                strAlertMessage = "For your app to function properly a required update is now available in the App Store."
            case .level_4:
                strTitle = "App Not available"
                strAlertMessage = "Unfortunately, this app is no longer available!"
        }
        
        let alert = UIAlertController(title: strTitle, message: strAlertMessage, preferredStyle: .alert)
        
        if self.spltSeverityLevel != .level_4 {
            alert.addAction(UIAlertAction(title: "Update Now", style: .default, handler: { (alertAction) in
                // Redirect User to App Store.
                if let url = URL(string: appstore_url),
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.openURL(url)
                }
            }))
        } else {
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (alertAction) in
            }))
        }
        if self.spltSeverityLevel != .level_3 && self.spltSeverityLevel != .level_4 {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        
//        if let viewController = self.window?.rootViewController {
//            viewController.present(alert, animated: true, completion: nil)
//        } else if let viewController = self.viewController {
//            viewController.present(alert, animated: true, completion: nil)
//        }
        self.alert = alert
        self.checkAndShowAlertOnRootViewController()
        completion(self.spltSeverityLevel)
    }

    func checkAndShowAlertOnRootViewController() {
        if let alert = self.alert {
            if alert.view.window != nil {
                alert.dismiss(animated: false) {
                    self.showAlertOnRootViewController()
                }
            } else {
                self.showAlertOnRootViewController()
            }
        }
    }
    func showAlertOnRootViewController() {
        if let alert = self.alert {
            if let viewController = self.window?.rootViewController {
                viewController.present(alert, animated: true, completion: nil)
            } else if let viewController = self.viewController {
                viewController.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @objc open func applicationDidBecomeActive() {
//        self.checkAppVersionFromVC(vc: nil)
        self.checkLatestAppVersionFromBundleId(completion: { (eSPLTSeverityLevel) in
            //
        }) { (error) in
            // Error
        }

    }
}







