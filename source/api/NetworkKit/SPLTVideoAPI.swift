//
//  SPLTVideoAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 25/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

public protocol SPLTVideoAPIDelegate: NSObjectProtocol {
    func didReceiveVideoData(_ infoDict: [String: AnyObject])
//    func didReceiveChannel(spotlightChannels_: [String: AnyObject])
    func didFailedVideoAPICall()
}

open class SPLTVideoAPI: SPLTBaseAPI {
    
    open var delegate: SPLTVideoAPIDelegate?
    
    public override init() {
        
    }
    
    open func regenerateAccessTokenAndGetCategoryChannelVideo(_ strCategorySlug: String, strChannelSlug: String, strVideoId: String) {
        
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.getCategoryChannelVideo(strCategorySlug, strChannelSlug: strChannelSlug, strVideoId: strVideoId)
        }
        
    }
    
    open func getCategoryChannelVideo(_ strCategorySlug: String, strChannelSlug: String, strVideoId: String) {
        // MARK: URLStringConvertible
        SPLTBaseAPI.sessionManager.request(SPLTRouter.categoryChannelVideo(strCategorySlug, strChannelSlug, strVideoId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    self.delegate?.didReceiveVideoData(infoDict)
                }
            } else {
                self.delegate?.didFailedVideoAPICall()
            }
        }
    }
    
    
    
    open func regenerateAccessTokenAndGetCategoryChannelVideo(_ strCategoryChannelSlug: String, strVideoId: String) {
        
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.getCategoryChannelVideo(strCategoryChannelSlug, strVideoId: strVideoId)
        }
        
    }
    open func getCategoryChannelVideo(_ strCategoryChannelSlug: String, strVideoId: String) {
        // MARK: URLStringConvertible
        SPLTBaseAPI.sessionManager.request(SPLTRouter.catChannelVideo(strCategoryChannelSlug, strVideoId), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    self.delegate?.didReceiveVideoData(infoDict)
                }
            } else {
                self.delegate?.didFailedVideoAPICall()
            }
        }
    }
    
    
    
    //MARK: - Video detail API
    //MARK: - Search Video Term
//    open func regenerateAccessTokenAndGetVideo(_ strVideoId: String, completion: @escaping (_ videoDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//        SPLTTokenAPI().getToken { (strToken) -> Void in
//            self.getVideo(strVideoId, completion: completion, completionError: completionError)
//        }
//    }
    open func getVideo(_ strVideoId: String, completion: @escaping (_ videoDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
//        let strUrl: URLStringConvertible = SPLTRouter.videoDetail(strVideoId).URLString
        var headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
            ]
        if let strClientToken = SPLTRouter.strClientToken {
            headers["x-client-token"] = strClientToken
        }
        
        
        let urlConvertible = SPLTRouter.videoPlay2(strVideoId)
        
        self.request = SPLTBaseAPI.sessionManager.request(urlConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    completion(infoDict)
                }
            }
            completionError(NSError(domain: "SPLTVideoAPI", code: 1, userInfo: nil))
        }
        
    }
    
    open func getVideoFromVideoSlug(_ strVideoSlug: String, completion: @escaping (_ videoDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        var headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
            ]
        if let strClientToken = SPLTRouter.strClientToken {
            headers["x-client-token"] = strClientToken
        }
        
        
        let urlConvertible = SPLTRouter.videoPlay2FromVideoSlug(strVideoSlug)
        
        self.request = SPLTBaseAPI.sessionManager.request(urlConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    completion(infoDict)
                }
            }
            completionError(NSError(domain: "SPLTVideoAPI", code: 1, userInfo: nil))
        }
        
    }
    
    
}







