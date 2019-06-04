//
//  TVOSPlayerViewController+AVPlayerViewControllerDelegate.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 22/05/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import AVKit
import AVFoundation



extension SPLTPlayerViewController: AVPlayerViewControllerDelegate {
    
    open func playerViewController(_ playerViewController: AVPlayerViewController, willResumePlaybackAfterUserNavigatedFrom oldTime: CMTime, to targetTime: CMTime) {
//        print(oldTime)
//        print(targetTime)
        if !oldTime.isValid || !targetTime.isValid {
            return
        }
        let start_position: Int = Int(CMTimeGetSeconds(oldTime))
        let end_position: Int = Int(CMTimeGetSeconds(targetTime))
        if let curVideo = self.curVideo {
            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: SPLTAnalyticsEventCategory.playback, analyticsEventType: SPLTAnalyticsEventType.seek, duration: curVideo.iDuration, position: start_position, position_end: end_position, message: nil)
            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
            SPLTAnalyticsUtility.sharedInstance.trackSeekEventWith(.seek, video: curVideo, position: start_position, position_end: end_position)
            SPLTAnalyticsUtility.sharedInstance.trackSeekEventWith(.resume_after_seek, video: curVideo, position: end_position, position_end: nil)
        }
        self.wasSeek = true
    }
    
}
