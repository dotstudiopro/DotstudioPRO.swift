//
//  DotstudioIMAPlayerViewController.swift
//  DotstudioIMAPlayer
//
//  Created by Ketan Sakariya on 23/05/18.
//

import UIKit


//public typealias DSPPlayerViewController = DotstudioIMAPlayerViewController

//public protocol DotstudioIMAPlayerViewControllerDelegate {
//    func didClickCloseButton(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
//    func didClickCastButton(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
//    func didClickShareButton(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
//    func didClickShareButtonWithSender(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController, sender: UIButton)
//    func didFinishPlayingVideo(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
//}
open class DotstudioIMAPlayerViewController: SPLTVideoViewController {
    
    
    
//    open var delegate: DotstudioIMAPlayerViewControllerDelegate?
//    class open func getViewController(theme: [DSPPlayerTheme: UInt32]?) -> DotstudioIMAPlayerViewController? {
//        
//        let storyboard = UIStoryboard(name:"DotstudioIMAPlayerViewController", bundle:Bundle(for:self))
//        let vc = storyboard.instantiateViewController(withIdentifier: "DotstudioIMAPlayerViewController")
//        if let vcDotstudioIMAPlayer = vc as? DotstudioIMAPlayerViewController {
//            if let playerTheme = theme {
//                vcDotstudioIMAPlayer.playerTheme = playerTheme
//            }
//            return vcDotstudioIMAPlayer
//        }
//
////        return storyboard.instantiateViewController(withIdentifier: "test")
//        return nil
//
//    }
    
//    override open func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        DSCastUtility.shared.initialize(withDelegate: self)
//    }
//
//    override open func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    func didLoadIMAAdsManager(_ imaAdsManager: IMAAdsManager) {
//        SPLTAnalyticsUtility.sharedInstance.didLoadIMAAdsManager(imaAdsManager, fromVC: self)
//    }
    
//    @IBAction override func onClickCloseButton(_ sender: Any) {
//        //self.closeViewController()
//        self.saveCurrentVideoProgress()
//        self.delegate?.didClickCloseButton(self)
//        self.deallocateThePlayerObject()
////        self.delegate?.didClickCloseButton(sender: sender)
//    }
//    @IBAction override func onClickCastButton(_ sender: Any) {
//        //self.castVideo()
//        if let isGeoblocked = self.curVideo?.isGeoblocked, isGeoblocked == true {
//            self.showAlertWithMessage(message: "This content is geoblocked in your region.")
//        } else {
//            //self.delegate?.didClickCastButton(self)
//            //self.castVideo()
//            if let curVideo = self.curVideo {
//                self.castVideo()
//            }
//        }
//    }
//    @IBAction override func onClickShareButton(_ sender: UIButton) {
//            self.delegate?.didClickShareButtonWithSender(self, sender: sender)
//    }

//    override func allContentDidFinishPlayingWithAd() {
//        print("all ads completed & video completed")
//        super.allContentDidFinishPlayingWithAd()
//        self.delegate?.didFinishPlayingVideo(self)
//    }
}





