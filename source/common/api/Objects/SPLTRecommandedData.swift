//
//  SPLTRecommandedData.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 30/01/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation

open class SPLTRecommandedData: NSObject { //, DTSZChannelAPIDelegate {
    
    open var categoryMoreLikeThis: SPLTCategory?
    init(categoryMoreLikeThis: SPLTCategory) {
        super.init()
        self.categoryMoreLikeThis = categoryMoreLikeThis
        categoryMoreLikeThis.delegate = self
    }
    open var allRecommendationVideos: [SPLTVideo] = []
    open var recommendationVideos: [SPLTVideo] {
        get {
            if allRecommendationVideos.count > 0 {
                let randomNos = K10Utility.getRandomNumbers(10, fromAvailableTotalNos: allRecommendationVideos.count)
                var filteredRecommendationVideos: [SPLTVideo] = []
                for randomNo in randomNos {
                    filteredRecommendationVideos.append(allRecommendationVideos[randomNo])
                }
                return filteredRecommendationVideos
            } else {
                return []
            }
        }
    }

    open func setupAllRecommendationVideos() {
        if let categoryMoreLikeThis = self.categoryMoreLikeThis {
            if categoryMoreLikeThis.channels.count > 0 {
                if let channelMoreLikeThis = categoryMoreLikeThis.channels[0] as? SPLTPlaylistChannel {
                    self.allRecommendationVideos = channelMoreLikeThis.playlistVideos
                }
            }
        }
    }
    
    
}

//MARK: -
//MARK: - extension SPLTCategoryDelegate
extension SPLTRecommandedData: SPLTCategoryDelegate {
    open func didUpdateCategoryChannels() {
        // Category channels updated.
        if let categoryMoreLikeThis = self.categoryMoreLikeThis {
            if categoryMoreLikeThis.channels.count > 0 {
                let channelMoreLikeThis = categoryMoreLikeThis.channels[0]
                
                channelMoreLikeThis.loadFullChannel({ (channelDict) in
                    // completion
                    self.setupAllRecommendationVideos()
                }, completionError: { (error) in
                    print("error in loading full channel for swipy")
                })
            }
//            categoryMoreLikeThis.loadCategoryChannels(completion: { (dictCategoryChannel) in
//                // received recommanded channel.
//            }, completionError: { (error) in
//                // Error while receiving channel.
//            })
        }
    }
    open func didUpdateCategoryChannelsForCategory(_ category: SPLTCategory) {
        
    }
}










