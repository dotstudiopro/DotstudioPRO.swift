//
//  SPLTAnalyticsAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 09/06/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire


open class SPLTAnalyticsAPI {

    open func sendAnalytics(_ analyticsEventsAPIObject: SPLTAnalyticsEventsAPIObject, completion: @escaping (_ completionDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
//        let strUrl = SPLTFullPathRouter.DTSZ_PLAYER_ANALYTICS.URLString
        
//        if let theJSONData = try? JSONSerialization.data(
//            withJSONObject: analyticsEventsAPIObject.toJsonDict(),
//            options: []) {
//            let theJSONText = String(data: theJSONData,
//                                     encoding: .ascii)
//            print("JSON Analytics string = \(theJSONText!)")
//        }
        
        
        let jsonDictAnalyticsEventsAPIObject = analyticsEventsAPIObject.toJsonDict()
//        if let session_id = jsonDictAnalyticsEventsAPIObject["session_id"] as? String { //analyticsEventsAPIObject.session_id {
//            print("analytics passed session ID :" + session_id)
//        } else {
//            print("analytics passed session ID : nil")
//        }
        SPLTBaseAPI.sessionManager.request(SPLTFullPathRouter.dtsz_PLAYER_ANALYTICS, method: .post, parameters: jsonDictAnalyticsEventsAPIObject, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    completion(infoDict)
//                    if let session_id = infoDict["session_id"] as? String {
//                        print("analytics received session ID :" + session_id)
//                    }
                    
                    return
//                    if let bSuccess = infoDict["success"] as? Bool {
//                        if (bSuccess == true) {
//                            if let dataDict = infoDict["data"] as? [String: AnyObject] {
//                                completion(completionDict: dataDict)
//                                return
//                            }
//                        }
//                    }
                }
                
            }
            completionError(NSError(domain: "SPLTAnalyticsAPI", code: 1, userInfo: nil))
        }
        
        #if (arch(i386) || arch(x86_64)) && (os(tvOS) || os(iOS))
            // uncomment to test analytics
//            self.sendAnalyticsEventsForTesting(analyticsEventsAPIObject, completion: { (completionDict) in
//                // success
//            }, completionError: { (error) in
//                // error
//            })
        #endif
    }

    open func sendAnalyticsEventsForTesting(_ analyticsEventsAPIObject: SPLTAnalyticsEventsAPIObject, completion: @escaping (_ completionDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        var jsonDict: [String: Any] = [:]
        #if os(tvOS)
            jsonDict["os"] = "tvOS"
        #else
            jsonDict["os"] = "iOS"
        #endif
        jsonDict["version"] = SPLTConfig.infoDictionaryBundleMain!["CFBundleShortVersionString"] as! String
        jsonDict["name"] = SPLTConfig.APPNAME!
        
        var headers:[String: String] = [:]
        if let strAccessToken = SPLTRouter.strAccessToken {
            headers["x-access-token"] = strAccessToken
        }
        if let strClientToken = SPLTRouter.strClientToken {
            headers["x-client-token"] = strClientToken
        }

        for analyticsEvent in analyticsEventsAPIObject.analyticsEvents {
                jsonDict["event"] = analyticsEvent.analyticsEventType?.rawValue
            SPLTBaseAPI.sessionManager.request(SPLTRouter.testingAnalytics, method: .post, parameters: jsonDict, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        completion(infoDict)
                        print(infoDict)
                        return
                    }
                }
                completionError(NSError(domain: "SPLTAnalyticsAPI", code: 1, userInfo: nil))
            }
        }
        
        
    }
    
}



