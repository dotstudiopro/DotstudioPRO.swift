//
//  SPLTVideoChannel.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 04/01/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation

open class SPLTVideoChannel: SPLTChannel {
    
    override open var channelDict: [String: Any] {
        didSet {
        }
    }
    open var video: SPLTVideo?
    open var videoDict: [String: Any] = [:] {
        didSet {
            let spltVideo = SPLTVideo(videoDict: videoDict)
            self.video = spltVideo
        }
    }
    open var playlistVideos: [SPLTVideo] = []
    open var playlist_id: String?
    
    override open func mapFromChannelDict(_ channelDict: [String: Any]) {
        super.mapFromChannelDict(channelDict)
        if let videoDict = channelDict["video"] as? [String: Any] {
            self.videoDict = videoDict
        }
    }

    override open func isChannelVideosUpdated() -> Bool {
        return self.isVideoChannelUpdated()
    }
    override open func loadChannelVideos(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        self.loadChannelVideo(completion, completionError: completionError)
    }

    override open func getVideoProgressForChannelVideos(_ completion: @escaping (_ responseDictArray: [[String: Any]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if let video = self.video {
            let spltVideoProgressAPI = SPLTVideoProgressAPI()
            if let strVideoId = video.strId, SPLTRouter.strClientToken != nil {
                spltVideoProgressAPI.getVideoProgressForVideos([strVideoId], completion: { (responseDict) in
                    // success
                }, completionError: { (error) in
                    // error
                })
            }
        }
    }

}


////MARK: -
////MARK: - SPLTPlaylistChannel Methods
extension SPLTVideoChannel {
    open func isVideoChannelUpdated() -> Bool {
        if let video = self.video {
            return video.bVideoUpdated
        }
        return false
    }
    open func loadChannelVideo(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: (_ error: NSError) -> Void) {
        if let video = self.video {
            video.loadPlaylistVideo({ (videoDict) in
                // success
                completion(true)
            }, completionError: { (error) in
                // Error
            })
        }
    }
}





