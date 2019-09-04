//
//  SPLTVideoViewController+GoogleIMA.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 09/08/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import GoogleInteractiveMediaAds
import AdSupport
import AVFoundation



//MARK: -
//MARK: - extension GoogleIMA extension method
extension DSPPlayerViewController {
    
//    func setUpContentPlayerForGoogleIMA(curVideo: SPLTVideo) {
//        if let strVideoUrl = curVideo.strVideoUrl {
//            var finalStrVideoUrl = strVideoUrl
//            if self.useMP4URL {
//                if let strMP4VideoUrl = curVideo.getMP4Url() {
//                    finalStrVideoUrl = strMP4VideoUrl
//                }
//            }
//            guard let contentURL = URL(string: finalStrVideoUrl) else {
//                print("ERROR: please use a valid URL for the content URL")
//                return
//            }
//            self.contentPlayer = AVPlayer(url: contentURL)
//            if let avLayerVideoGravity = self.avLayerVideoGravity {
//                self.contentPlayer?.externalPlaybackVideoGravity = avLayerVideoGravity
//            }
//            self.contentPlayer?.isMuted = self.isMuted
//            self.labelSubtitles.text = ""
//            self.showCloseCaption = false
//            self.buttonCloseCaption.isHidden = true
//            self.constraintButtonCloseCaption.constant = 0
//            if let strCloseCaptionUrl = curVideo.strCloseCaptionUrl {
//                if let subtitleURL = URL(string: strCloseCaptionUrl) {
//                    self.contentPlayer?.addSubtitles(labelSubtitle: self.labelSubtitles).open(file: subtitleURL)
//                    self.constraintButtonCloseCaption.constant = 40
//                    self.buttonCloseCaption.isHidden = false
//                    self.buttonCloseCaption.isSelected = false
//                }
//            }
//            if let strVideoTitle = curVideo.strTitle {
//                self.labelVideoTitle.text = strVideoTitle
//            }
//            // Playhead observers for progress bar.
//            if let contentPlayer = self.contentPlayer {
//                self.addObservers(contentPlayer)
//            }
//            // Set up fullscreen tap listener to show controls
//            self.videoTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DSPPlayerViewController.showFullscreenControls(_:)))
//            self.viewVideoControls.addGestureRecognizer(self.videoTapRecognizer!)
//            self.videoControlsTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(DSPPlayerViewController.showFullscreenControls(_:)))
//            self.viewVideo.addGestureRecognizer(self.videoControlsTapRecognizer!)
//            
//            // Create a player layer for the player.
//            self.playerLayer = AVPlayerLayer(player: contentPlayer)
//            if let avLayerVideoGravity = self.avLayerVideoGravity {
//                self.playerLayer?.videoGravity = avLayerVideoGravity
//            }
//            // Size, position, and display the AVPlayer.
//            self.playerLayer?.frame = self.viewVideo.layer.bounds
//            self.viewVideo.layer.addSublayer(playerLayer!)
//            
//            // Set up our content playhead and contentComplete callback.
//            #if SKIP_ADS
//            #else
//                contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: contentPlayer)
//            #endif
//        }
//    }
    
//    func setUpAdsLoaderForGoogleIMA() {
//        let imaSettings = IMASettings()
//        imaSettings.maxRedirects = 8
//        self.adsLoader = IMAAdsLoader(settings: imaSettings)
//        self.adsLoader?.delegate = self
//    }
    
//    func getVmapAdTagParametersForGoogleIMA() -> String? {
//        return SPLTAdsAPI.getVmapAdTagParameters()
//    }
//    func getVmapAdTagForGoogleIMA(curVideo: SPLTVideo) -> String? {
//        if let strVideoId = curVideo.strId {
//            let screenRect = UIScreen.main.bounds
//            var screenWidth = Int(screenRect.width * UIScreen.main.scale)
//            var screenHeight = Int(screenRect.height * UIScreen.main.scale)
//            if screenRect.height > screenRect.width {
//                screenWidth = Int(screenRect.height * UIScreen.main.scale)
//                screenHeight = Int(screenRect.width * UIScreen.main.scale)
//            }
//            var adTagUrl = "https://api.myspotlight.tv/vmap/\(strVideoId)/\(screenWidth)/\(screenHeight)/\(strVideoId)"
//            if let strVmapAdTagParameters = self.getVmapAdTagParameters() {
//                adTagUrl += "?\(strVmapAdTagParameters)"
//            }
//            return adTagUrl
//        }
//        return nil
//    }
    
//    func requestAdsForGoogleIMA(curVideo: SPLTVideo) {
//        if let adTagUrl = self.getVmapAdTag(curVideo: curVideo) {
//            // Create ad display container for ad rendering.
//            let adDisplayContainer = IMAAdDisplayContainer(adContainer: viewVideo, companionSlots: nil)
//            // Create an ad request with our ad tag, display container, and optional user context.
//            let request = IMAAdsRequest(
//                adTagUrl: adTagUrl, //SPLTChannelViewController.kTestAppAdTagUrl,
//                adDisplayContainer: adDisplayContainer,
//                contentPlayhead: contentPlayhead,
//                userContext: nil)
//            request?.vastLoadTimeout = 8000
//            if self.shouldTrackAnalytics {
//                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_request, video: self.curVideo)
//                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_request)
//            }
//            self.adsLoader?.requestAds(with: request)
//        }
//    }
    

}









