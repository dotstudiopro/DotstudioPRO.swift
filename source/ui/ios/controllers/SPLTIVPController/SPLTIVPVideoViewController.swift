//
//  SPLTIVPVideoViewController.swift
//  DotstudioUI-iOS
//
//  Created by Ketan Sakariya on 19/05/18.
//

import Foundation
//import DotstudioAPI
import UIKit

open class SPLTIVPVideoViewController: SPLTBaseViewController {
    
    open var curVideo: SPLTVideo?
    
    open func setCurrentVideo(curVideo: SPLTVideo) {
        self.curVideo = curVideo
    }
    open func getVmapAdTagParameters() -> String? {
        var strAdTagParams = SPLTAdsAPI.getVmapAdTagParameters()
        return strAdTagParams
    }
    @objc open func getVmapAdTag(curVideo: SPLTVideo) -> String? {
        if let strVideoId = curVideo.strId {
            let screenRect = UIScreen.main.bounds
            var screenWidth = Int(screenRect.width * UIScreen.main.scale)
            var screenHeight = Int(screenRect.height * UIScreen.main.scale)
            if screenRect.height > screenRect.width {
                screenWidth = Int(screenRect.height * UIScreen.main.scale)
                screenHeight = Int(screenRect.width * UIScreen.main.scale)
            }
            var adTagUrl = "https://api.myspotlight.tv/vmap/\(strVideoId)/\(screenWidth)/\(screenHeight)/\(strVideoId)"
            if let strVmapAdTagParameters = self.getVmapAdTagParameters() {
                adTagUrl += "?\(strVmapAdTagParameters)"
            }
            return adTagUrl
        }
        return nil
    }
    
    open func setNextVideo() { // interface, so next video can be played after ad finish playing.
    }
    open func resetVideoPlaybackToZero() {
//        self.contentPlayer?.seek(to: kCMTimeZero)
//        self.viewVideoControls.isHidden = false
//        self.updateSubtitlesPosition()
//        self.viewVideoControlsTop.alpha = 0.9
//        self.buttonPlayPause.alpha = 0.9
//        self.viewVideoControlsBottom.alpha = 0.9
    }
    open func closeViewController() {
        self.saveCurrentVideoProgress()
        self.addAnalyticsEvent(.playback, analyticsEventType: .end_playback)
    }
    open func saveCurrentVideoProgress() {
//        if let currentTime_cmtime = self.contentPlayer?.currentTime(), currentTime_cmtime.isValid {
//            let floatCurrentTime = CMTimeGetSeconds(currentTime_cmtime)
//            if !floatCurrentTime.isNaN {
//                let currentTime: Int = Int(floatCurrentTime)
//                if let curVideo = self.curVideo, let strVideoId = curVideo.strId {
//                    if SPLTConfig.bEnableResumePlayback == true {
//                        curVideo.progressPoint = currentTime
//                        SPLTVideoProgressAPI().setVideoProgress(strVideoId, iVideoDuration: currentTime, completion: { (responseDict) in
//                            // success
//                            print(responseDict)
//                        }, completionError: { (error) in
//                            // error
//                        })
//                    }
//                }
//            }
//        }
    }
}


//MARK: -
//MARK: - extension Analytics Event helper method
extension SPLTIVPVideoViewController {
    
    open func initializeAnalyticsForCurVideo() {
//        if let curVideo = self.curVideo {
//            if let strVideoId = curVideo.strId, let strVideoCompanyId = curVideo.strComapnyId {
//                let channel_spotlight_company_id = strVideoCompanyId
//                SPLTAnalyticsEventsHelper.sharedInstance.initializeWith(nil, pageVideoId: strVideoId, pageVideoCompanyId: strVideoCompanyId, pagePlaylistId: nil, pageCompanyId: channel_spotlight_company_id)
//            }
//        }
    }
    
    open func addAnalyticsEvent(_ analyticsEventCategory :SPLTAnalyticsEventCategory, analyticsEventType: SPLTAnalyticsEventType, position: Int? = nil, position_end: Int? = nil) {
//        if let curVideo = self.curVideo {
//            var cur_position = self.iCurElapsedSeconds
//            if let position_ = position {
//                cur_position = position_
//            }
//            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: analyticsEventCategory, analyticsEventType: analyticsEventType, duration: curVideo.iDuration, position: cur_position, position_end: position_end, message: "width: \(Int(self.viewVideoControlWithAd.frame.width)), height: \(Int(self.viewVideoControlWithAd.frame.height))")
//            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
//        }
    }
    
    open func addAnalyticsResizeEvent(_ newSize: CGSize) {
//        let analyticsEventCategory :SPLTAnalyticsEventCategory = SPLTAnalyticsEventCategory.player_setup
//        let analyticsEventType: SPLTAnalyticsEventType = SPLTAnalyticsEventType.player_setup_resize
//        if let curVideo = self.curVideo {
//            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: analyticsEventCategory, analyticsEventType: analyticsEventType, duration: curVideo.iDuration, position: self.iCurElapsedSeconds, position_end: nil, message: "width: \(Int(newSize.width)), height: \(Int(newSize.height))")
//            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
//        }
    }
}



