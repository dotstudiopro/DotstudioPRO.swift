//
//  TVOSPlayerViewController+setup.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 22/05/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit


import CoreMedia
import ClientSideInteractiveMediaAds

extension SPLTPlayerViewController {
    
    open func loadVideoDetailFromPlay2Route() {
        self.avPlayerViewController.delegate = self
        if let curVideo = self.curVideo {
            curVideo.resetAdPlayedData() // reseting ad played data
            curVideo.loadFullVideo({ (videoDict) in
                self.checkVideoStatusAndValidate()
            }, completionError: { (error) in
                // error
                print(error.debugDescription)
            })
        }
    }
    
    func checkVideoStatusAndValidate() {
        if let curVideo = self.curVideo {
            
            if curVideo.isGeoblocked {
                let alert = UIAlertController(title: "This content is geoblocked in your region.", message: nil, preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                    _ = self.navigationController?.popViewController(animated: false)
                }))
                self.present(alert, animated: true, completion: nil)
                return
            }
            
            
            if curVideo.videoAccess ==  SPLTVideoAccessType.videoPaywall {
                SPLTInAppPurchaseUtility.shared.checkAndPurchaseVideoFromItunes(spltVideo: curVideo, fromViewController: self) { (success) in
                    if success == true {
                        self.initializeAnalyticsAndLoadMedia()
                    }
                }
                return
            } else {
                self.initializeAnalyticsAndLoadMedia()
            }
        }
    }
    
    open func initializeAnalyticsAndLoadMedia() {
        self.isVideoContentCompletePlaying = false
        self.isAllVideoAdContentCompletePlaying = false
        if let curVideo = self.curVideo {

            self.initializeAnalyticsForCurVideo()
            
            if let progressPoint = curVideo.progressPoint, !curVideo.isLiveStreaming { //, progressPoint > 10 {
                if (progressPoint > 30 && (curVideo.iDuration == 0 || ((curVideo.iDuration - progressPoint) > 30))) {
                    let alert = UIAlertController(title: curVideo.strTitle, message: nil, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Resume from \(curVideo.strProgressDuration)", style: .default, handler: { action in
                        self.shouldResume = true
                        self.loadMedia()
                    }))
                    alert.addAction(UIAlertAction(title: "Play from beginning", style: .default, handler: { action in
                        self.shouldResume = false
                        self.loadMedia()
                    }))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
            }
            
        }
        self.loadMedia()
    }

    open func loadMedia() {
   
        var streamingURL:URL?
        
        if let strVideoUrl = self.curVideo?.strVideoUrl,
            let url = URL(string: strVideoUrl) {
            streamingURL = url
        }
        
        if self.useMP4URL {
            if let strMP4VideoUrl = self.curVideo?.getMP4Url(),
                let url = URL(string: strMP4VideoUrl) {
                streamingURL = url
            }
        }
        
        if streamingURL == nil {
            return
        }
        let mediaItem = AVPlayerItem(url: streamingURL!)
        
        if let curVideo = self.curVideo {
            //Title
            let titleMetadataItem = AVMutableMetadataItem()
            titleMetadataItem.locale = Locale.current
            titleMetadataItem.key = AVMetadataKey.commonKeyTitle as (NSCopying & NSObjectProtocol)?
            titleMetadataItem.keySpace = AVMetadataKeySpace.common
            titleMetadataItem.value = curVideo.strTitle as (NSCopying & NSObjectProtocol)? //"The Title"
            mediaItem.externalMetadata.append(titleMetadataItem)
            //Description
            let descriptionMetadataItem = AVMutableMetadataItem()
            descriptionMetadataItem.locale = Locale.current
            descriptionMetadataItem.key = AVMetadataKey.commonKeyDescription as (NSCopying & NSObjectProtocol)?
            descriptionMetadataItem.keySpace = AVMetadataKeySpace.common
            descriptionMetadataItem.value = curVideo.strDescription as (NSCopying & NSObjectProtocol)? //"This is the description"
            mediaItem.externalMetadata.append(descriptionMetadataItem)
            //Language
            let languageMetadataItem = AVMutableMetadataItem()
            languageMetadataItem.locale = Locale.current
            languageMetadataItem.key = AVMetadataKey.commonKeyLanguage as (NSCopying & NSObjectProtocol)?
            languageMetadataItem.keySpace = AVMetadataKeySpace.common
            languageMetadataItem.value = curVideo.strLanguage as (NSCopying & NSObjectProtocol)? //"This is the description"
            mediaItem.externalMetadata.append(languageMetadataItem)
            //Publisher
            let publisherMetadataItem = AVMutableMetadataItem()
            publisherMetadataItem.locale = Locale.current
            publisherMetadataItem.key = AVMetadataKey.commonKeyPublisher as (NSCopying & NSObjectProtocol)?
            publisherMetadataItem.keySpace = AVMetadataKeySpace.common
            publisherMetadataItem.value = curVideo.strCompanyName as (NSCopying & NSObjectProtocol)? //"This is the description"
            mediaItem.externalMetadata.append(publisherMetadataItem)
            
            let qualityOfServiceClass = DispatchQoS.QoSClass.background
            let backgroundQueue = DispatchQueue.global(qos: qualityOfServiceClass)
            backgroundQueue.async(execute: {
                if let strThumbUrl = curVideo.thumb {
                    //            if (self.videoDetail!.strThumbUrl != "") {
                    let strFinalThumbUrl = strThumbUrl + "/320/180"
                    let thumbURL:URL = URL(string: strFinalThumbUrl)!
                    if let data: Data = try? Data(contentsOf: thumbURL) {
                        if let image: UIImage = UIImage(data: data) {
                            DispatchQueue.main.async(execute: { () -> Void in
                                let artwork = AVMutableMetadataItem()
                                artwork.key = AVMetadataKey.commonKeyArtwork as (NSCopying & NSObjectProtocol)?
                                artwork.locale = Locale.current
                                artwork.keySpace = AVMetadataKeySpace.common
                                artwork.value = image.pngData() as (NSCopying & NSObjectProtocol)?
                                mediaItem.externalMetadata.append(artwork)
                            })
                        }
                    }
                }
            })
            
            
            self.avPlayerItem = mediaItem
            let avplayer = AVPlayer(playerItem: mediaItem)
            self.avPlayerViewController.player = avplayer
            self.contentPlayer = avplayer
            self.addChild(self.avPlayerViewController)
            self.view.addSubview(self.avPlayerViewController.view)
//            self.avPlayerViewController.view.frame = self.view.bounds
            self.splt_constrainViewEqual(holderView: self.view, view: self.avPlayerViewController.view)

            // Playhead observers for progress bar.
            if let contentPlayer = self.contentPlayer {
                self.addObservers(contentPlayer)
            }
            
            if let strCloseCaptionUrl = curVideo.strCloseCaptionUrl {
                if let subtitleURL = URL(string: strCloseCaptionUrl) {
                    self.hasSubstitles = true
                    self.avPlayerViewController.addSubtitles().open(file: subtitleURL)
                    self.avPlayerViewController.subtitleLabel?.isHidden = !self.isSubstitlesOn
                }
            }
            
            //self.setVideoWaterMark()
            
            if curVideo.haveServerSideAds {
                self.bAdsEnabled = false
            }
            
            self.initializeAnalyticsForCurVideo()
            
            if self.shouldTrackAnalytics {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.video_metadata_loaded, video: self.curVideo)
            }

            if let contentPlayer = self.contentPlayer {
                SPLTAnalyticsUtility.sharedInstance.didInitializeAVPlayer(contentPlayer, forVideo: curVideo)
            }
            SPLTAnalyticsUtility.sharedInstance.startVideoTracking()
            
            if self.bAdsEnabled {
                self.setupContentPlayerForIMA()
                self.setUpAdsLoader()
                self.requestAds(curVideo: curVideo)
            } else {
                self.isVideoSetupOnGoing = false
                self.contentPlayer?.play()
                self.contentPlayer?.isMuted = self.isMuted
            }
        }
    }
    
    open func updateSubtitlesBasedOnUserInteraction() {
        self.avPlayerViewController.subtitleLabel?.isHidden = !self.isSubstitlesOn
    }
    
//    open func setVideoWaterMark() {
//        if let curVideo = self.curVideo {
//            if curVideo.isVideoWaterMarkingEnabled {
//                self.imageViewVideoWaterMark?.isHidden = false
//                if let strVideoWaterMarkId = curVideo.strVideoWaterMarkId {
//                    if let fWaterMarkOpacity = curVideo.fWaterMarkOpacity {
//                        self.imageViewVideoWaterMark?.alpha = fWaterMarkOpacity
//                    }
//                    let strFullVideoWaterMarkPath = SPLTFullPathRouter.imageFullPath(strVideoWaterMarkId).URLString
//                    if let url = URL(string: strFullVideoWaterMarkPath) {
//                        self.imageViewVideoWaterMark?.splt_setImageFromURL(url, placeholder: nil)
//                        self.view.bringSubviewToFront(self.imageViewVideoWaterMark!)
//                    } else {
//                        self.imageViewVideoWaterMark?.image = nil
//                    }
//                } else {
//                    //self.imageViewVideoWaterMark.image = nil
//                }
//            } else {
//                self.imageViewVideoWaterMark?.isHidden = true
//            }
//        }
//    }

    
}






