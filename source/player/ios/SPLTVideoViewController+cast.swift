//
//  SPLTVideoViewController+cast.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 24/02/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation

extension SPLTVideoViewController {
    
    func setupCastData() {
        if let curVideo = self.curVideo {
            if let strThumbPath = curVideo.thumb {
                if let url = URL(string: strThumbPath) {
//                    self.imageViewChannelVideo.splt_setImageFromURL(url, placeholder: nil)
                    self.imageViewChannelVideo.splt_setImageFromURL(url)
                    self.imageViewCastView.splt_setImageFromURL(url)
                }
            }
        }
        DSCastUtility.shared.delegate = self
        
        
        if #available(iOS 11.0, *) {
            self.airplayViewCastView = DSAirPlayCastUtility.shared.loadAVPickerView(view: self.buttonCastView)
            self.airplayViewCastView?.isHidden = true
            if let airplayViewCastView = self.airplayViewCastView {
                self.buttonCastView.addSubview(airplayViewCastView)
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
    func castVideo() {
//        guard let castVC = DotstudioIMAPlayerViewController.getCastViewController() else { return  }
//        let castViewcontroller = castVC as! DSCastViewController
//        castViewcontroller.selectedVideo = self.curVideo
//        castViewcontroller.modalPresentationStyle = .overFullScreen
//        self.present(castViewcontroller, animated: true, completion: nil)
//
        if let curVideo = self.curVideo {
//            self.pause()
            DSCastUtility.shared.onClickCastVideo(video: curVideo, fromViewController: self)
        }
    }
    func stopCasting() {
//        self.castVideo()
        DSCastUtility.shared.stopCasting(video: self.curVideo, fromViewController: self)
    }
    func updateUIwhenVideoCastInProgress() {
        self.imageViewChannelVideo.isHidden = false
        self.viewVideoControlsBottom.isHidden = true
        self.buttonPlayPause.isHidden = true
        self.buttonTopBarClose.isHidden = true
    }
    func updateUIwhenVideoCastFinish() {
        self.imageViewChannelVideo.isHidden = true
        self.viewVideoControlsBottom.isHidden = false
        self.buttonPlayPause.isHidden = false
        self.buttonTopBarClose.isHidden = false
//        if SPLTConfig.USE_NAVIGATIONBAR_ON_CHANNEL_SCREEN {
//            self.buttonTopBarClose.isHidden = true
//        }
    }
}


//MARK: -
//MARK: - extension DTSZSharedCastControllerDelegate
//extension SPLTVideoViewController: DTSZSharedCastControllerDelegate {
//    func didConnectedToCastDevice() {
//        if self.isAdPlayback {
//            self.adsManager?.pause()
//        } else {
//            if let contentPlayer = self.contentPlayer {
//                self.removeObservers(contentPlayer)
//                contentPlayer.pause()
//            }
//        }
//        self.updateUIwhenVideoCastInProgress()
//    }
//    func didDisconnectedFromCastDevice() {
//        self.updateUIwhenVideoCastFinish()
//        if self.isAdPlayback {
//            self.adsManager?.resume()
//        } else {
//            if let contentPlayer = self.contentPlayer {
//                contentPlayer.play()
//                self.addObservers(contentPlayer)
//            }
//        }
//        self.shouldIgnoreRemovingContentPlayer = false
//    }
//    func didClickCloseButton() {
////        self.videoViewController.didClickCloseButtonOnCastVC()
//        self.shouldIgnoreRemovingContentPlayer = false
//    }
//}

extension SPLTVideoViewController: DSCastUtilityDelegate {
    
    func didConnectedToCastDevice() {
//        self.pause()
        if let curVideo = self.curVideo {
//            DSCastUtility.shared.PlayConnectedCastVideo(video: curVideo, onVC: self)
        }
    }
    
    func didDisconnectedFromCastDevice() {
//        self.play()
    }
    
    func didStartPlayingCastVideo() {
//        self.pause()
        self.viewCastView.isHidden = false
        if let curCastDeviceModel = DSCastUtility.shared.curCastDeviceModel {
            switch curCastDeviceModel.castDevicePlatform {
            case .apple:
                self.airplayViewCastView?.isHidden = false
                break
            case .chromeCast:
                self.airplayViewCastView?.isHidden = true
                break
            default:
                break
            }
        }
     }
    func didStopPlayingCastVideo() {
//        self.play()
        self.viewCastView.isHidden = true
    }
    func didCancelPlayingCastVideo() {
//        self.play()
    }
    func didRequestMediaPlay() {
        self.play()
    }
    func didRequestMediaPause() {
        self.pause()
    }
    
}



