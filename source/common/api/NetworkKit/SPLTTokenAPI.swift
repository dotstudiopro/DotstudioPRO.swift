//
//  SPLTTokenAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 22/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

public protocol SPLTTokenAPIDelegate: NSObjectProtocol {
    func didReceiveToken(_ strToken: String)
    func didFailedTokenAPICall()
}

open class SPLTTokenAPI {
    
    open var delegate: SPLTTokenAPIDelegate?
    
    public init() {
        
    }
    
    open func getToken(_ completion: @escaping (_ strToken: String) -> Void) {
        
        // MARK: URLStringConvertible
        
        if SPLTAppVersionCheckerUtility.shared.spltSeverityLevel == .level_4 {
            return
        }
//        let strUrl: URLStringConvertible = SPLTRouter.Token.URLString
        let parameters = [
            "key": SPLTRouter.API_KEY,
        ]

        Alamofire.request(SPLTRouter.token, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    //self.delegate?.didReceiveChannels(infoDict)
                    print(infoDict)
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let strAccessToken = infoDict["token"] as? String {
                                SPLTRouter.strAccessToken = strAccessToken
                                UserDefaults.standard.setValue(strAccessToken, forKey: "strAccessToken")
                                UserDefaults.standard.synchronize()
                                completion(strAccessToken) //"str-Token")
                                return
                            }
                        }
                    }
                }
            } else {
//                self.delegate?.didFailedChannelsAPICall()
            }
        }
        
    }
    
    open func refreshAllTokens(_ completion: @escaping (_ strToken: String?) -> Void) {
        self.getToken { (strToken) -> Void in
            self.refreshToken({ (strClientToken) -> Void in
                completion(strClientToken)
            })
        }
    }
    open func refreshToken(_ completion: @escaping (_ strToken: String?) -> Void) {
        // MARK: URLStringConvertible
        
        if SPLTRouter.strClientToken == nil {
            // Logout & return
            completion(nil)
            return
        }
        let headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
            "x-client-token": SPLTRouter.strClientToken!
        ]
        
        Alamofire.request(SPLTRouter.refreshToken, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let strClientToken = infoDict["client_token"] as? String {
                                SPLTRouter.strClientToken = strClientToken
                                UserDefaults.standard.setValue(strClientToken, forKey: "strClientToken")
                                UserDefaults.standard.synchronize()
                                completion(strClientToken)
                                return
                            }
                        }
                    }
                }
            } else {
                //                self.delegate?.didFailedChannelsAPICall()
            }
            completion(nil)
        }
        
    }
    
    
    open class func checkTokenExpiryAndRefresh(_ completion: @escaping (_ bRefresedToken: Bool) -> Void) {
        if SPLTTokenAPI.isTokenExpired() == true {
            // refresh token & return true
            SPLTTokenAPI().refreshAllTokens({ (strToken) in
                completion(true)
            })
            return
        }
        completion(false)
    }
    open class func checkAccessTokenExpiryAndRefresh(_ completion: @escaping (_ bRefresedToken: Bool) -> Void) {
        if SPLTTokenAPI.isAccessTokenExpired() == true {
            // refresh token & return true
            SPLTTokenAPI().refreshAllTokens({ (strToken) in
                completion(true)
            })
            return
        }
        completion(false)
    }
    open class func isTokenExpired() -> Bool {
        if SPLTTokenAPI.isAccessTokenExpired() {
            return true
        }
        if SPLTTokenAPI.isClientTokenExpired() {
            return true
        }
        return false
    }
    open class func isAccessTokenExpired() -> Bool {
        if let strAccessToken = SPLTRouter.strAccessToken {
            do {
                let jwt = try decode(strAccessToken)
                if let iExpiryMiliseconds = jwt.body["expires"] as? Int {
                    let iCurMiliseconds = Int(Date().timeIntervalSince1970 * 1000)
                    print(iExpiryMiliseconds)
                    print(iCurMiliseconds)
                    if iExpiryMiliseconds < iCurMiliseconds {
                        print("Access Token Expired")
                        return true
                    } else {
                        print("Access Token not Expired")
                        return false
                    }
                }
            } catch {
                print("Something went wrong!")
            }
        }
        return true // return true as access token is not available.
    }
    open class func isClientTokenExpired() -> Bool {
        if let strClientToken = SPLTRouter.strClientToken {
            do {
                let jwt = try decode(strClientToken)
                if let iExpiryMiliseconds = jwt.body["expires"] as? Int {
                    let iCurMiliseconds = Int(Date().timeIntervalSince1970 * 1000)
                    print(iExpiryMiliseconds)
                    print(iCurMiliseconds)
                    if iExpiryMiliseconds < iCurMiliseconds {
                        print("Client Token Expired")
                        return true
                    } else {
                        print("Client Token not Expired")
                    }
                }
                
            } catch {
                print("Something went wrong!")
            }
        }
        return false
    }
}


