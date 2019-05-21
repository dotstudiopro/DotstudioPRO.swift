//
//  SPLTWatchlistAPI.swift
//  DotstudioAPI
//
//  Created by Ketan Sakariya on 29/05/18.
//

import Foundation
import Alamofire

open class SPLTWatchlistAPI {
    public init() {
        
    }
    open func addChannelToWatchlist(_ strChannelId: String, strParentChannelId: String?, completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        var jsonDict: [String: Any] = [:]
        jsonDict["channel_id"] = strChannelId
        
        if let parentChannelId = strParentChannelId {
            jsonDict["parent_channel_id"] = parentChannelId
        }

        SPLTBaseAPI.sessionManager.request(SPLTRouter.addChannelToWatchlist, method: .post, parameters: jsonDict, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    completion(infoDict)
                    return
                }
            }
            completionError(NSError(domain: "SPLTWatchlistAPI", code: 1, userInfo: nil))
        }
    }
    
    open func getWatchlistChannels(_ completion: @escaping (_ watchlistDicts: [[String: Any]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.getWatchlistChannels, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let watchlistDicts = infoDict["channels"] as? [[String: AnyObject]] {
                        completion(watchlistDicts)
                        return
                    }
                }
            }
            completionError(NSError(domain: "SPLTWatchlistAPI", code: 1, userInfo: nil))
        }
        
    }
    open func deleteChannelFromWatchlist(_ strChannelId: String, completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        var jsonDict: [String: Any] = [:]
        jsonDict["channel_id"] = strChannelId
        SPLTBaseAPI.sessionManager.request(SPLTRouter.deleteWatchlistChannel, method: .delete, parameters: jsonDict, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool, bSuccess == true {
                        completion(infoDict)
                    }
                    return
                }
            }
            completionError(NSError(domain: "SPLTWatchlistAPI", code: 1, userInfo: nil))
        }
        
    }
}









