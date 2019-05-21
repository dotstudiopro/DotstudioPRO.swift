//
//  SPLTCustomPlaylistChannel.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 13/04/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation


public enum SPLTCustomPlaylistChannelType {
    case none
    case continueWatching
    case watchAgain
}

open class SPLTCustomPlaylistChannel: SPLTPlaylistChannel {
    open var enumSPLTCustomPlaylistChannelType: SPLTCustomPlaylistChannelType = .none

    open var customChannelVideosArray: [[String: AnyObject]] = []
    init(_ enumSPLTCustomPlaylistChannelType: SPLTCustomPlaylistChannelType, customChannelVideosArray: [[String: AnyObject]]) {
        super.init()
        self.enumSPLTCustomPlaylistChannelType = enumSPLTCustomPlaylistChannelType
        switch self.enumSPLTCustomPlaylistChannelType {
            case .continueWatching:
                self.strTitle = "Continue Watching"
                break
            case .watchAgain:
                self.strTitle = "Watch Again"
                break
            default:
                break
        }
        self.customChannelVideosArray = customChannelVideosArray
        self.mapFromCustomChannelVideosArray(customChannelVideosArray)
    }

//    init(_ customChannelVideosArray: [[String: AnyObject]]) {
//        super.init()
//        self.customChannelVideosArray = customChannelVideosArray
//        self.mapFromCustomChannelVideosArray(customChannelVideosArray)
//    }
    open func mapFromCustomChannelVideosArray(_ customChannelVideosArray: [[String: AnyObject]]) {
        self.playlistVideos.removeAll()
        for customChannelVideoDict in customChannelVideosArray {
            let spltVideo = SPLTVideo()
            spltVideo.mapFromCustomPlaylistChannelVideoDict(customChannelVideoDict)
            self.playlistVideos.append(spltVideo)
        }
//        {
//            "_id": "586723f397f815b15161b53e",
//            "company_id": "57fe8fe399f815e309dbc2f4",
//            "title": "Mental Issue Problems",
//            "seriestitle": "Sheriffs El Dorado County",
//            "thumb": "586729b097f8150a5f61b53b",
//            "duration": 2303,
//            "point": 1162
//        }
        
//        if let strId = channelDict["_id"] as? String {
//            self.strId = strId
//        }
//        if let company_id = channelDict["company_id"] as? String {
//            self.spotlight_company_id = company_id
//        }
//        if let strTitle = channelDict["title"] as? String {
//            self.strTitle = strTitle
//        }
//        if let strSeriesTitle = channelDict["seriestitle"] as? String {
//            self.strSeriesTitle = strSeriesTitle
//        }
//        if let strThumb = channelDict["duration"] as? String {
//            self.strThumb = strThumb
//        }
//        if let poster = channelDict["poster"] as? String {
//            self.poster = poster
//        }
//        if let spotlight_poster = channelDict["spotlight_poster"] as? String {
//            self.spotlight_poster = spotlight_poster
//        }
    }
}




