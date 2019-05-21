//
//  SPLTChannels.swift
//  DotstudioPRO
//
//  Created by ketan on 19/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

public protocol SPLTChannelsAPIDelegate: NSObjectProtocol {
    func didReceiveChannels(_ spotlightChannels_: [[String: AnyObject]])
    func didFailedChannelsAPICall()
}

open class SPLTChannelsAPI {
    
    open var delegate: SPLTChannelsAPIDelegate?
    
    public init() {
        
    }
    
    open func getChannels() {
        SPLTBaseAPI.sessionManager.request(SPLTRouter.channels_Lean, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let channelsDict = infoDict["channels"] as? [[String: AnyObject]] {
                        self.delegate?.didReceiveChannels(channelsDict)
                        return
                    }
                }
            } else {
                self.delegate?.didFailedChannelsAPICall()
            }
        }
        
    }
    
    open func regenerateAccessTokenAndGetChannelsOfCategory(_ strCategorySlug: String, completion: @escaping (_ categoryChannels: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().getToken { (strToken) -> Void in
            self.getChannelsOfCategory(strCategorySlug: strCategorySlug, completion: completion, completionError: completionError)
        }
    }
    open func getChannelsOfCategory(_ bLeanData: Bool? = true, strCategorySlug: String, completion: @escaping (_ categoryChannels: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        var urlConvertible = SPLTRouter.categoryChannels(strCategorySlug)
        if bLeanData == true {
            urlConvertible = SPLTRouter.categoryChannelsLean(strCategorySlug)
        }
        if (SPLTRouter.strAccessToken == nil) {
            self.regenerateAccessTokenAndGetChannelsOfCategory(strCategorySlug, completion: completion, completionError: completionError)
            return
        }
        /*let headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
            ]*/
        //        let parameters = [
        //            "detail": "lean",
        //        ]
        let url = URL(string: urlConvertible.URLString)!
        SPLTBaseAPI.sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let channelsDict = infoDict["channels"] as? [[String: AnyObject]] {
                        completion(channelsDict)
                        //self.delegate?.didReceiveChannels(channelsDict)
                        return
                    }
                }
            } else {
//                self.delegate?.didFailedChannelsAPICall()
            }
            completionError(NSError(domain: "SPLTChannelsAPI", code: 1, userInfo: nil))
        }
    }
    
    
    //MARK: - With Block methods
    open func regenerateAccessTokenAndGetChannels(_ completion: @escaping (_ channelsDict: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().getToken { (strToken) -> Void in
            self.getChannels(completion, completionError: completionError)
        }
    }
    
    open func getChannels(_ completion: @escaping (_ channelsDict: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if (SPLTRouter.strAccessToken == nil) {
            self.regenerateAccessTokenAndGetChannels(completion, completionError: completionError)
            return
        }
        
//        let strUrl: URLStringConvertible = SPLTRouter.Channels_Lean.URLString
        SPLTBaseAPI.sessionManager.request(SPLTRouter.channels_Lean, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
                    if let httpURLResponse = response.response {
                        if (httpURLResponse.statusCode == 403) {
                            // regenerate accesstoken
                            self.regenerateAccessTokenAndGetChannels(completion, completionError: completionError)
                            return
                        }
                    }
                    
                    
                    if (response.result.value != nil) {
                        if let infoDict = response.result.value as? [String: AnyObject] {
                            if let channelsDict = infoDict["channels"] as? [[String: AnyObject]] {
                                completion(channelsDict)
                                return
                            }
                        }
                    }
                    completionError(NSError(domain: "SPLTChannelsAPI", code: 1, userInfo: nil))
        }
        
    }
    
}



