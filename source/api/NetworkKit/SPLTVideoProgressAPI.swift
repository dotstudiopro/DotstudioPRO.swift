//
//  SPLTVideoProgressAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 09/05/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire


open class SPLTVideoProgressAPI {
    
    //    public var delegate: SPLTCategoriesAPIDelegate?
    
    public init() {
        
    }
    
    
    // SET Video Progress
    open func regenerateAccessTokenAndSetVideoProgress(_ videoId: String, iVideoDuration: Int, completion: @escaping (_ responseDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.setVideoProgress(videoId, iVideoDuration: iVideoDuration, completion: completion, completionError: completionError)
        }
        
    }
    open func setVideoProgress(_ videoId: String, iVideoDuration: Int, completion: @escaping (_ responseDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                return
            }
            self.regenerateAccessTokenAndSetVideoProgress(videoId, iVideoDuration: iVideoDuration, completion: completion, completionError: completionError)
            return
        }
        SPLTBaseAPI.sessionManager.request(SPLTRouter.setVideoProgress(videoId, iVideoDuration), method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    completion(infoDict)
                    return
                }
            }
            completionError(NSError(domain: "SPLTVideoProgressAPI", code: 1, userInfo: nil))
        }
        
    }
    

    // GET Video Progress
    open func regenerateAccessTokenAndGetVideoProgress(_ videoId: String, completion: @escaping (_ responseDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.getVideoProgress(videoId, completion: completion, completionError: completionError)
        }
        
    }
    open func getVideoProgress(_ videoId: String, completion: @escaping (_ responseDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
        
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                completionError(NSError(domain: "SPLTVideoProgressAPI", code: 1, userInfo: nil))
                return
            }
            self.regenerateAccessTokenAndGetVideoProgress(videoId, completion: completion, completionError: completionError)
            return
        }
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.getVideoProgress(videoId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject],
                    let bSuccess = infoDict["success"] as? Bool, bSuccess == true,
                    let dataDict = infoDict["data"] as? [String: AnyObject] {
                    
                    completion(dataDict)
                    return
                }
            }
            completionError(NSError(domain: "SPLTVideoProgressAPI", code: 1, userInfo: nil))
        }
        
    }
    //let sessionManager = SessionManager()
    open func getVideoProgressForVideos(_ videoIds: [String], completion: @escaping (_ responseDictArray: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if SPLTRouter.strClientToken == nil {
            completionError(NSError(domain: "SPLTVideoProgressAPI", code: 1, userInfo: nil))
        }
        
        let parameters = [
            "video_ids": videoIds
        ]
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.getVideoProgressForVideos, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
//                debugPrint(response)
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject],
                        let bSuccess = infoDict["success"] as? Bool, bSuccess == true,
                        let dataDictArray = infoDict["data"] as? [[String: AnyObject]] {
                        completion(dataDictArray)
                        return
                    }
                }
                completionError(NSError(domain: "SPLTVideoProgressAPI", code: 1, userInfo: nil))
            }
    }
    
    
}

