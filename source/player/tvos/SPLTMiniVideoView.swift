//
//  SPLTMiniVideoView.swift
//  DotStudioTVOSVastPlayerLib
//
//  Created by Ketan Sakariya on 26/09/18.
//  Copyright © 2018 Anwer. All rights reserved.
//

import Foundation
import UIKit


open class SPLTMiniVideoView: UIView {
    public enum PreviewType {
        case imageAnimator
        case videoPreview
    }
    open var previewType: PreviewType = .imageAnimator
    
    public enum ThumbnailPreviewType {
        case thumbnail
        case poster
        case wallpaper
    }
    open var thumbnailPreviewType: ThumbnailPreviewType = .thumbnail
    
    //    public enum ChannelThumbnailPreviewType {
    //        case poster
    //        case spotlightPoster
    //    }
    //    open var channelThumbnailPreviewType: ChannelThumbnailPreviewType = .poster
    
    open var imageView: UIImageView?
    open var curVideo: SPLTVideo?
    
    
    open func setVideo(_ video: SPLTVideo, withPreviewType previewType: PreviewType = .imageAnimator) {
        self.curVideo = video
        self.previewType = previewType
        self.addImageView()
        
        //        // Show when focused
        //        switch self.previewType {
        //            case .imageAnimator:
        //                self.setVideoImagesForCurVideo()
        //                break
        //            case .videoPreview:
        //                self.setVideoPreview()
        //                break
        //        }
    }
    
    // imageAnimator methods
    func addImageView() {
        if self.imageView == nil {
            let imgView = UIImageView(frame: self.bounds)
            self.addSubview(imgView)
            self.splt_constrainViewEqual(subView: imgView)
            self.bringSubviewToFront(imgView)
            self.imageView = imgView
        }
        
        var strImagePath: String?
        strImagePath = self.curVideo?.thumb

        if self.thumbnailPreviewType == .poster, let strPoster = self.curVideo?.poster {
            strImagePath = strPoster
        } else if self.thumbnailPreviewType == .wallpaper, let strWallpaper = self.curVideo?.wallpaper {
            strImagePath = strWallpaper
        }
        if let imageView = self.imageView, let strImagePath_ = strImagePath {
            let width = Int(imageView.frame.width)
            let height = Int(imageView.frame.height)
            if let url = URL(string: "\(strImagePath_)/\(width)/\(height)") {
                imageView.splt_setImageFromURL(url)
            }
        }
    }
    func setVideoImagesForCurVideo() {
        self.imageView?.layer.removeAllAnimations()
        self.animationCount = 0
        if let animationTimer = self.animationTimer {
            animationTimer.invalidate()
            self.animationTimer = nil
        }
        self.animationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SPLTMiniVideoView.animateVideoImagesFromCurrentVideo), userInfo: nil, repeats: true)
        self.animateVideoImagesFromCurrentVideo()
        
    }
    
    
    open var animationCount: Int = 0
    open var curFocusedVideoIndex: Int = 0
    open var animationTimer: Timer?
    
    @objc func animateVideoImagesFromCurrentVideo() {
        if let curVideo = self.curVideo {
            let totalThumbUrls = curVideo.thumbs.count
            var strImagePath = ""
            if let strThumb = curVideo.thumb {
                strImagePath = strThumb
            }
            
            if (totalThumbUrls > 0) {
                strImagePath = curVideo.thumbs[(self.animationCount % totalThumbUrls)]
            }
            let width = Int((self.imageView?.frame.width)!)
            let height = Int((self.imageView?.frame.height)!)
            
            self.animationCount += 1
            
            if let url = URL(string: "\(strImagePath)/\(width)/\(height)"), let imageView = self.imageView {
                imageView.splt_setImageFromURL(url, placeholder: nil, format: nil, failure: { (error) in
                    //print("Revry"+error.debugDescription)
                }, success: { (image) in
                    UIView.transition(with: imageView,
                                      duration:1,
                                      options: UIView.AnimationOptions.transitionCrossDissolve,
                                      animations: {
                                        imageView.image = image
                    },
                                      completion: nil)
                    
                })
            }
        }
        
    }
    
    
    // videoPreview methods
    var spltPlayerViewController: SPLTPlayerViewController?
    var timerVideoPreviewStart: Timer?
    func setVideoPreviewTimer() {
        if let timerVideoPreviewStart = self.timerVideoPreviewStart {
            timerVideoPreviewStart.invalidate()
            self.timerVideoPreviewStart = nil
        }
        
        self.timerVideoPreviewStart = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SPLTMiniVideoView.setVideoPreview), userInfo: nil, repeats: false)
    }
    @objc func setVideoPreview() {
        if let spltPlayerViewController = self.spltPlayerViewController {
            spltPlayerViewController.softRemoveAVPlayer()
            //            spltPlayerViewController.stopAndRemoveAVPlayerViewController()
            //            self.spltPlayerViewController = nil
        } else {
            if let spltPlayerViewController = SPLTPlayerViewController.getViewController() {
                spltPlayerViewController.shouldTrackAnalytics = false
                self.addSubview(spltPlayerViewController.view)
                self.splt_constrainViewEqual(subView: spltPlayerViewController.view)
                self.spltPlayerViewController = spltPlayerViewController
            }
        }
        if let spltPlayerViewController = self.spltPlayerViewController,
            let curVideo = self.curVideo {
            //        tvosVideoViewController.isMuted = true
            //            spltPlayerViewController.delegate = self
            spltPlayerViewController.curVideo = curVideo
            spltPlayerViewController.bAdsEnabled = false
            
            //            self.addSubview(spltPlayerViewController.view)
            //            self.splt_constrainViewEqual(subView: spltPlayerViewController.view)
            //            self.spltPlayerViewController = spltPlayerViewController
            self.imageView?.isHidden = true
            spltPlayerViewController.loadVideoDetailFromPlay2Route()
            //            self.addChild(spltPlayerViewController)
        }
    }
    
    // Helper methods
    
    open func showfocus() {
        // Show when focused
        switch self.previewType {
        case .imageAnimator:
            self.setVideoImagesForCurVideo()
            break
        case .videoPreview:
            if let imageView = self.imageView {
                imageView.isHidden = false
                self.bringSubviewToFront(imageView)
            }
            self.setVideoPreviewTimer()
            break
        }
    }
    open func hidefocus() {
        switch self.previewType {
        case .imageAnimator:
            self.imageView?.layer.removeAllAnimations()
            self.animationCount = 0
            if let animationTimer = self.animationTimer {
                animationTimer.invalidate()
                self.animationTimer = nil
            }
            break
        case .videoPreview:
            if let timerVideoPreviewStart = self.timerVideoPreviewStart {
                timerVideoPreviewStart.invalidate()
                self.timerVideoPreviewStart = nil
            }
            if let spltPlayerViewController = self.spltPlayerViewController {
                spltPlayerViewController.softRemoveAVPlayer()
                //                spltPlayerViewController.stopAndRemoveAVPlayerViewController()
                //                spltPlayerViewController.view.removeFromSuperview()
                //                self.spltPlayerViewController = nil
            }
            break
        }
        
    }
    
}







