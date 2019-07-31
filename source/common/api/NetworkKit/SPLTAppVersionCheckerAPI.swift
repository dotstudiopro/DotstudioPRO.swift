//
//  SPLTAppVersionCheckerAPI.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 24/11/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

open class SPLTAppVersionCheckerAPI {
    
    public init() {
        
    }
//    open func getLatestAppVersion(completion: @escaping (_ latestVersionDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//        
//        SPLTBaseAPI.sessionManager.request(SPLTRouter.latestAppVersion, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
//            if (response.result.value != nil) {
//                if let infoDict = response.result.value as? [String: Any],
//                    let bSuccess = infoDict["success"] as? Bool, bSuccess == true,
//                    let latestVersionDict = infoDict["latestVersion"] as? [String: Any] {
//                    completion(latestVersionDict)
//                    return
//                }
//            }
//            completionError(NSError(domain: "SPLTAppVersionCheckerAPI", code: 1, userInfo: nil))
//        }
//    }
    
    open func getLatestAppVersionFromBundleId(completion: @escaping (_ latestVersionDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        guard let strBundleId = SPLTConfig.bundleIdentifierBundleMain else {
            // Throw Exception
            return
        }
        
        var headers: HTTPHeaders = [:]
        #if os(iOS)
            headers["x-os-type"] = "ios"
        #elseif os(tvOS)
            headers["x-os-type"] = "tvos"
        #endif
        if let strHeaderApplicationName = SPLTConfig.strHeaderApplicationName {
            headers["x-application-name"] = strHeaderApplicationName
        }
            
        Alamofire.request(SPLTRouter.latestAppVersionByPackage(strBundleId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: Any],
                    let bSuccess = infoDict["success"] as? Bool, bSuccess == true,
                    let latestVersionDict = infoDict["latestVersion"] as? [String: Any] {
                    completion(latestVersionDict)
                    return
                }
            }
            completionError(NSError(domain: "SPLTAppVersionCheckerAPI", code: 1, userInfo: nil))
        }
    }
}

