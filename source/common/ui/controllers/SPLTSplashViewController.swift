//
//  SPLTSplashViewController.swift
//  DotstudioUI
//
//  Created by primesoft on 08/05/18.
//

import UIKit
import Foundation
import AVKit
import AVFoundation


@IBDesignable
open class SPLTSplashViewController: SPLTBaseViewController {

    @IBOutlet weak open var imageView: UIImageView?
    @IBInspectable open var isVideoSplash: Bool = false
    @IBInspectable open var autoTimeOutDuration: Double = 1.0
    
    open var playerController:AVPlayerViewController?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        if self.isVideoSplash == true {
            self.loadVideoOnSplashScreen()
        } else {
            self.loadImageOnSplashScreen()
        }
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.playerController?.player?.play()
    }
    
    open func loadVideoOnSplashScreen() {
        self.imageView?.isHidden = true
        let playerController = AVPlayerViewController()
        if let splashPath: String = Bundle.main.path(forResource: "splash", ofType: "mp4") {
            self.imageView?.isHidden = true
            let splashUrl: URL = URL(fileURLWithPath: splashPath)
            let player = AVPlayer(url: splashUrl)
            
            playerController.player = player
            self.addChild(playerController)
            self.view.addSubview(playerController.view)
            playerController.view.frame = self.view.frame
            
            playerController.player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none
            playerController.showsPlaybackControls = false
            playerController.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspectFill.rawValue)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerItemDidReachEnd(_:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: playerController.player?.currentItem)
        }
        self.playerController = playerController
    }
    
    open func loadImageOnSplashScreen() {
        self.imageView?.isHidden = false
        
        Timer.scheduledTimer(timeInterval: self.autoTimeOutDuration, target: self, selector: #selector(self.checkSessionAndLogin), userInfo: nil, repeats: false)
    }
    
    // Handle Notification
    @objc func playerItemDidReachEnd(_ notification: Notification) {
        NotificationCenter.default.removeObserver(self)
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.checkSessionAndLogin), userInfo: nil, repeats: false)
        
    }
    
    @objc open func checkSessionAndLogin() {
        /*if let strAccessToken: String = UserDefaults.standard.value(forKey: "strAccessToken") as? String {
         SPLTRouter.strAccessToken = strAccessToken
         if let strClientToken: String = UserDefaults.standard.value(forKey: "strClientToken") as? String {
         print(strClientToken)
         SPLTRouter.strClientToken = strClientToken
         }
         self.loadMainViewController()
         } else {
         SPLTTokenAPI().getToken({ (strToken) in
         self.loadMainViewController()
         })
         }*/
        
        //        #if USE_DTSZHomeTabBarController
        //            self.loadMainViewController()
        //        #else
        //            if let strAccessToken: String = NSUserDefaults.standardUserDefaults().valueForKey("strAccessToken") as? String {
        //                SPLTRouter.strAccessToken = strAccessToken
        //                if let strClientToken: String = NSUserDefaults.standardUserDefaults().valueForKey("strClientToken") as? String {
        //                    print(strClientToken)
        //                    SPLTRouter.strClientToken = strClientToken
        //                }
        //                self.loadMainViewController()
        //            } else {
        //                // do login...
        //                DTSZAuth0iOSLoginUtility.sharedInstance.showLoginControllerFrom(self, completion: { (bSuccess) in
        //                    if bSuccess {
        //                        //self.delegate?.didFinishLoginSuccessfully()
        //                        self.loadMainViewController()
        //                    } else {
        //                        //self.delegate?.didFailedToLogin()
        //                    }
        //                }) { (error) in
        //                    // handle error.
        //                }
        //            }
        //        #endif
        
        SPLTTokenAPI().getToken({ (strToken) in
            self.loadMainViewController()
        })
    }
    
     open func loadMainViewController() {
        
//        let spltHomeTabBarController = self.getViewControllerFrom("SPLTHomeTabBarController", strViewControllerIdentifier: "SPLTHomeTabBarController")
//        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
//            appDelegate.window?.rootViewController = spltHomeTabBarController //homeTabBarController
//        }
        
        /*
     // Login check
     #if DTSZ_HORIZONTAL_SCROLL_CONTENTS
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
     if let homeNavigationController = mainStoryboard.instantiateViewController(withIdentifier: "mainNav") as? UINavigationController {
     if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
     appDelegate.window?.rootViewController = homeNavigationController //homeTabBarController
     }
     }
     #else
     
     #if DTSZ_SKIP_LOGIN
     let spotHomeStoryboard: UIStoryboard = UIStoryboard(name: "SpotHome", bundle: nil)
     let spotHomeTabBarNVC = spotHomeStoryboard.instantiateViewController(withIdentifier: "SpotHomeTabBarNVC")
     //let spotHomeNVC = UINavigationController(rootViewController: spotHomeViewController)
     if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
     appDelegate.window?.rootViewController = spotHomeTabBarNVC //homeTabBarController
     }
     
     #else
     if let strClientToken = UserDefaults.standard.value(forKey: "strClientToken") as? String {
     // SPLTRouter.strClientToken = strClientToken
     if let strAccessToken = UserDefaults.standard.value(forKey: "strAccessToken") as? String {
     //   SPLTRouter.strAccessToken = strAccessToken
     }
     
     let spotHomeStoryboard: UIStoryboard = UIStoryboard(name: "SpotHome", bundle: nil)
     let spotHomeTabBarNVC = spotHomeStoryboard.instantiateViewController(withIdentifier: "SpotHomeTabBarNVC")
     //let spotHomeNVC = UINavigationController(rootViewController: spotHomeViewController)
     if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
     appDelegate.window?.rootViewController = spotHomeTabBarNVC //homeTabBarController
     }
     } else {
     let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
     if let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: "login") as? TVOSSpotlightLoginViewController {
     if let appDelegate: AppDelegate = UIApplication.shared.delegate as? AppDelegate {
     appDelegate.window?.rootViewController = loginViewController //homeTabBarController
     }
     }
     }
     
     #endif
     #endif
 */
     }
    

}
