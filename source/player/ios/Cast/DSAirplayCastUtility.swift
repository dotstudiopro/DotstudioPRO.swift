//
//  DSAirplayCastUtility.swift
//  SampleCastApp
//
//  Created by Anwar Hussain  on 23/04/19.
//  Copyright © 2019 Anwar Hussain . All rights reserved.
//

import Foundation
import AVKit
import AVFoundation

@available(iOS 11.0, *)
class DSAirPlayCastUtility: NSObject{
    static let shared = DSAirPlayCastUtility()
    var airPlayView : AVRoutePickerView?
    var isAirPlayConnected: Bool?
    var video: SPLTVideo?
    var viewController: UIViewController?
    let moviePlayerViewController: AVPlayerViewController = AVPlayerViewController()
    let airplayCastDeviceModel: DSCastDeviceModel = DSCastDeviceModel(castDevicePlatform: .apple, castDeviceFriendlyName: "AirPlay & Bluetooth", deviceObject: nil, castImageName: "airplay_logo" )
    var castDeviceModel: DSCastDeviceModel?

    
    var delegate: DSBaseCastUtilityDelegate?
    
    override init() {
        super.init()
        self.castDeviceModel = self.airplayCastDeviceModel
    }
    func initWithAVAudioSession() {
        let session = AVAudioSession.sharedInstance()
        print(session.currentRoute.outputs)
        self.isAirPlayConnected = false
        
        for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.airPlay {
            print("airplay")
            self.isAirPlayConnected = true
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(routesDetected(notification:)),
                                               name: Notification.Name.AVRouteDetectorMultipleRoutesDetectedDidChange,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(handleRouteChange(notification:)),
                                               name:AVAudioSession.routeChangeNotification,
                                               object: AVAudioSession.sharedInstance())
        
        
        NotificationCenter.default.addObserver(self,
                       selector: #selector(handleScreenDidConnectNotification(notification:)),
                                               name:UIScreen.didConnectNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                   selector: #selector(handleScreenDidDisconnectNotification(notification:)),
                                               name:UIScreen.didDisconnectNotification,
                                               object: nil)
        
        
    }
    
    func loadAVPickerView(view: UIView) -> AVRoutePickerView {
        let airPlayView = AVRoutePickerView()
        //airPlayView.delegate = (self as! AVRoutePickerViewDelegate)
        airPlayView.frame.size = view.bounds.size//(cell?.contentView.bounds.size)!
       
        for (_,button) in (airPlayView.subviews.filter{$0 is UIButton}).enumerated() {
            let airplaybutton = button as! UIButton
            airplaybutton.isHidden = true
        }
        airPlayView.delegate = self
        self.castDeviceModel = self.airplayCastDeviceModel
        return airPlayView
    }
    
    /*
    func avPickerView(viewController:UIViewController) {
        //you can change the bounds for the AirPlayButton
        airPlayView = AVRoutePickerView(frame: CGRect(x: 150, y: 150, width: 40, height: 40))
        airPlayView!.delegate = viewController.self as? AVRoutePickerViewDelegate
        viewController.view.addSubview(airPlayView!)
    }*/
    
//    func avPlayerWithExternalPlayback(videoUrl:String = "https://s0.2mdn.net/instream/videoplayer/media/android.mp4", onViewController viewController:UIViewController) {
//        // Create the view controller and player
//        let moviePlayerViewController: AVPlayerViewController = AVPlayerViewController()
//        let videoUrl = videoUrl
//        let url = URL(string: videoUrl)
//        let moviePlayer = AVPlayer(url: url!)
//
//        moviePlayer.allowsExternalPlayback = true
//        moviePlayer.usesExternalPlaybackWhileExternalScreenIsActive = true
//
//        // Initialize the AVPlayer
//        moviePlayerViewController.player = moviePlayer
//        // Present movie player and play when completion
//        viewController.present(moviePlayerViewController, animated: false, completion: {
//            moviePlayerViewController.player?.play()
//        })
//    }
    
    func avPlayerWithExternalPlayback() {
        guard let video = self.video, let viewController = self.viewController else {
            return
        }
        self.avPlayerWithExternalPlayback(video: video, onViewController: viewController)
    }
    func avPlayerWithExternalPlayback(video: SPLTVideo, onViewController viewController:UIViewController) {
        // Create the view controller and player
//        let moviePlayerViewController: AVPlayerViewController = AVPlayerViewController()
        guard let strVideoUrl = video.strVideoUrl, let urlVideo = URL(string: strVideoUrl) else {
            return
        }
        
        let moviePlayer = AVPlayer(url: urlVideo)
        
        moviePlayer.allowsExternalPlayback = true
        moviePlayer.usesExternalPlaybackWhileExternalScreenIsActive = true
        
        // Initialize the AVPlayer
        self.moviePlayerViewController.player = moviePlayer
        // Present movie player and play when completion
        viewController.present(moviePlayerViewController, animated: false, completion: {
            self.moviePlayerViewController.player?.play()
        })
//        self.delegate?.didStartPlayingCastVideo(castDeviceModel: self.castDeviceModel)
    }
    

    @objc func handleScreenDidConnectNotification(notification: Notification) {
        if let newScreen = notification.object as? UIScreen {
            if newScreen == UIScreen.main {
                print("device screen")
            } else {
                print("airplay screen")
            }
        }
    }
    @objc func handleScreenDidDisconnectNotification(notification: Notification) {
        if let newScreen = notification.object as? UIScreen {
            if newScreen == UIScreen.main {
                print("device screen")
            } else {
                print("airplay screen")
            }
        }
    }
    @objc func routesDetected(notification: Notification) {
        print("routedupdated: \(notification)")
    }
    
    @objc func handleRouteChange(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue) else {
                return
        }
        print("ketan")
        print(reason)
        switch reason {
            
        case .unknown:
            print("unknown action")
            let session = AVAudioSession.sharedInstance()
            print(session.currentRoute.outputs)
            for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.airPlay {
                print("unknown airplay")
                self.isAirPlayConnected = true
//                self.delegate?.didStartPlayingCastVideo(castDeviceModel: self.castDeviceModel)
            }
        case .newDeviceAvailable:
            print("new device available")
            let session = AVAudioSession.sharedInstance()
            print(session.currentRoute.outputs)
            for output in session.currentRoute.outputs where output.portType == AVAudioSession.Port.airPlay {
                print("airplay")
                self.isAirPlayConnected = true
//                self.delegate?.didStartPlayingCastVideo(castDeviceModel: self.castDeviceModel)
            }
            
        case .oldDeviceUnavailable:
            print("old device unavailable")
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs where output.portType == AVAudioSession.Port.airPlay {
                    
                }
            }
        case .categoryChange:
            print("categoryChange")
        case .override:
            print("override")
            self.isAirPlayConnected = false
            self.delegate?.didStopPlayingCastVideo()
        case .wakeFromSleep:
            print("wakeFromSleep")
        case .noSuitableRouteForCategory:
            print("noSuitableRouteForCategory")
        case .routeConfigurationChange:
            print("routeConfigurationChange")
        default: ()
        }
    }
    
    func isAudioSessionUsingAirplayOutputRoute() -> Bool {
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        for outputPort in currentRoute.outputs {
            if outputPort.portType == .airPlay {
                return true
            }
        }
        return false
    }

}

@available(iOS 11.0, *)
extension DSAirPlayCastUtility: AVRoutePickerViewDelegate {
    func routePickerViewWillBeginPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print("picker will begin preesntingroutes")
    }
    
    func routePickerViewDidEndPresentingRoutes(_ routePickerView: AVRoutePickerView) {
        print("picker end preesntingroutes")
        
        //if self.isAirPlayConnected == true {
        if self.isAudioSessionUsingAirplayOutputRoute() {
            self.avPlayerWithExternalPlayback()
            self.delegate?.didStartPlayingCastVideo(castDeviceModel: self.castDeviceModel)
        } else {
            self.delegate?.didStopPlayingCastVideo()
        }
    }
}

@available(iOS 11.0, *)
extension DSAirPlayCastUtility : DSBaseCastUtility {
    func playCastVideo() {
        
    }
    func playConnectedCastVideo(video: SPLTVideo, onDevice castDeviceModel: DSCastDeviceModel, onViewController viewController: UIViewController) {
        self.video = video
        self.viewController = viewController
        self.avPlayerWithExternalPlayback(video: video, onViewController: viewController)
    }
    func initialize() {
    }
    
    func initializeWithDelegate(delegate: DSCastUtility) {
        self.initWithAVAudioSession()
        self.delegate = delegate
    }
    func stopCasting(video: SPLTVideo?, fromViewController viewController: UIViewController?) {
//        self.moviePlayerViewController.player?.allowsExternalPlayback = false
//        self.moviePlayerViewController.player?.usesExternalPlaybackWhileExternalScreenIsActive = false
        
        self.video = video
        self.viewController = viewController
        self.avPlayerWithExternalPlayback()
        //        self.delegate?.didStopPlayingCastVideo()
    }
}



