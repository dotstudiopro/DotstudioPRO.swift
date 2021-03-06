//
//  TVOSPlayerViewController+listener.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 22/05/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit



extension DSPPlayerViewController {

    open func addObservers(_ contentPlayer: AVPlayer) {
        if self.periodicTimeObserver == nil {
            self.periodicTimeObserver = contentPlayer.addPeriodicTimeObserver(
                forInterval: CMTimeMake(value: 1, timescale: 30), //CMTimeMake(1, 1), //CMTimeMake(1, 30),
                queue: nil,
                using: {(time: CMTime) -> Void in
                    if let currentTime = self.avPlayerViewController.player?.currentTime(),
                        let durationTime = self.avPlayerViewController.player?.currentItem?.duration {
                        self.didPlayingVideoAtPosition(currentTime, durationTime: durationTime)
                    }
            })
        }
        if !self.isObserversAdded {
            contentPlayer.addObserver(
                self,
                forKeyPath: "rate",
                options: NSKeyValueObservingOptions.new,
                context: &contentRateContext)
            contentPlayer.addObserver(
                self,
                forKeyPath: "currentItem.duration",
                options: NSKeyValueObservingOptions.new,
                context: &contentDurationContext)
            contentPlayer.addObserver(
                self,
                forKeyPath: "status",
                options: NSKeyValueObservingOptions.new,
                context: &statusContext)
            contentPlayer.addObserver(
                self,
                forKeyPath: "currentItem.status",
                options: NSKeyValueObservingOptions.new,
                context: &playerItemStatusContext)
            self.isObserversAdded = true
        }

        if !self.isNotificationAVPlayerItemDidPlayToEndTimeAdded {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(DSPPlayerViewController.contentDidFinishPlaying(_:)),
                name: Notification.Name.AVPlayerItemDidPlayToEndTime,
                object: contentPlayer.currentItem);
            self.isNotificationAVPlayerItemDidPlayToEndTimeAdded = true
        }
    }
    open func removeObservers(_ contentPlayer: AVPlayer) {
        if let periodicTimeObserver = self.periodicTimeObserver {
            contentPlayer.removeTimeObserver(periodicTimeObserver)
            self.periodicTimeObserver = nil
        }
        if self.isObserversAdded {
            contentPlayer.removeObserver(self, forKeyPath: "rate")
            contentPlayer.removeObserver(self, forKeyPath: "currentItem.duration")
            contentPlayer.removeObserver(self, forKeyPath: "status")
            contentPlayer.removeObserver(self, forKeyPath: "currentItem.status")
            self.isObserversAdded = false
        }
        if self.isNotificationAVPlayerItemDidPlayToEndTimeAdded {
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: contentPlayer.currentItem)
            self.isNotificationAVPlayerItemDidPlayToEndTimeAdded = false
        }
    }
    
    open func didUpdateContentPlayerRate(_ contentPlayer: AVPlayer) {
        if (!self.isAdPlayback && !self.isVideoPlaybackComplete) {
            if (contentPlayer.rate == 0) {
                // changed To Pause
                if let curVideo = self.curVideo {
                    self.addAnalyticsEvent(.playback, analyticsEventType: .pause)
                }
            } else {
                if self.wasSeek {
                    if let curVideo = self.curVideo {
                        self.addAnalyticsEvent(.playback, analyticsEventType: .resume_after_seek)
                    }
                    self.wasSeek = false
                } else {
                    if let curVideo = self.curVideo {
                        if self.shouldTrackAnalytics {
                            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_event, video: curVideo)
                            self.addAnalyticsEvent(.playback, analyticsEventType: .play)
                        }
                    }
                }
            }
        
        }

    }
    

}





