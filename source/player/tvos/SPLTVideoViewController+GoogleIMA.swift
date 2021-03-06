//
//  SPLTVideoViewController+GoogleIMA.swift
//
//
//  Created by Kunal Joshi on 13/05/19.
//  Copyright © 2019. All rights reserved.
//

import Foundation
import ClientSideInteractiveMediaAds
import AdSupport
import AVFoundation




//MARK: -
//MARK: - extension GoogleIMA extension method
extension DSPPlayerViewController {
    
//    func isPostAdAvailable() -> Bool {
//        // one of the adcuepoint is -1 if post roll is available.
//        if let adsManager = self.adsManager {
//            for adCuePoint in adsManager.adCuePoints {
//                if let iAdCuePoint = adCuePoint as? Int {
//                    if iAdCuePoint == -1 {
//                        return true
//                    }
//                }
//            }
//        }
//        return false
//    }
    
    func setupContentPlayerForIMA() {
        if let contentPlayer = self.contentPlayer {
            self.contentPlayhead = IMAAVPlayerContentPlayhead(avPlayer: contentPlayer)
        }
    }

    func setUpAdsLoader() {
        let imaSettings = IMASettings()
        imaSettings.maxRedirects = 8
        self.adsLoader = IMAAdsLoader(settings: imaSettings)
        self.adsLoader?.delegate = self
    }
    
    func getVmapAdTagParameters() -> String? {
        return SPLTAdsAPI.getVmapAdTagParameters()
    }
    
    func getVmapAdTag(curVideo: SPLTVideo) -> String? {
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
    
    func requestAds(curVideo: SPLTVideo) {
        
        if let adTagUrl = self.getVmapAdTag(curVideo: curVideo) {
            // Create ad display container for ad rendering.
//            let adTagUrlTest = "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&output=vmap&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&correlator="
            let request = IMAAdsRequest.init(adTagUrl:adTagUrl , adDisplayContainer: self.view, contentPlayhead: self.contentPlayhead, userContext: nil)
            request?.vastLoadTimeout = 8000
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_request, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_request)
            }
            self.adsLoader?.requestAds(with: request)
        }
    }
    
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if (notification.object as! AVPlayerItem) == contentPlayer?.currentItem {
            if self.isVideoContentCompletePlaying == false {
                if self.shouldTrackAnalytics {
                    SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_content_ended, video: self.curVideo)
                    self.addAnalyticsEvent(.playback, analyticsEventType: .complete)
                }
                self.isVideoContentCompletePlaying = true
            }
            
            if self.isAllVideoAdContentCompletePlaying {
                self.allContentDidFinishPlayingWithAd()
            } else {
                self.adsLoader?.contentComplete()
            }
//            if self.isPostAdAvailable() {
//                self.adsLoader?.contentComplete()
//                self.delegate?.didFinishPlayingVideo(self)
//            } else {
//                self.allContentDidFinishPlayingWithAd()
//            }
        }
    }
    
}

//MARK: -
//MARK: - extension IMAAdsLoaderDelegate methods
extension DSPPlayerViewController: IMAAdsLoaderDelegate {
    open func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        if self.shouldTrackAnalytics {
            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_loaded, video: self.curVideo)
            self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_loaded)
        }

        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        self.adsManager = adsLoadedData.adsManager
        self.adsManager?.delegate = self

        if let imaAdsManager = self.adsManager {
            SPLTAnalyticsUtility.sharedInstance.didLoadIMAAdsManager(imaAdsManager, fromVC: self)
        }
        SPLTAnalyticsUtility.sharedInstance.startAdsTracking()
        
        
        // Create ads rendering settings to tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        
        // Initialize the ads manager.
        self.adsManager?.initialize(with: nil)
        self.isVideoSetupOnGoing = false
    }
    
    open func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        // Something went wrong loading ads. Log the error and play the content.
        self.isAdPlayback = false
        self.isAllVideoAdContentCompletePlaying = true
        if self.shouldTrackAnalytics {
            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.ad_error, video: self.curVideo)
            self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_error)
            self.addAnalyticsEvent(.playback, analyticsEventType: .play)
        }
        print("Error loading ads: %@\(String(describing: adErrorData.adError.message))")
        self.contentPlayer?.play()
        self.isVideoSetupOnGoing = false
    }
}

//MARK: -
//MARK: - extension IMAAdsManagerDelegate
extension DSPPlayerViewController: IMAAdsManagerDelegate {
    
    open func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
        print(event.type.rawValue)
        switch (event.type) {
        case IMAAdEventType.AD_BREAK_READY:
            break
        case IMAAdEventType.CLICKED:
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.ad_clicked, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_click)
            }
            break
        case IMAAdEventType.SKIPPED:
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.ad_skipped, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_skip)
            }
            break
        case IMAAdEventType.LOADED:
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_impression, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_impression)
            }
            self.adsManager?.start()
            break
        case IMAAdEventType.PAUSE:
//            self.setPlayButtonType(SPLTVideoPlayButtonType.playButton)
            break
        case IMAAdEventType.RESUME:
//            self.setPlayButtonType(SPLTVideoPlayButtonType.pauseButton)
            break
        case IMAAdEventType.STARTED:
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_started, video: self.curVideo)
            }
            break
        case IMAAdEventType.COMPLETE:
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_complete, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_complete)
            }
            break
        case IMAAdEventType.TAPPED:
            //                showFullscreenControls(nil)
            break
        case .ALL_ADS_COMPLETED:
            self.isAllVideoAdContentCompletePlaying = true
            if self.isVideoContentCompletePlaying {
                self.allContentDidFinishPlayingWithAd()
            } else {
                // Do nothing as video content playing is pending.
            }
            break
        default:
            break
        }
    }
    
    open func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
        // Something went wrong with the ads manager after ads were loaded. Log the error and play the content.
        self.isAdPlayback = false
        self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_error)
        print("AdsManager error: %@ \(String(describing: error.message))")
        
//        if self.isVideoContentCompletePlaying {
//            //Finish playing the video
//            self.allContentDidFinishPlayingWithAd()
//        } else {
            self.addAnalyticsEvent(.playback, analyticsEventType: .play)
            self.contentPlayer?.play()
//        }
    }
    
    open func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
        // The SDK is going to play ads, so pause the content.
        print("Ads is going to play")
        self.isAdPlayback = true
        self.addAnalyticsEvent(.playback, analyticsEventType: .pause)
        self.contentPlayer?.pause()
    }
    
    open func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
        // The SDK is done playing ads (at least for now), so resume the content.
        self.isAdPlayback = false
//        if self.isVideoContentCompletePlaying {
//            self.allContentDidFinishPlayingWithAd()
//        } else {
            //Finish playing the video
            self.addAnalyticsEvent(.playback, analyticsEventType: .play)
            self.contentPlayer?.play()
//        }
    }
}








