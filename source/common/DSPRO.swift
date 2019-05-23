//
//  DSPRO.swift
//  DotstudioPRO-Demo
//
//  Created by Ketan Sakariya on 22/05/19.
//  Copyright © 2019 Ketan Sakariya. All rights reserved.
//

import Foundation

open class DSPRO {
    public static let shared = DSPRO()
    
    public class func initializeWith(config: [String: Any], completion: @escaping (_ bInitialized: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTConfig.infoDictionaryBundleMain = Bundle.main.infoDictionary
        SPLTConfig.bundleIdentifierBundleMain = Bundle.main.bundleIdentifier
        if let strAppName = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            SPLTConfig.APPNAME = strAppName
        }

        if let strApiKey = config["apikey"] as? String {
            DSPRO.shared.setupAccessToken(strApiKey: strApiKey, completion: completion, completionError: completionError)
        }
    }
    
    func setupAccessToken(strApiKey: String, completion: @escaping (_ bInitialized: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTRouter.API_KEY = strApiKey
        SPLTTokenAPI().getToken { (accessToken) in
            SPLTRouter.strAccessToken = accessToken
            completion(true)
        }
    }
    
}





