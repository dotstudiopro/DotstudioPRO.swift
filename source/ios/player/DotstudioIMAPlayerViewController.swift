//
//  DotstudioIMAPlayerViewController.swift
//  DotstudioIMAPlayer
//
//  Created by Ketan Sakariya on 23/05/18.
//

import UIKit


public typealias DSPPlayerViewController = DotstudioIMAPlayerViewController

public protocol DotstudioIMAPlayerViewControllerDelegate {
    func didClickCloseButton(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
    func didClickCastButton(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
    func didClickShareButton(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
    func didClickShareButtonWithSender(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController, sender: UIButton)
    func didFinishPlayingVideo(_ dotstudioIMAPlayerViewController: DotstudioIMAPlayerViewController)
}
open class DotstudioIMAPlayerViewController: SPLTVideoViewController {
    
    
    
    open var delegate: DotstudioIMAPlayerViewControllerDelegate?
    class open func getViewController(theme: [DSPPlayerThemeColor: UInt32]?) -> DotstudioIMAPlayerViewController? {
        
        //        let storyboardName = "DotstudioIMAPlayerViewController"
        
//        let bundle = Bundle(for: type(of: self))
        //        let path = bundle.path(forResource: storyboardName, ofType: type)
//        let storyboardBundle = Bundle(identifier: "com.dotstudioz.DotstudioIMAPlayer")
//        let storyboardBundle = Bundle(for: ViewController.self)
        //        super.init(nibName: "DotstudioIMAPlayerViewController", bundle: storyboardBundle)
//        let storyboard = UIStoryboard(name: storyboardName, bundle: storyboardBundle)
        
        let storyboard = UIStoryboard(name:"DotstudioIMAPlayerViewController", bundle:Bundle(for:self))
        let vc = storyboard.instantiateViewController(withIdentifier: "DotstudioIMAPlayerViewController")
        if let vcDotstudioIMAPlayer = vc as? DotstudioIMAPlayerViewController {
            if let playerTheme = theme {
                vcDotstudioIMAPlayer.playerTheme = playerTheme
            }
            return vcDotstudioIMAPlayer
        }

//        return storyboard.instantiateViewController(withIdentifier: "test")
        return nil

    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        DSCastUtility.shared.initialize(withDelegate: self)
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction override func onClickCloseButton(_ sender: Any) {
        //self.closeViewController()
        self.saveCurrentVideoProgress()
        self.delegate?.didClickCloseButton(self)
        self.deallocateThePlayerObject()
//        self.delegate?.didClickCloseButton(sender: sender)
    }
    @IBAction override func onClickCastButton(_ sender: Any) {
        //self.castVideo()
        if let isGeoblocked = self.curVideo?.isGeoblocked, isGeoblocked == true {
            self.showAlertWithMessage(message: "This content is geoblocked in your region.")
        } else {
            //self.delegate?.didClickCastButton(self)
            //self.castVideo()
            if let curVideo = self.curVideo {
                self.castVideo()
            }
        }
//        self.delegate?.didClickCastButton(sender: sender)
    }
    @IBAction override func onClickShareButton(_ sender: UIButton) {
        //self.shareButtonTapped(sender: sender)
            self.delegate?.didClickShareButtonWithSender(self, sender: sender)
//        self.delegate?.didClickShareButton(sender: sender)
    }

    override func allContentDidFinishPlayingWithAd() {
        print("all ads completed & video completed")
        self.delegate?.didFinishPlayingVideo(self)
    }
//    override func contentDidFinishPlaying(_ notification: Notification) {
//        super.contentDidFinishPlaying(notification)
//        self.delegate?.didFinishPlayingVideo(self)
//    }
}





