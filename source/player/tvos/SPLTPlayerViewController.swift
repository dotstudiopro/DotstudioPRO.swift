//
//  TVOSPlayerViewController.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 22/05/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import AVKit
import AVFoundation


import ClientSideInteractiveMediaAds
import AdSupport

enum SPLTVideoPlayButtonType: Int {
    case playButton = 0
    case pauseButton = 1
}

public protocol SPLTPlayerViewControllerDelegate {
     func didFinishPlayingVideo(_ dspPlayerViewController: DSPPlayerViewController)
     func didClosePlayingVideoOnDSPPlayerViewController()
}

public typealias DSPPlayerViewController = SPLTPlayerViewController

open class SPLTPlayerViewController: SPLTBaseViewController{
    
    open var delegate: SPLTPlayerViewControllerDelegate?
    
    open var bAdsEnabled: Bool = true
    open var isVideoContentCompletePlaying: Bool = false
    open var isAllVideoAdContentCompletePlaying: Bool = false
    open var shouldSkipLoadingFullVideo: Bool = false
    open var curVideo: SPLTVideo?
    open var iCurVideoProgressPoint: Int?
    open var avLayerVideoGravity: AVLayerVideoGravity?
    var playerLayer: AVPlayerLayer?
    var contentRateContext: UInt8 = 1
    var contentDurationContext: UInt8 = 2
    var statusContext: UInt8 = 3
    var isFirstFramePlayed: Bool = false
    
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var adsLoader: IMAAdsLoader?
    open var adsManager: IMAAdsManager?
    open var delegateIMAAdsManager :IMAAdsManagerDelegate?
    
    var strCurAdTagUrl: String?
    var shouldTrackAnalytics: Bool = true
    
    var contentPlayer: AVPlayer? {
        didSet {
            if contentPlayer == nil {
                print("nil set")
            }
        }
    }
    
    open var avPlayerViewController: AVPlayerViewController = AVPlayerViewController()
    open var avPlayerItem: AVPlayerItem?
    
    open var isPreviewVideo: Bool = false
    open var shouldResume: Bool = false
    open var channel: SPLTChannel?
    
//    open var spltVideo: SPLTVideo?
    open var curSpltVideoAdType: SPLTVideoAdType = .none
    
    open var isPlayerSetupReady = false
    open var isVideoPlaybackComplete = false
    open var wasSeek: Bool = false
    open var iCurElapsedSeconds: Int = 0
    open var useMP4URL: Bool = false
    
    open var playerItemStatusContext: UInt8 = 4

    open var periodicTimeObserver: Any?
    open var isObserversAdded: Bool = false
    open var isNotificationAVPlayerItemDidPlayToEndTimeAdded: Bool = false
    
    // Updates progress bar for provided time and duration.
    open var bVideoQuartilesWatched: [Bool] = [false, false, false]
    
    //MARK: - Ads Methods
    open var isAdPlayback = false

    open var isMuted:Bool = false
    //MARK: - basic methods overridden
    open var isSubstitlesOn:Bool = true
    open var hasSubstitles:Bool = false

    
    open class func getViewController() -> SPLTPlayerViewController? {
        
        let spltPlayerViewController = SPLTPlayerViewController()
        return spltPlayerViewController
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(SPLTPlayerViewController.tapped(_:)))
        tapRecognizer.allowedPressTypes = [NSNumber(value: UIPress.PressType.menu.rawValue as Int)];
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.registerNotifications()
        
        self.loadVideoDetailFromPlay2Route()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    open func setCurrentVideo(curVideo: SPLTVideo) {
        self.curVideo = curVideo
    }
    open func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func updatePlayheadWithTime(_ time: CMTime, duration: CMTime) {
        if (!CMTIME_IS_VALID(time)) {
            return
        }
        let currentTime = CMTimeGetSeconds(time)
        if (currentTime.isNaN) {
            return
        }
        self.iCurElapsedSeconds = Int(currentTime)
        if !self.isFirstFramePlayed {
            if self.shouldTrackAnalytics {
                self.addAnalyticsEvent(.playback, analyticsEventType: .first_frame)
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_first_frame, video: self.curVideo)
            }
            self.isFirstFramePlayed = true
        }
        if let iDuration = self.getSecondsFromTime(time: duration) {
            self.updateWithVideoElapsedSeconds(self.iCurElapsedSeconds, iDuration: iDuration)
        }
        updatePlayheadDurationWithTime(duration)
    }
    
    func updatePlayheadDurationWithTime(_ time: CMTime!) {
        if (!time.isValid) {
            return
        }
        let durationValue = CMTimeGetSeconds(time)
        if (durationValue.isNaN) {
            return
        }
    }
    
    func getSecondsFromTime(time: CMTime) -> Int? {
        if (!time.isValid) {
            return nil
        }
        let timeValue = CMTimeGetSeconds(time)
        if (timeValue.isNaN) {
            return nil
        }
        let iSeconds = Int(timeValue)
        return iSeconds
    }
    
    func getPlayerItemDuration(_ item: AVPlayerItem) -> CMTime {
        var itemDuration = CMTime.invalid
        if (item.responds(to: #selector(getter: CAMediaTiming.duration))) {
            itemDuration = item.duration
        } else {
            if (item.asset.responds(to: #selector(getter: CAMediaTiming.duration))) {
                itemDuration = item.asset.duration
            }
        }
        return itemDuration
    }
    
    //MARK: - Handler for keypath listener that is added for content playhead observer.
    override open func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey : Any]?,
        context: UnsafeMutableRawPointer?) {
        if (context == &contentRateContext && contentPlayer == object as? AVPlayer) {
            updatePlayheadState(contentPlayer!.rate != 0)
        } else if (context == &contentDurationContext && contentPlayer == object as? AVPlayer) {
            if let contentPlayer = self.contentPlayer, let currentItem = contentPlayer.currentItem {
                updatePlayheadDurationWithTime(getPlayerItemDuration(currentItem))
            }
        } else if (context == &statusContext && contentPlayer == object as? AVPlayer) {
            if let contentPlayer_ = contentPlayer {
                switch contentPlayer_.status {
                case AVPlayer.Status.unknown:
                    break
                case AVPlayer.Status.failed:
                    self.addAnalyticsEvent(.player_setup, analyticsEventType: .player_setup_error)
                    break
                case .readyToPlay:
                    if !self.isAdPlayback {
                        if let iCurVideoProgressPoint = self.iCurVideoProgressPoint {
                            if contentPlayer_.rate == 0 {
                                contentPlayer_.play()
                            }
                            contentPlayer_.seek(to: CMTimeMakeWithSeconds(Double(iCurVideoProgressPoint),preferredTimescale: 1), toleranceBefore: CMTime.zero, toleranceAfter: CMTime.zero, completionHandler: { (finished) in
                                contentPlayer_.play()
                            })
                            self.iCurVideoProgressPoint = nil
                        }
                        if self.shouldTrackAnalytics {
                            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_player_ready, video: self.curVideo)
                            self.addAnalyticsEvent(.player_setup, analyticsEventType: .player_setup_ready)
                        }
                    }
                    
                default: break
                    
                }
            }
        }
    }
    
    // Updates play button for provided playback state.
    func updatePlayheadState(_ isPlaying: Bool) {
        
    }
    
    // Handle clicks on play/pause button.
    @IBAction func onPlayPauseClicked(_ sender: AnyObject) {
        if (!self.isAdPlayback) {
            if (self.contentPlayer?.rate == 0) {
                self.playContent()
            } else {
                self.pauseContent()
            }
        }
    }
    
    open func playContent() {
        self.contentPlayer?.play()
    }
    open func pauseContent() {
        self.contentPlayer?.pause()
    }

    open func resumeAd() {
        self.adsManager?.resume()
    }
    open func pauseAd() {
        self.adsManager?.pause()
    }
    
    //MARK:- set Player methods
    var isVideoSetupOnGoing = false {
        didSet {
            if self.isVideoSetupOnGoing {
                self.showProgress()
            } else {
                self.hideProgress()
            }
        }
    }
    
    
    //MARK: - IBAction methods
    
    @IBAction open func closeModal(_ sender: AnyObject) {
        _ = self.navigationController?.popViewController(animated: false)
        self.delegate?.didClosePlayingVideoOnDSPPlayerViewController()
    }
    
    //MARK: - IBAction methods
    
    @IBAction open func didClickPlayButton(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "tvosVideoViewController", sender: self)
    }
    
    //MARK: - UITapGestureRecognizer
    @objc open func tapped(_ gesture: UITapGestureRecognizer) {
        if self.hasSubstitles == true {
            
            self.pause()
            var strSubtitle = "Subtitles : Off"
            if self.isSubstitlesOn == false {
                strSubtitle = "Subtitles : On"
            }
            let alert = UIAlertController(title: "Player Menu", message: self.curVideo?.strTitle, preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: strSubtitle, style: UIAlertAction.Style.default, handler: { action in
                    self.isSubstitlesOn = !self.isSubstitlesOn
                    self.updateSubtitlesBasedOnUserInteraction()
                    self.play()
                }))
            
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { action in
                    self.play()
                }))
            
                alert.addAction(UIAlertAction(title: nil, style: UIAlertAction.Style.cancel, handler: { action in
                    self.stopAndRemoveThePlayer()
                }))

            // show the alert
                self.present(alert, animated: true, completion: nil)
            
        } else {
            self.stopAndRemoveThePlayer()
        }
    }
    
    open func stopAndRemoveThePlayer() {
        self.stopAndRemoveAVPlayerViewController()
        _ = self.navigationController?.popViewController(animated: true)
        self.delegate?.didClosePlayingVideoOnDSPPlayerViewController()
    }

    open func tvosMenuButtonTapped() {
//        self.skVastViewController?.dismiss(animated: false, completion: { () -> Void in
//            //            self.navigationController?.popViewControllerAnimated(false)
//        })
        self.stopAndRemoveAVPlayerViewController()
        _ = self.navigationController?.popViewController(animated: false)
        self.delegate?.didClosePlayingVideoOnDSPPlayerViewController()
    }
}

//MARK: - App Become Active/Deactive methods
extension SPLTPlayerViewController {
    @objc func applicationWillResignActive() {
        if self.isAdPlayback {
            self.adsManager?.pause()
        } else {
            if let contentPlayer = self.contentPlayer {
                self.removeObservers(contentPlayer)
                self.addAnalyticsEvent(.playback, analyticsEventType: .pause)
                contentPlayer.pause()
            }
        }
    }
    @objc func applicationDidBecomeActive() {
        if self.isAdPlayback {
            self.adsManager?.resume()
        } else {
            if let contentPlayer = self.contentPlayer {
                self.addAnalyticsEvent(.playback, analyticsEventType: .play)
                contentPlayer.play()
                self.addObservers(contentPlayer)
            }
        }
    }
}

//MARK: -
//MARK: - extension save video progress
extension SPLTPlayerViewController{
    func saveCurrentVideoProgress() {
        if let currentTime_cmtime = self.contentPlayer?.currentTime(), currentTime_cmtime.isValid {
            let floatCurrentTime = CMTimeGetSeconds(currentTime_cmtime)
            if !floatCurrentTime.isNaN {
                let currentTime: Int = Int(floatCurrentTime)
                if let curVideo = self.curVideo, let strVideoId = curVideo.strId, !curVideo.isLiveStreaming {
                    curVideo.progressPoint = currentTime
                    SPLTVideoProgressAPI().setVideoProgress(strVideoId, iVideoDuration: currentTime, completion: { (responseDict) in
                        // success
                        print(responseDict)
                    }, completionError: { (error) in
                        // error
                    })
                }
            }
        }
    }
}
