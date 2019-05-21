//
//  SPLTMultiLevelChannel.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 15/01/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation

open class SPLTMultiLevelChannel: SPLTPlaylistChannel {
    
    
//    var childChannelDicts: [[String: AnyObject]] = [[:]] {
//        didSet {
//            
//        }
//    }
    open var childChannels: [SPLTChannel] = []
    
//    var playlistDict: [[String: AnyObject]] = [[:]] {
//        didSet {
//            self.playlistVideos.removeAll()
//            for playlistVideo in playlistDict {
//                let spltVideo = SPLTVideo(videoDict: playlistVideo)
//                self.playlistVideos.append(spltVideo)
//            }
//            //            self.delegate?.didUpdateCategoryChannels()
//        }
//    }
//    override var playlistVideos: [SPLTVideo] {
//        get {
//        }
//    }
//    var playlist_id: String?
    
    open override func resetSubscriptionStatus(_ completion: @escaping (Bool) -> Void, completionError: @escaping (NSError) -> Void) {
        var iTotalCallComplete: Int = 0
        var isAllCallCompleteSuccefully = true
        for childChannel in self.childChannels {
            let channelDict:[String: Any] = [:]
            childChannel.loadSubscriptionStatus(channelDict, loadChannelCompletion: { (channelDict) in
                iTotalCallComplete += 1
                if iTotalCallComplete == self.childChannels.count {
                    completion(isAllCallCompleteSuccefully)
                }
            }) { (error) in
                isAllCallCompleteSuccefully = false
                iTotalCallComplete += 1
                if iTotalCallComplete == self.childChannels.count {
                    completion(isAllCallCompleteSuccefully)
                }
            }
        }
    }
    
    open var iCurChildChannelIndex: Int = 0 {
        didSet {
            if self.iCurChildChannelIndex < self.childChannels.count {
                if let playlistChannel = self.childChannels[self.iCurChildChannelIndex] as? SPLTPlaylistChannel {
                    self.playlistVideos = playlistChannel.playlistVideos
                } else if let videoChannel = self.childChannels[self.iCurChildChannelIndex] as? SPLTVideoChannel {
                    if let video = videoChannel.video {
                        self.playlistVideos = [video]
                    }
                }
                
            }
        }
    }
    
    override open func mapFromChannelDict(_ channelDict: [String: Any]) {
        super.mapFromChannelDict(channelDict)
        if let childChannelDicts = channelDict["childchannels"] as? [[String: Any]] {
            self.childChannels.removeAll()
            for childChannelDict in childChannelDicts {
//                let spltChannel = SPLTPlaylistChannel(channelDict: childChannelDict)
                if let spltChannel = SPLTChannel.getChannelFromChannelDict(childChannelDict) {
                    self.childChannels.append(spltChannel)
                }
            }
            if self.childChannels.count > 0 {
                self.iCurChildChannelIndex = 0
            }
        }
//        if let playlistDict = channelDict["playlist"] as? [[String: AnyObject]] {
//            self.playlistDict = playlistDict
//        }
//        if let playlist_id = channelDict["playlist_id"] as? String {
//            self.playlist_id = playlist_id
//        }
    }
    
    override open func isChannelVideosUpdated() -> Bool {
        return self.isMultiLevelChannelVideosUpdated()
    }
    override open func loadChannelVideos(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        self.loadMultilevelChannelVideos(completion, completionError: completionError)
    }
    
}


////MARK: -
////MARK: - SPLTMultiLevelChannel Methods
extension SPLTMultiLevelChannel {
    open func isMultiLevelChannelVideosUpdated() -> Bool {
        for childChannel in self.childChannels {
            if let playlistChannel = childChannel as? SPLTPlaylistChannel {
                for playlistVideo in playlistChannel.playlistVideos {
                    if playlistVideo.bVideoUpdated == false {
                        return false
                    }
                }
            }
        }
        return true
    }
    open func loadMultilevelChannelVideos(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: (_ error: NSError) -> Void) {
        var iTotalCallComplete: Int = 0
        var iTotalMultilevelChannelVideos = 0
        for childChannel in self.childChannels {
            if let playlistChannel = childChannel as? SPLTPlaylistChannel {
                for playlistVideo in playlistChannel.playlistVideos {
                    iTotalMultilevelChannelVideos += 1
                    playlistVideo.loadPlaylistVideo({ (videoDict) in
                        // success
                        iTotalCallComplete += 1
                        if self.isMultiLevelChannelVideosUpdated() {
                            completion(true)
                        } else if iTotalCallComplete == iTotalMultilevelChannelVideos {
                            completion(false)
                        }
                    }, completionError: { (error) in
                        // Error
                        iTotalCallComplete += 1
                        if iTotalCallComplete == iTotalMultilevelChannelVideos {
                            completion(false)
                        }
                    })
                }
            } else if let videoChannel = self.childChannels[self.iCurChildChannelIndex] as? SPLTVideoChannel {
                if let video = videoChannel.video {
                    video.loadFullVideo({ (videoDict) in
                        completion(true)
                    }) { (error) in
                        completion(false)
                    }
                }
            }
        }
    }
}














