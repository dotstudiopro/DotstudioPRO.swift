//
//  SPLTAppVersionCheckerUtility.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 24/11/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import UIKit

enum SPLTSeverityLevelEnum: Int {
    // Funnel Events:
    case level_0 = 0
    case level_1 = 1
    case level_2 = 2
    case level_3 = 3
}

open class SPLTAppVersionCheckerUtility: NSObject {
    
    public static let sharedInstance = SPLTAppVersionCheckerUtility()
    //var spltChannelWindowUtilityProtocol: SPLTChannelWindowUtilityProtocol?
    
    var viewController: UIViewController?
    
    open func checkAppVersionFromVC(viewController: UIViewController) {
        self.viewController = viewController
        SPLTAppVersionCheckerAPI().getLatestAppVersion(completion: { (latestAppVersionDict) in
            // received AppVersion
            self.checkLatestAppVersion(latestAppVersionDict: latestAppVersionDict)
        }) { (error) in
            // Error while checking latest app version
            print("error while checking app version")
        }
    }
    
    internal func checkLatestAppVersion(latestAppVersionDict: [String: Any]) {
        if let strLatestVersion = latestAppVersionDict["version"] as? String,
            let severity_level = latestAppVersionDict["severity_level"] as? Int,
            let appstore_url = latestAppVersionDict["appstore_url"] as? String {
            self.checkAndPromptForAppVersion(strLatestVersion: strLatestVersion, severity_level: severity_level, appstore_url: appstore_url)
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
    internal func checkAndPromptForAppVersion(strLatestVersion: String, severity_level: Int, appstore_url: String) {
        if !self.isLatestAppVersionInstalled(strLatestVersion: strLatestVersion) {
            self.promptForAppVersion(strLatestVersion: strLatestVersion, severity_level: severity_level, appstore_url: appstore_url)
        }
    }
    internal func promptForAppVersion(strLatestVersion: String, severity_level: Int, appstore_url: String) {
        
        var eSeverityLevel: SPLTSeverityLevelEnum = .level_0
        if let eSeverityLevel_ = SPLTSeverityLevelEnum(rawValue: severity_level) {
            eSeverityLevel = eSeverityLevel_
        }
        var strTitle = "Update Available"
        var strAlertMessage = "For your app to function properly a required update is now available in the App Store."
        switch eSeverityLevel {
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
        }
        
        let alert = UIAlertController(title: strTitle, message: strAlertMessage, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Update Now", style: .default, handler: { (alertAction) in
            // Redirect User to App Store.
            if let url = URL(string: appstore_url),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }))
        if eSeverityLevel != .level_3 {
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        }
        if let viewController = self.viewController {
            viewController.present(alert, animated: true, completion: nil)
        }

    }
}






