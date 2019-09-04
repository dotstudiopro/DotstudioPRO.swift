//
//  SPLTAnalyticsUtility.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 18/04/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import AVFoundation
#if os(iOS)
    import GoogleInteractiveMediaAds
#elseif os(tvOS)
    import ClientSideInteractiveMediaAds
#endif

public enum SPLTAllAnalyticsEventType {
    
    case video_metadata_loaded
    // Funnel Events:
    case setup_player_ready
    case setup_ad_request
    case setup_ad_loaded
    case setup_ad_impression
    case setup_ad_started
    case setup_ad_complete
    //    case setup_loadedmetadata = "setup_loadedmetadata"
    
    // Debugging events
    case ad_error
    
    // Other Events:
    case ad_clicked
    case ad_skipped
    //    case ad_mobile_block_ = "ad_mobile_block_"
    case view_first_frame
    case view_content_ended  // fired when video complets
    case end_playback  // fired when user ends playback.
    case view_quartile_1
    case view_quartile_2
    case view_quartile_3
    
    // Play Events
    case play_button_click
    case play_event
    case pause_event
    case seek
    case resume_after_seek
    
    case login
}

public protocol SPLTBaseAnalyticsUtility {
    func didInitializeAVPlayer(_ player: AVPlayer, forVideo video: SPLTVideo)
    func didLoadIMAAdsManager(_ imaAdsManager: IMAAdsManager, fromVC dspPlayerViewController:DSPPlayerViewController)
    
    func startVideoTracking()
    func stopVideoTracking()
    func startAdsTracking()
    func stopAdsTracking()
    
    
    func trackEventWith(_ spltAllAnalyticsEventType: SPLTAllAnalyticsEventType, video: SPLTVideo?)
    func trackSeekEventWith(_ spltAllAnalyticsEventType: SPLTAllAnalyticsEventType, video: SPLTVideo?, position: Int?, position_end: Int?)
    func trackEventWithElapsedTime(_ iCurSeconds: Int, iDuration: Int, video: SPLTVideo)
    func trackSubscriptionEventWith(_ strSubscription: String, price: Double)
    func trackSubscriptionInitiatedEventWith(_ strSubscription: String, price: Double)
}


open class SPLTAnalyticsUtility: NSObject {
    
    public static let sharedInstance = SPLTAnalyticsUtility()
    
    open var allAnalyticsUtility: [SPLTBaseAnalyticsUtility] = []
    
    override init() {
        super.init()
    }
    
    open func addAnalyticsUtility(_ spltBaseAnalyticsUtility: SPLTBaseAnalyticsUtility) {
        self.allAnalyticsUtility.append(spltBaseAnalyticsUtility)
    }
    
    
    open func didInitializeAVPlayer(_ player: AVPlayer, forVideo video: SPLTVideo) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.didInitializeAVPlayer(player, forVideo: video)
        }
    }
    open func didLoadIMAAdsManager(_ imaAdsManager: IMAAdsManager, fromVC dspPlayerViewController:DSPPlayerViewController) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.didLoadIMAAdsManager(imaAdsManager, fromVC: dspPlayerViewController)
        }
    }
    open func startVideoTracking() {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.startVideoTracking()
        }
    }
    open func stopVideoTracking() {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.stopVideoTracking()
        }
    }
    open func startAdsTracking() {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.startAdsTracking()
        }
    }
    open func stopAdsTracking() {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.stopAdsTracking()
        }
    }
    
    
    
    open func trackEventWith(_ spltAllAnalyticsEventType: SPLTAllAnalyticsEventType, video: SPLTVideo?) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.trackEventWith(spltAllAnalyticsEventType, video: video)
        }
        //        if SPLTConfig.UseGoogleAnalytics {
        //            SPLTGAAnalyticsUtility.sharedInstance.trackEventWith(spltAllAnalyticsEventType, video: video)
        //        }
        //        if SPLTConfig.UseAppsFlyer {
        //            SPLTAppsFlyerAnalyticsUtility.sharedInstance.trackEventWith(spltAllAnalyticsEventType, video: video)
        //        }
    }
    
    open func trackEventWithElapsedTime(_ iCurSeconds: Int, iDuration: Int, video: SPLTVideo) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.trackEventWithElapsedTime(iCurSeconds, iDuration: iDuration, video: video)
        }
    }
    
    open func trackSeekEventWith(_ spltAllAnalyticsEventType: SPLTAllAnalyticsEventType, video: SPLTVideo?, position: Int?, position_end: Int?) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.trackSeekEventWith(spltAllAnalyticsEventType, video: video, position: position, position_end: position_end)
        }
    }

    open func trackSubscriptionEventWith(_ strSubscription: String, price: Double) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.trackSubscriptionEventWith(strSubscription, price: price)
        }
    }
    
    open func trackSubscriptionInitiatedEventWith(_ strSubscription: String, price: Double) {
        for analyticsUtility in self.allAnalyticsUtility {
            analyticsUtility.trackSubscriptionInitiatedEventWith(strSubscription, price: price)
        }
    }
    
    
}





