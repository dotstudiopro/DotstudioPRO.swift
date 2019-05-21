//
//  SPLTSubscriptionAPI.swift
//  DotstudioAPI
//
//  Created by Ketan Sakariya on 24/05/18.
//

import Foundation
import Alamofire

open class SPLTSubscriptionAPI {
    public init() {
        
    }
    
    open func getSubscriptionProducts(completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {

        SPLTBaseAPI.sessionManager.request(SPLTRouter.getSubscriptionPlans, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success( _):
                if (response.result.value != nil) {
                    if let subscriptionsDict = response.result.value as? [String: Any] {
                        if let bSuccess = subscriptionsDict["success"] as? Bool, bSuccess == true {
                            completion(subscriptionsDict)
                            return
                        }
                    }
                }
            case .failure(let error):
                if let responseData = response.data {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) {
                        print(jsonObject)
                        if let dict = jsonObject as? [String: Any] {
                            let customError = NSError(domain:"SPLTSubscriptionListAPI", code:400, userInfo:dict)
                            completionError(customError)
                            return
                        }
                    }
                }
                print("Request failed with error: \(error)")
            }
            completionError(NSError(domain: "SPLTSubscriptionListAPI", code: 1, userInfo: nil))
        }
    }
    
    open func checkSubscriptionStatus(_ strChannelId: String, completion: @escaping (_ bSubscriptionUnlocked: Bool, _ bAdsEnabled: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.checkSubscriptionStatus(strChannelId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            
            switch response.result {
            case .success(let data):
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        var bUnlocked = false
                        var bAdsEnabled = false
                        if let bUnlocked_ = infoDict["unlocked"] as? Bool {
                            bUnlocked = bUnlocked_
                        }
                        if let bAdsEnabled_ = infoDict["ads_enabled"] as? Bool {
                            bAdsEnabled = bAdsEnabled_
                        }
                        completion(bUnlocked, bAdsEnabled)
                        //completion(infoDict)
                        return
                    }
                }
            case .failure(let error):
                if let responseData = response.data {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) {
                        print(jsonObject)
                        if let dict = jsonObject as? [String: Any] {
                            let customError = NSError(domain:"SPLTSubscriptionAPI", code:400, userInfo:dict)
                            completionError(customError)
                            return
                        }
                    }
                    
                }
                print("Request failed with error: \(error)")
            }
            

            completionError(NSError(domain: "SPLTSubscriptionAPI", code: 1, userInfo: nil))
        }
        
    }
    
    open func postSubscriptionReceiptData(_ strBase64EncodedReceipt: String, strProductId: String, completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        var jsonDict: [String: Any] = [:]
        jsonDict["latest_receipt"] = strBase64EncodedReceipt
        jsonDict["notification_type"] = "INITIAL_BUY"
        jsonDict["product_id"] = strProductId //"monthly"
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.subscriptionAppleReceiptPost, method: .post, parameters: jsonDict, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        completion(infoDict)
                        return
                    }
                }
            case .failure(let error):
                if let responseData = response.data {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) {
                        print(jsonObject)
                        if let dict = jsonObject as? [String: Any] {
                            let customError = NSError(domain:"SPLTSubscriptionAPI", code:400, userInfo:dict)
                            completionError(customError)
                            return
                        }
                    }
                }
                print("Request failed with error: \(error)")
            }
            completionError(NSError(domain: "SPLTSubscriptionAPI", code: 1, userInfo: nil))
        }
    }
    
    open func getActiveSubscriptions(_ completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.getActiveSubscriptions, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success(let data):
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        completion(infoDict)
                        return
                    }
                }
            case .failure(let error):
                if let responseData = response.data {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) {
                        print(jsonObject)
                        if let dict = jsonObject as? [String: Any] {
                            let customError = NSError(domain:"SPLTSubscriptionAPI", code:400, userInfo:dict)
                            completionError(customError)
                            return
                        }
                    }
                }
                print("Request failed with error: \(error)")
            }
            completionError(NSError(domain: "SPLTSubscriptionAPI", code: 1, userInfo: nil))
        }
    }
}
