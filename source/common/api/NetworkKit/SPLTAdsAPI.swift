//
//  SPLTAdsAPI.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 09/05/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire
import AdSupport
import UIKit

open class SPLTAdsAPI {
    
    open class func getVmapAdTagParameters() -> String? {
        // App parameters
        var strAdTagParameters: String = "vpaid=js"
        if let strBundleIdentifier = SPLTConfig.bundleIdentifierBundleMain {
            strAdTagParameters += "&app_bundle=\(strBundleIdentifier)"
        }
        if let strAppName = SPLTConfig.APPNAME {
            strAdTagParameters += "&app_name=\(strAppName)"
        }
        if let strVersion = SPLTConfig.infoDictionaryBundleMain!["CFBundleShortVersionString"] as? String {
            strAdTagParameters += "&app_version=\(strVersion)"
        }

        if let strAppId = SPLTConfig.APP_ID {
            strAdTagParameters += "&app_id=\(strAppId)"
        }
        
        if let strAppUrl = SPLTConfig.APP_URL {
            strAdTagParameters += "&app_url=\(strAppUrl)"
        }
        
        if let strAppName = SPLTConfig.APPNAME {
            strAdTagParameters += "&app_name=\(strAppName)"
        }
        
        let strBundleIdfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        strAdTagParameters += "&device_ifa=\(strBundleIdfa)"
        
        strAdTagParameters += "&device_make=Apple"
        print(UIDevice.current.model)
        strAdTagParameters += "&device_model=\(UIDevice.current.model)"
        
        #if os(tvOS)
        strAdTagParameters += "&device_type=apple_tv"
        strAdTagParameters += "&secure=true"
        #else
        strAdTagParameters += "&device_type=ios"
        #endif
        
        strAdTagParameters += "&device_os_version=\(UIDevice.current.systemVersion)"
        strAdTagParameters += "&vpi=MP4"
        
        let encodedAdTagParams = strAdTagParameters.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        return encodedAdTagParams //strAdTagParameters
    }
    
//    open func getAdTagForVideo(_ strVideoId: String, width: Int, height: Int, completion: @escaping (_ adTagsDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//        
//        var strAdTagUrl = SPLTRouter.getAdTags(strVideoId, width, height).URLString
//        if let strVmapAdTagParameters = SPLTAdsAPI.getVmapAdTagParameters() {
//            strAdTagUrl += "?\(strVmapAdTagParameters)"
//        }
//
//        let headers = ["device-type":"AppleTV"]
//        SPLTBaseAPI.sessionManager.request(strAdTagUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
//            //                debugPrint(response)
//            if (response.result.value != nil) {
//                if let infoDict = response.result.value as? [String: AnyObject],
//                    let bSuccess = infoDict["success"] as? Bool, bSuccess == true,
//                    let tagsDict = infoDict["tags"] as? [String: AnyObject] {
//                    completion(tagsDict)
//                    return
//                }
//            }
//            completionError(NSError(domain: "SPLTAdsAPI", code: 1, userInfo: nil))
//        }
//    }
}






