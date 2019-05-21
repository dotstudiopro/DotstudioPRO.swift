//
//  SPLTPlaylistChannel.swift
//  DotstudioPRO
//
//  Created by ketan on 07/04/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation

open class SPLTPlaylistChannel: SPLTChannel {
    
    override open var channelDict: [String: Any] {
        didSet {
        }
    }
    open var playlistDict: [[String: Any]] = [[:]] {
        didSet {
            self.playlistVideos.removeAll()
            for playlistVideo in playlistDict {
                let spltVideo = SPLTVideo(videoDict: playlistVideo)
                self.playlistVideos.append(spltVideo)
            }
//            self.getVideoProgressForChannelVideos({ (responseDictArray) in
//                // success
//            }) { (error) in
//                // error
//            }
//            self.delegate?.didUpdateCategoryChannels()
        }
    }
    open var playlistVideos: [SPLTVideo] = []
    open var playlist_id: String?
    
    override open func mapFromChannelDict(_ channelDict: [String: Any]) {
        super.mapFromChannelDict(channelDict)
        if let playlistDict = channelDict["playlist"] as? [[String: Any]] {
            self.playlistDict = playlistDict
        }
        if let playlist_id = channelDict["playlist_id"] as? String {
            self.playlist_id = playlist_id
        }
    }
    
    override open func isChannelVideosUpdated() -> Bool {
        return self.isPlaylistVideosUpdated()
    }
    override open func loadChannelVideos(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        self.loadPlaylistChannelVideos(completion, completionError: completionError)
    }



    ////MARK: -
    ////MARK: - SPLTPlaylistChannel Methods
    open func isPlaylistVideosUpdated() -> Bool {
        for playlistVideo in self.playlistVideos {
            if playlistVideo.bVideoUpdated == false {
                return false
            }
        }
        return true
    }
    open func loadPlaylistChannelVideos(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        for playlistVideo in self.playlistVideos {
            if playlistVideo.bVideoUpdated {
                continue
            } else {
                playlistVideo.loadPlaylistVideo({ (videoDict) in
                    // success
                    playlistVideo.bVideoUpdated = true
                    if self.isPlaylistVideosUpdated() {
                        completion(true)
                    } else {
                        self.loadPlaylistChannelVideos(completion, completionError: completionError)
                    }
                }, completionError: { (error) in
                    // Error
                    playlistVideo.bVideoUpdated = true
                })
                return
//                channel.loadFullChannel({ (dictCategoryChannel) in
//                    self.genericHomeViewController?.reloadData()
//                    self.loadAllChannelsOfCategory(category: category)
//                }, completionError: { (error) in
//                    channel.isFullChannelLoaded = true
//                })
//                return
            }

            
            
            
            
//            playlistVideo.loadPlaylistVideo({ (videoDict) in
//                    // success
//                    iTotalCallComplete += 1
//                    if self.isPlaylistVideosUpdated() {
//                        completion(true)
//                    }
//                }, completionError: { (error) in
//                    // Error
//                    iTotalCallComplete += 1
//            })
        }
    }
    
    override open func loadChannelVideoProgress(_ completion: ((_ channelDict: [[String: Any]]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        // load Video Progress
        var strVideoIds: [String] = []
        for playlistVideo in self.playlistVideos {
            if let strVideoId = playlistVideo.strId {
                strVideoIds.append(strVideoId)
            }
        }
        if strVideoIds.count == 0 || SPLTRouter.strClientToken == nil {
            completionError?(NSError(domain: "SPLTPlaylistChannel", code: 1, userInfo: nil))
            return
        }
        
        SPLTVideoProgressAPI().getVideoProgressForVideos(strVideoIds, completion: { (responseDictArray) in
            // success
            for responseDict in responseDictArray {
                if let strVideoId = responseDict["video_id"] as? String, let iPoint = responseDict["point"] as? Int {
                    let filteredVideos = self.playlistVideos.filter({ (spltVideo) -> Bool in
                        if spltVideo.strId == strVideoId {
                            return true
                        }
                        return false
                    })
                    if let filteredVideo = filteredVideos.first {
                        filteredVideo.progressPoint = iPoint
                    }
                }
            }
            completion?(responseDictArray)
        }) { (error) in
            // error
            completionError?(error)
        }
    }

}





