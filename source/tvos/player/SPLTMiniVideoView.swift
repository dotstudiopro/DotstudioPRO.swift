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
        if let strImagePath = self.curVideo?.thumb {
            let width = Int((self.imageView?.frame.width)!)
            let height = Int((self.imageView?.frame.height)!)
            if let url = URL(string: "\(strImagePath)/\(width)/\(height)") {
                self.imageView?.splt_setImageFromURL(url)
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
            spltPlayerViewController.stopAndRemoveAVPlayerViewController()
            self.spltPlayerViewController = nil
        }
        if let spltPlayerViewController = SPLTPlayerViewController.getViewController(),
            let spltVideo = self.curVideo {
            //        tvosVideoViewController.isMuted = true
//            spltPlayerViewController.delegate = self
            spltPlayerViewController.spltVideo = spltVideo
            spltPlayerViewController.bAdsEnabled = false
            //self.show(tvosVideoViewController, sender: self)
            //            self.present(spltPlayerViewController, animated: true, completion: nil)
            
            self.addSubview(spltPlayerViewController.view)
            self.splt_constrainViewEqual(subView: spltPlayerViewController.view)
            self.spltPlayerViewController = spltPlayerViewController
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
                spltPlayerViewController.stopAndRemoveAVPlayerViewController()
                spltPlayerViewController.view.removeFromSuperview()
                self.spltPlayerViewController = nil
            }
            break
        }
        
    }
    
}







