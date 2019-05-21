//
//  SPLTUserDetailAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 26/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

//public protocol SPLTCategoriesAPIDelegate: NSObjectProtocol {
//    func didReceiveCategories(spotlightCategories_: [[String: AnyObject]])
//    func didFailedCategoriesAPICall()
//}

open class SPLTUserDetailAPI {
    
//    public var delegate: SPLTCategoriesAPIDelegate?
    
    public init() {
        
    }
    
    //MARK: - GET USER DETAIL
    open func regenerateAccessTokenAndGetUserDetails(_ completion: @escaping (_ userDataDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.getUserDetails(completion, completionError: completionError)
        }
    }

    open func getUserDetails(_ completion: @escaping (_ userDataDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                return
            }
            self.regenerateAccessTokenAndGetUserDetails(completion, completionError: completionError)
            return
        }
//        let strUrl: URLStringConvertible = SPLTRouter.UserDetail.URLString
        SPLTBaseAPI.sessionManager.request(SPLTRouter.userDetail, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let userDataDict = infoDict["data"] as? [String: AnyObject] {
                                completion(userDataDict)
                                return
                            }
                        }
                    }
                }
            }
            completionError(NSError(domain: "SPLTUserDetailAPI", code: 1, userInfo: nil))
//            self.delegate?.didFailedCategoriesAPICall()
        }
        
    }


    //MARK: - UPDATE USER DETAIL
    open func regenerateAccessTokenAndUpdateUserDetails(_ firstName: String, lastName: String, completion: @escaping (_ userDataDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.updateUserDetails(firstName, lastName: lastName, completion: completion, completionError: completionError)
        }
    }
    open func updateUserDetails(_ firstName: String, lastName: String, completion: @escaping (_ userDataDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                return
            }
            self.regenerateAccessTokenAndUpdateUserDetails(firstName, lastName: lastName, completion: completion, completionError: completionError)
            return
        }

        let params = [
            "first_name": firstName,
            "last_name": lastName
        ]
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.userDetail, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let userDataDict = infoDict["data"] as? [String: AnyObject] {
                                completion(userDataDict)
                                return
                            }
                        }
                    }
                }
            }
            completionError(NSError(domain: "SPLTUserDetailAPI", code: 1, userInfo: nil))
            //            self.delegate?.didFailedCategoriesAPICall()
        }
        
    }

    
    //MARK: - Change USER Password
    //MARK: - UPDATE USER DETAIL
    open func regenerateAccessTokenAndChangeUserPassword(_ password: String, completion: @escaping (_ userDataDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.changeUserPassword(password, completion: completion, completionError: completionError)
        }
    }
    open func changeUserPassword(_ password: String, completion: @escaping (_ infoDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                return
            }
            self.regenerateAccessTokenAndChangeUserPassword(password, completion: completion, completionError: completionError)
            return
        }
        let params = [
            "password": password
        ]

        SPLTBaseAPI.sessionManager.request(SPLTRouter.changePassword, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            completion(infoDict)
                            return
                        }
                    }
                }
            }
            completionError(NSError(domain: "SPLTUserDetailAPI", code: 1, userInfo: nil))
            //            self.delegate?.didFailedCategoriesAPICall()
        }
        
    }
    
    
    
    //MARK: - UPDATE USER DETAIL
    open func regenerateAccessTokenAndUploadNewUserAvatar(_ image: UIImage, completion: @escaping (_ infoDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.uploadNewUserAvatar(image, completion: completion, completionError: completionError)
        }
    }
    func uploadNewUserAvatar(_ image: UIImage, completion: @escaping (_ infoDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                return
            }
            self.regenerateAccessTokenAndUploadNewUserAvatar(image, completion: completion, completionError: completionError)
            return
        }
        
        //let strUrl: URLStringConvertible = SPLTRouter.UpdateAvatar.URLString
        let headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
            "x-client-token": SPLTRouter.strClientToken!
        ]
        
        
        if let imageData = image.jpegData(compressionQuality: 0.7) {
//        let imageData: Data = UIImageJPEGRepresentation(image, 0.7)!
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(imageData, withName: "avatar", fileName: "avatar.jpeg", mimeType: "image/jpeg")
            }, to: SPLTRouter.updateAvatar, headers: headers) { (encodingResult) in
                switch encodingResult {
                case .success(let upload, _, _):
                    
                    upload.responseJSON { response in
    //                    print(response.request)  // original URL request
    //                    print(response.response) // URL response
    //                    print(response.data)     // server data
    //                    print(response.result)   // result of response serialization
                        if let infoDict = response.result.value as? [String: AnyObject] {
                            completion(infoDict)
                            return
                        }
                        debugPrint(response)
                        completionError(NSError(domain: "SPLTUserDetailAPI", code: 1, userInfo: nil))
                    }
                    
                    case .failure(let encodingError):
                        completionError(NSError(domain: "SPLTUserDetailAPI", code: 1, userInfo: nil))
    //                    print(encodingError)
                    
                }
            }

        }

        
    }

}



