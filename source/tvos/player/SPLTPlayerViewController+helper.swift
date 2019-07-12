//
//  TVOSPlayerViewController+helper.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 22/05/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import AVFoundation





extension SPLTPlayerViewController {
    
    open func saveVideoProgress() {
        if let curVideo = self.curVideo,
            let strVideoId = curVideo.strId,
            let currentTime_cmtime = self.avPlayerViewController.player?.currentTime(), currentTime_cmtime.isValid {
            let floatCurrentTime = CMTimeGetSeconds(currentTime_cmtime)
            if !floatCurrentTime.isNaN, !curVideo.isLiveStreaming {
                let currentTime: Int = Int(floatCurrentTime)
                self.curVideo?.progressPoint = currentTime
                SPLTVideoProgressAPI().setVideoProgress(strVideoId, iVideoDuration: currentTime, completion: { (responseDict) in
                        // success
                }, completionError: { (error) in
                        // error
                })
            }
        }
    }

    open func stopAndRemoveAVPlayerViewController() {
        self.saveVideoProgress()
        if let curVideo = self.curVideo {
            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.end_playback, video: curVideo)
            self.addAnalyticsEvent(.playback, analyticsEventType: .end_playback)
        }
        if let contentPlayer = self.contentPlayer {
            self.removeObservers(contentPlayer)
        }
        self.avPlayerViewController.player?.replaceCurrentItem(with: nil)
        self.avPlayerViewController.player = nil
        self.contentPlayer = nil
        self.avPlayerViewController.view.removeFromSuperview()
        self.avPlayerViewController.removeFromParent()
    }

    open func play(){
        if self.isAdPlayback {
            //self.skVastViewController?.play()
        } else {
            if let contentPlayer = self.contentPlayer {
                contentPlayer.play()
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_event, video: self.curVideo)
                self.addAnalyticsEvent(.playback, analyticsEventType: .play, message: self.curVideo?.strId)
            }
        }
    }
    
    open func pause() {
        if self.isAdPlayback {
            //self.skVastViewController?.pause()
        } else {
            if let contentPlayer = self.contentPlayer {
                contentPlayer.pause()
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.pause_event, video: self.curVideo)
                self.addAnalyticsEvent(.playback, analyticsEventType: .pause, message: self.curVideo?.strId)
            }
            
        }
    }
    
    
//    open func playPreRollAd() -> Bool {
//        //return self.playPreRollAdForSKVastVC()
//        //return self.playPreRollAdForGoogleIMAtvOSVC()
//
//    }

    open func updateWithVideoElapsedSeconds(_ iSeconds: Int, iDuration: Int) {
        if self.isAdPlayback {
            return
        }
        if let curVideo = self.curVideo {
            SPLTAnalyticsUtility.sharedInstance.trackEventWithElapsedTime(iSeconds, iDuration: iDuration, video: curVideo)
        }
        for (index, bVideoQuartileWatched) in bVideoQuartilesWatched.enumerated() {
            if !bVideoQuartileWatched {
                let iQuartileVideoPoint = ((index + 1) * iDuration / 4 )
                if iSeconds > iQuartileVideoPoint {
                    // Crossed quartile.
                    self.bVideoQuartilesWatched[index] = true
                    //print("quartile crossed : \(index)")
                    switch index {
                    case 0:
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_quartile_1, video: self.curVideo)
                        self.addAnalyticsEvent(.playback, analyticsEventType: .first_quartile)
                        break
                    case 1:
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_quartile_2, video: self.curVideo)
                        self.addAnalyticsEvent(.playback, analyticsEventType: .second_quartile)
                        break
                    case 2:
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_quartile_3, video: self.curVideo)
                        self.addAnalyticsEvent(.playback, analyticsEventType: .third_quartile)
                        break
                    default: break
                    }
                } else {
                    // break loop as if elapsed seconds didn't cross 1st quartile, no need to check 2nd & 3rd.
                    break
                }
            }
        }
    }
    open func didPlayingVideoAtPosition(_ time: CMTime, durationTime: CMTime) {
        
//        if let player = self.avPlayerViewController.player, player.status != .readyToPlay {
//            return
//        }
//        if let playerCurrentItem = self.avPlayerViewController.player?.currentItem {
//            if playerCurrentItem.status != .readyToPlay {
//                return
//            }
//        }
        
        if !time.isValid {
            return
        }
        let floatCurrentTime: Float64 = CMTimeGetSeconds(time)
        if (floatCurrentTime.isNaN) {
            return
        }
        let iCurrentTime = Int(floatCurrentTime)
        self.iCurElapsedSeconds = iCurrentTime
        if !self.isFirstFramePlayed {
            if let curVideo = self.curVideo {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_first_frame, video: curVideo)
                self.addAnalyticsEvent(.playback, analyticsEventType: .first_frame)
            }
            self.isFirstFramePlayed = true
        }
        
        if (self.avPlayerViewController.player!.currentItem == nil) {
            return
        }
        
        var iDurationTime = self.curVideo?.iDuration
        if let duration_cmtime = self.avPlayerViewController.player?.currentItem?.duration {
            if !duration_cmtime.isValid {
                return
            }
            let floatDuration: Float64 = CMTimeGetSeconds(duration_cmtime)
            if (floatDuration.isNaN) {
                return
            }
            iDurationTime = Int(floatDuration)
        }
        
        
        if let iDurationTime_ = iDurationTime {
            self.updateWithVideoElapsedSeconds(iCurrentTime, iDuration: iDurationTime_)
        }
        self.didPlayingVideoAtPosition(iCurrentTime, iDurationTime: iDurationTime)
    }
    
    open func didPlayingVideoAtPosition(_ iCurrentTime: Int, iDurationTime: Int?) {

    }
    
    @objc func allContentDidFinishPlayingWithAd() {
        print("all ads completed & video completed")
        self.delegate?.didFinishPlayingVideo(self)
    }

    
}


//MARK: -
//MARK: - extension Analytics Event helper method
extension SPLTPlayerViewController {
    
    open func initializeAnalyticsForCurVideo() {
        if let curVideo = self.curVideo {
            if let strVideoId = curVideo.strId, let strVideoCompanyId = curVideo.strComapnyId {
                let channel_spotlight_company_id = strVideoCompanyId
                SPLTAnalyticsEventsHelper.sharedInstance.initializeWith(self.channel?.strId, pageVideoId: strVideoId, pageVideoCompanyId: strVideoCompanyId, pagePlaylistId: nil, pageCompanyId: channel_spotlight_company_id)
            }
        }
    }
    
    open func addAnalyticsEvent(_ analyticsEventCategory :SPLTAnalyticsEventCategory, analyticsEventType: SPLTAnalyticsEventType, position: Int? = nil, position_end: Int? = nil, message: String? = nil) {
        if let curVideo = self.curVideo {
            var cur_position = self.iCurElapsedSeconds
            if let position_ = position {
                cur_position = position_
            }
            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: analyticsEventCategory, analyticsEventType: analyticsEventType, duration: curVideo.iDuration, position: cur_position, position_end: position_end, message: message)
            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
        }
    }
    
    open func addAnalyticsResizeEvent(_ newSize: CGSize) {
        let analyticsEventCategory :SPLTAnalyticsEventCategory = SPLTAnalyticsEventCategory.player_setup
        let analyticsEventType: SPLTAnalyticsEventType = SPLTAnalyticsEventType.player_setup_resize
        if let curVideo = self.curVideo {
            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: analyticsEventCategory, analyticsEventType: analyticsEventType, duration: curVideo.iDuration, position: self.iCurElapsedSeconds, position_end: nil, message: "width: \(Int(newSize.width)), height: \(Int(newSize.height))")
            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
        }
    }
}






