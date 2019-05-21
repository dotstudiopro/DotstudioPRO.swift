//
//  SPLTLoginAPI.swift
//  RevryApp-tvOS
//
//  Created by Anwer on 6/12/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import UIKit
import Alamofire

open class SPLTLoginVerificationAPI {
    public init() {}
    
    open func getDeviceLoginCode(completion: @escaping (_ strDeviceCode: String) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTBaseAPI.sessionManager.request(SPLTRouter.getNewDeviceCode, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success( _):
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        if let bSuccess = infoDict["success"] as? Bool, bSuccess == true {
                            if let strDeviceCode = infoDict["code"] as? String{
                                completion(strDeviceCode)
                                return
                            }
                        }
                    }
                }
            case .failure(let error):
                if let responseData = response.data {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) {
                        print(jsonObject)
                        if let dict = jsonObject as? [String: Any] {
                            let customError = NSError(domain:"SPLTLoginAPI", code:400, userInfo:dict)
                            completionError(customError)
                            return
                        }
                    }
                    
                }
                print("Request failed with error: \(error)")
            }
            completionError(NSError(domain: "SPLTLoginAPI", code: 1, userInfo: nil))
        }
    }
    
    open func verifyDeviceLoginCode(_ verificationCode: String, completion: @escaping (_ bVerificationSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.verifyDeviceCode(verificationCode), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            switch response.result {
            case .success( _):
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        if let bSuccess = infoDict["success"] as? Bool , bSuccess == true {
                            if let strClientToken = infoDict["result"] as? String{
                                SPLTRouter.strClientToken = strClientToken
                                UserDefaults.standard.setValue(strClientToken, forKey: "strClientToken")
                                UserDefaults.standard.synchronize()
                                // Login successful
                                NotificationCenter.default.post(name: Notification.Name.SPLT_LOGIN_COMPLETED, object: nil)
                                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.login, video: nil)
                            }
                            completion(bSuccess)
                            return
                        }
                    }
                }
            case .failure(let error):
                if let responseData = response.data {
                    if let jsonObject = try? JSONSerialization.jsonObject(with: responseData, options: .mutableLeaves) {
                        print(jsonObject)
                        if let dict = jsonObject as? [String: Any] {
                            let customError = NSError(domain:"SPLTLoginAPI", code:400, userInfo:dict)
                            completionError(customError)
                            return
                        }
                    }
                    
                }
                print("Request failed with error: \(error)")
            }
            completionError(NSError(domain: "SPLTLoginAPI", code: 1, userInfo: nil))
        }
        
    }
    
    

}
