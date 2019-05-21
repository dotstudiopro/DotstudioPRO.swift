//
//  SPLTWatchlistUtility.swift
//  RevryApp-tvOS
//
//  Created by Anwer on 6/25/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import UIKit
//import DotstudioAPI

public protocol SPLTWatchlistUtilityDelegate {
    func didUpdateWatchlistChannels(watchlistDicts: [[String: Any]])
    func didFailedToUpdateWatchlistChannels()
}
open class SPLTWatchlistUtility: NSObject {
    static public let shared = SPLTWatchlistUtility()
    
    open var delegate: SPLTWatchlistUtilityDelegate?
    open var watchlistDicts: [[String: Any]] = []
    
    open func reloadWatchList()
    {
        self.loadWatchlistChannels({ (watchlistChannelDicts) in
            // success
        }){ (error) in
            // error
        }
    }
    
    open func loadWatchlistChannels(_ completion: @escaping (_ watchlistDicts: [[String: Any]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        self.watchlistDicts.removeAll()
        SPLTWatchlistAPI().getWatchlistChannels({ (watchlistChannelDicts) in
            // success
            self.watchlistDicts = watchlistChannelDicts
            self.updateAllChannelsWatchlistInfo()
            completion(watchlistChannelDicts)
            self.delegate?.didUpdateWatchlistChannels(watchlistDicts: self.watchlistDicts)
        }) { (error) in
            // error
            completionError(error)
            self.delegate?.didFailedToUpdateWatchlistChannels()
        }
    }
    
    open func updateAllChannelsWatchlistInfo() {
        for category in SPLTCompanyData.sharedInstance.categories {
            for channel in category.channels {
                if self.isChannelInWatchlist(channel) {
                    channel.isInWatchlist = true
                } else {
                    channel.isInWatchlist = false
                }
            }
        }
    }
    
    open func addChannelToWatchlist(_ channel: SPLTChannel, completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if  let strChannelId = self.getChannelIdFromChannel(channel) {
            self.addChannelToWatchlist(strChannelId, strParentChannelId: self.getParentChannelId(channel), completion: { (infoDict) in
                channel.isInWatchlist = true
                completion(infoDict)
            }) { (error) in
                completionError(error)
            }
        }
    }
    
    open func addChannelToWatchlist(_ strChannelId: String, strParentChannelId: String?, completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTWatchlistAPI().addChannelToWatchlist(strChannelId, strParentChannelId: strParentChannelId, completion: { (responseDict) in
            completion(responseDict)
            self.reloadWatchList()
        }) { (error) in
            completionError(error)
        }
    }
    
    open func removeChannelFromWatchlist(_ channel: SPLTChannel , completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if let strChannelId = self.getChannelIdFromChannel(channel) {
            self.removeChannelFromWatchlist(strChannelId, completion: { (infoDict) in
                channel.isInWatchlist = false
                completion(infoDict)
            }) { (error) in
                completionError(error)
            }
        }
    }
    
    open func removeChannelFromWatchlist(_ strChannelId: String, completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTWatchlistAPI().deleteChannelFromWatchlist(strChannelId, completion: { (responseDict) in
            // success
            self.removeChannelFromArray(strChannelId)
            completion(responseDict)
            self.delegate?.didUpdateWatchlistChannels(watchlistDicts: self.watchlistDicts)
        }) { (error) in
            // error
            completionError(error)
        }
    }

    
    open func getChannelIdFromChannel(_ channel: SPLTChannel) -> String? {
        var strParamChannelId:String?
        if let multilevelChannel = channel as? SPLTMultiLevelChannel {
            if let firstChildChannel = multilevelChannel.childChannels.first {
                if let strChannelId = firstChildChannel.strId {
                    strParamChannelId = strChannelId
                }
            }
        } else {
            if let strChannelId = channel.strId {
                strParamChannelId = strChannelId
            }
        }
        return strParamChannelId
    }

    
    open func getParentChannelId(_ channel: SPLTChannel) ->  String? {
        var strParentChannelId:String?
        if let _ = channel as? SPLTMultiLevelChannel {
            if let strChannelId = channel.strId {
                strParentChannelId = strChannelId
            }
        } else {
            strParentChannelId = nil
        }
        return strParentChannelId
    }
    
    open func isChannelInWatchlist(_ channel: SPLTChannel) -> Bool {
        if let strParamChannelId = self.getChannelIdFromChannel(channel) {
            for (index, _) in self.watchlistDicts.enumerated() {
                let channel_ = self.watchlistDicts[index]
                if let strChannelId = channel_["_id"] as? String {
                    if strChannelId == strParamChannelId {
                        return true
                    }
                }
            }
        }
        return false
    }
    
    open func removeChannelFromArray(_ strChannelId: String){
        for (index, _) in self.watchlistDicts.enumerated() {
            let channel_ = self.watchlistDicts[index]
            if let channelId = channel_["_id"] as? String {
                if channelId == strChannelId {
                    self.watchlistDicts.remove(at: index)
                    break
                }
            }
        }
    }
}
