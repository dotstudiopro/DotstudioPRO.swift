//
//  DSPRO.swift
//  DotstudioPRO-Demo
//
//  Created by Ketan Sakariya on 22/05/19.
//  Copyright © 2019 Ketan Sakariya. All rights reserved.
//

import Foundation
import UIKit

open class DSPRO {
    public static let shared = DSPRO()
    
    public class func initializeWith(config: [String: Any], completion: @escaping (_ bInitialized: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) throws {
        SPLTConfig.infoDictionaryBundleMain = Bundle.main.infoDictionary
        SPLTConfig.bundleIdentifierBundleMain = Bundle.main.bundleIdentifier
        if let strAppName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            SPLTConfig.APPNAME = strAppName
        }

        if let shouldAutoLoadCategoryChannels = config["shouldAutoLoadCategoryChannels"] as? Bool {
            SPLTConfig.shouldAutoLoadCategoryChannels = shouldAutoLoadCategoryChannels
        }
        
        if let APP_ID = config["APP_ID"] as? String {
            SPLTConfig.APP_ID = APP_ID
        } else {
            throw SPLTConfigError.noAppIdDefined
        }
        if let APP_URL = config["APP_URL"] as? String {
            SPLTConfig.APP_URL = APP_URL
        } else {
            throw SPLTConfigError.noAppUrlDefined
        }
        if let window = SPLTConfig.window {
//            SPLTConfig.window = window
        } else {
            throw SPLTConfigError.noWindowDefined
        }
        
        if let strApiKey = config["apikey"] as? String {
            DSPRO.shared.checkAppVersionAndSetupAccessToken(strApiKey: strApiKey, completion: completion, completionError: completionError)
        }

    }
    
    func checkAppVersionAndSetupAccessToken(strApiKey: String, completion: @escaping (_ bInitialized: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTRouter.API_KEY = strApiKey
        if let window = SPLTConfig.window {
            SPLTAppVersionCheckerUtility.shared.checkAppVersionFromWindow(window: window, completion: { (eSPLTSeverityLevel) in
                // check app version severity level
                if eSPLTSeverityLevel == .level_4 {
                    // Don't generate accesss token. no api calls after level 4
                } else {
                    self.setupAccessToken(completion: completion, completionError: completionError)
                }
            }) { (error) in
                // continue when failed to get version check api
                self.setupAccessToken(completion: completion, completionError: completionError)
            }
        }
    }
    func setupAccessToken(completion: @escaping (_ bInitialized: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().getToken { (accessToken) in
            SPLTRouter.strAccessToken = accessToken
            completion(true)
        }
    }
    
}





