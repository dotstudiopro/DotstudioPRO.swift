//
//  SPLTChannelAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 24/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

public protocol SPLTChannelAPIDelegate: NSObjectProtocol {
    func didReceiveChannel(_ spotlightChannels_: [String: AnyObject])
    func didFailedChannelAPICall()
}

open class SPLTChannelAPI {
    
    open var delegate: SPLTChannelAPIDelegate?
    
    public init() {
        
    }
    
    open func getCategoryChannel(_ strCategorySlug: String, strChannelSlug: String, completion: ((_ channelDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        if let strAccessToken = SPLTRouter.strAccessToken {
            SPLTBaseAPI.sessionManager.request(SPLTRouter.categoryChannel(strCategorySlug, strChannelSlug), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
                if (response.result.value != nil) {
                    if let infoDict = response.result.value as? [String: AnyObject] {
                        if let success = infoDict["success"] as? Bool {
                            if success == true {
                                if let channels = infoDict["channels"] as? [[String: AnyObject]] {
                                    if (channels.count>0) {
                                        let channelDict = channels[0]
                                        self.delegate?.didReceiveChannel(channelDict)
                                        completion?(channelDict)
                                        return
                                    }
                                }
                            }
                        }
                    }
                }
                self.delegate?.didFailedChannelAPICall()
                completionError?(NSError(domain: "SPLTChannelAPI", code: 1, userInfo: nil))
            }
        } else {
            SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
                self.getCategoryChannel(strCategorySlug, strChannelSlug: strChannelSlug, completion: completion, completionError: completionError)
            }
        }

    }
    
    


    open func getChannel(_ strChannelSlug: String, completion: ((_ channelDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        SPLTBaseAPI.sessionManager.request(SPLTRouter.channel(strChannelSlug), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let success = infoDict["success"] as? Bool {
                        if success == true {
                            if let channels = infoDict["channels"] as? [[String: AnyObject]] {
                                if (channels.count>0) {
                                    let channelDict = channels[0]
                                    self.delegate?.didReceiveChannel(channelDict)
                                    completion?(channelDict)
                                    return
                                }
                            }
                        }
                    }
                }
            }
            self.delegate?.didFailedChannelAPICall()
            completionError?(NSError(domain: "SPLTChannelAPI", code: 1, userInfo: nil))
        }
    }


    open func getPartialChannel(_ strChannelSlug: String, completion: ((_ channelDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        let urlString = SPLTRouter.channel_Partial(strChannelSlug).URLString
        let url = URL(string: urlString)!
        SPLTBaseAPI.sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let success = infoDict["success"] as? Bool {
                        if success == true {
                            if let channels = infoDict["channels"] as? [[String: AnyObject]] {
                                if (channels.count>0) {
                                    let channelDict = channels[0]
                                    self.delegate?.didReceiveChannel(channelDict)
                                    completion?(channelDict)
                                    return
                                }
                            }
                        }
                    }
                }
            }
            self.delegate?.didFailedChannelAPICall()
            completionError?(NSError(domain: "SPLTChannelAPI", code: 1, userInfo: nil))
        }
    }
    open func getLeanChannel(_ strChannelSlug: String, completion: ((_ channelDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        let urlString = SPLTRouter.channel_Lean(strChannelSlug).URLString
        let url = URL(string: urlString)!
        SPLTBaseAPI.sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let success = infoDict["success"] as? Bool {
                        if success == true {
                            if let channels = infoDict["channels"] as? [[String: AnyObject]] {
                                if (channels.count>0) {
                                    let channelDict = channels[0]
                                    self.delegate?.didReceiveChannel(channelDict)
                                    completion?(channelDict)
                                    return
                                }
                            }
                        }
                    }
                }
            }
            self.delegate?.didFailedChannelAPICall()
            completionError?(NSError(domain: "SPLTChannelAPI", code: 1, userInfo: nil))
        }
    }
    
    
    
    open func regenerateAccessTokenAndGetPurchasedCategoryChannel(_ strPurchasedCategoryChannelSlug: String, completion: @escaping (_ channelDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.getPurchasedCategoryChannel(strPurchasedCategoryChannelSlug, completion: completion, completionError: completionError)
        }
    }
    open func getPurchasedCategoryChannel(_ strPurchasedCategoryChannelSlug: String, completion: @escaping (_ channelDict: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTBaseAPI.sessionManager.request(SPLTRouter.purchasedCategoryChannel(strPurchasedCategoryChannelSlug), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in            
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let success = infoDict["success"] as? Bool {
                        if success == true {
                            if let channels = infoDict["channels"] as? [[String: AnyObject]] {
                                if (channels.count>0) {
                                    let channelDict = channels[0]
                                    completion(channelDict)
                                    self.delegate?.didReceiveChannel(channelDict)
                                    return
                                }
                            }
                        }
                    }
                }
            }
            completionError(NSError(domain: "SPLTChannelAPI", code: 1, userInfo: nil))
        }
    }
}



