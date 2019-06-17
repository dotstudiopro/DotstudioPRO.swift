//
//  SPLTVideoViewController.swift
//  DotstudioIMAPlayer
//
//  Created by Ketan Sakariya on 23/05/18.
//

import Foundation
import AVFoundation
import GoogleInteractiveMediaAds
//import UIImageViewAlignedSwift
import AdSupport
import FontAwesomeKit_Swift


enum SPLTVideoPlayButtonType: Int {
    case playButton = 0
    case pauseButton = 1
}


open class SPLTVideoViewController: SPLTBaseViewController, IMAAdsLoaderDelegate, IMAAdsManagerDelegate {
    //        static let kTestAppContentUrl_MP4 = "http://rmcdn.2mdn.net/Demo/html5/output.mp4"
    //    static let kTestAppContentUrl_MP4 = "https://e4z6v2z8.ssl.hwcdn.net/files/company/57fe8fe399f815e309dbc2f4/assets/videos/5872f74399f8158b2a4c51b2/vod/5872f74399f8158b2a4c51b2.m3u8?hwauth=exp=1484778914974~acl=*~hmac=12e5c2c135a37e7cb7ae37b980889e36ac83a37e0acca2406aba9203414e9dcc" //"http://rmcdn.2mdn.net/Demo/html5/output.mp4"
    
    //    static let kTestAppAdTagUrl = "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    //    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    //    "output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&" +
    //    "correlator="
    //    static let kTestAppAdTagUrl = "http://shadow01.yumenetworks.com/dynamic_preroll_playlist.vast2xml?domain=1552hCkaKYjg"
    //    static let kTestAppAdTagUrl = "http://adserver.dotstudiopro.com/adserver/www/delivery/fc.php?script=apVideo:vast2&zoneid=1099"
    
    //IBOutlets
    @IBOutlet open weak var buttonClose: UIButton!
    
    @IBOutlet open weak var labelVideoTitle: UILabel!
    @IBOutlet open weak var viewVideoControlWithAd: UIView!
    @IBOutlet open weak var viewVideo: UIView!
    @IBOutlet open weak var viewVideoControls: UIView!
    @IBOutlet open weak var viewVideoControlsTop: EZYGradientView!
    @IBOutlet open weak var viewVideoControlsBottom: EZYGradientView!
    @IBOutlet open weak var labelSubtitles: UILabel!
    open var viewVideoFrame: CGRect?
    @IBOutlet weak open var imageViewChannelVideo: UIImageView!
    @IBOutlet weak open var imageViewVideoWaterMark: UIImageViewAligned!
    open var showFullDescription: Bool = false
    
    open var defaultLandscapeOrientation: UIInterfaceOrientation = .landscapeRight
//    @IBOutlet open var constraintAspectRatioVideoView: NSLayoutConstraint?
//    @IBOutlet open var constraintVideoViewBottom: NSLayoutConstraint?
//    @IBOutlet open var constraintLabelSubtitlesBottom: NSLayoutConstraint!
    
    @IBOutlet weak var viewTopLayerBgForAd: UIView!
    
    var isAdPlayback = false {
        didSet {
            if self.isAdPlayback {
                if self.showCloseCaption {
                    self.labelSubtitles.isHidden = true
                }
                if let curVideo = self.curVideo, curVideo.isVideoWaterMarkingEnabled {
                    self.imageViewVideoWaterMark.isHidden = true
                }
            } else {
                if self.showCloseCaption {
                    self.labelSubtitles.isHidden = false
                }
                if let curVideo = self.curVideo, curVideo.isVideoWaterMarkingEnabled {
                    self.imageViewVideoWaterMark.isHidden = false
                }
            }
            
        }
    }
    
    open var isShowingPostRollAd: Bool = false
    
    open var showCloseCaption = false {
        didSet {
            if self.showCloseCaption {
                self.labelSubtitles.isHidden = false
            } else {
                self.labelSubtitles.isHidden = true
            }
        }
    }
    @IBOutlet weak open var buttonPlayPause: UIButton!
    @IBOutlet weak open var labelVideoLiveStreaming: UILabel!
    @IBOutlet weak open var labelVideoProgress: UILabel!
    @IBOutlet weak open var sliderVideo: UISlider!
    @IBOutlet weak open var labelVideoDuration: UILabel!
    @IBOutlet weak open var buttonCloseCaption: UIButton!
    @IBOutlet weak open var buttonExpandFullScreen: UIButton!
    
//    @IBOutlet weak open var barButtonItemClose: UIBarButtonItem?
//    @IBOutlet weak open var barButtonItemShare: UIBarButtonItem?
//    @IBOutlet weak open var barButtonItemCast: UIBarButtonItem?
//    @IBOutlet weak open var constraintSpaceCloseCast: NSLayoutConstraint!
//    @IBOutlet weak open var constraintTopBarCloseWidth: NSLayoutConstraint!
    
    open var isTopBarCloseButtonHidden = false
    @IBOutlet weak open var buttonTopBarCloseWidthConstant: NSLayoutConstraint?
    
    @IBOutlet weak open var buttonTopBarClose: UIButton!
    @IBOutlet weak open var buttonTopBarShare: UIButton!
    @IBOutlet weak open var buttonTopBarCast: UIButton!
    
    
    @IBOutlet weak var viewCastView: UIView!
    @IBOutlet weak var imageViewCastView: UIImageView!
    @IBOutlet weak var buttonCastView: UIButton!
    var airplayViewCastView: UIView?
    
    
    @IBOutlet weak var constraintButtonCloseCaption: NSLayoutConstraint!
    open var isFullscreen = false {
        didSet {
            if self.isFullscreen {
                self.navigationController?.isNavigationBarHidden = true
//                self.constraintAspectRatioVideoView?.isActive = false
//                self.constraintVideoViewBottom?.isActive = true
            } else {
                //self.navigationController?.navigationBar.isHidden = false
                self.navigationController?.isNavigationBarHidden = false
//                self.constraintAspectRatioVideoView?.isActive = true
//                self.constraintVideoViewBottom?.isActive = false
            }
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    // Gesture recognizer for tap on video.
    var videoTapRecognizer: UITapGestureRecognizer?
    var videoControlsTapRecognizer: UITapGestureRecognizer?
    var initialFirstViewFrame: CGRect = CGRect.zero
    
    open var bAdsEnabled: Bool = true
    open var curVideo: SPLTVideo?
    open var iCurVideoProgressPoint: Int?
    open var shouldSkipLoadingFullVideo: Bool = false
    open var isVideoContentCompletePlaying: Bool = false
    open var shouldAutoRotateToLandscape: Bool = false
    
    var contentPlayer: AVPlayer? {
        didSet {
            if contentPlayer == nil {
                print("nil set")
            }
        }
    }
    open var avLayerVideoGravity: AVLayerVideoGravity?
    
    var playerLayer: AVPlayerLayer?
    let playerController = AVPlayerViewController()
    var contentRateContext: UInt8 = 1
    var contentDurationContext: UInt8 = 2
    var statusContext: UInt8 = 3
    var isFirstFramePlayed: Bool = false
    
    var contentPlayhead: IMAAVPlayerContentPlayhead?
    var adsLoader: IMAAdsLoader?
    var adsManager: IMAAdsManager?
    
    //    var iCurrentVideoIndex: Int = 0
    //    var videoDetail: DTSZVideo! = DTSZVideo()
    var strCurAdTagUrl: String?
    
    // Use below vars to show splash video
    open var shouldSkipResetViewsFrameBasedOnOrientation: Bool = false
    open var dontShowVideoControls: Bool = false
    open var dontShowTopVideoControls: Bool = false
    open var dontShowBottomVideoControls: Bool = false
    open var useMP4URL: Bool = false
    open var isMuted:Bool = false {
        didSet {
            self.contentPlayer?.isMuted = self.isMuted
        }
    }
    
    public struct Style {
        
        /// Title used in Header
        //        public var title: String
        
        /// Primary color of Lock used in the principal components like the Primary Button
        public var topBarBackgroundColor: UIColor = .clear //UIColor(hex8: 0x000000AA)
        public var topBarFirstColor: UIColor = .clear //UIColor(hex8: 0x000000AA)
        public var topBarSecondColor: UIColor = .clear //UIColor(hex8: 0x000000AA)
        
        /// Lock background color
        public var bottomBarBackgroundColor: UIColor = UIColor(hex8: 0x000000AA)
        public var bottomBarFirstColor: UIColor = UIColor(hex8: 0x000000AA)
        public var bottomBarSecondColor: UIColor = UIColor(hex8: 0x000000AA)
        
        public var closeIconColor: UIColor = .white
        public var castIconColor: UIColor = .white
        public var shareIconColor: UIColor = .white
        public var closeCaptionIconColor: UIColor = .white
        public var expandIconColor: UIColor = .white
        public var playpauseIconColor: UIColor = .white
        
        public var videoProgressTextColor: UIColor = .white
        public var videoDurationTextColor: UIColor = .white
        
        public var labelVideoTitleColor: UIColor = .white
        public var labelVideoProgressColor: UIColor = .white
        public var labelVideoDurationColor: UIColor = .white
        public var labelVideoLiveStreamingColor: UIColor = .white
        public var labelSubtitleColor: UIColor = .white
        
//        public var sliderVideoBackgroundColor: UIColor = .lightGray
        public var sliderVideoThumbTintColor: UIColor = .white
        public var sliderVideoTintColor: UIColor = .white
        
        public init() {
            
        }
        
    }
    
    open var style: DotstudioIMAPlayerViewController.Style = DotstudioIMAPlayerViewController.Style()
    let imageIconDefaultSize = CGSize(width: 66, height: 66)

    var imageButtonPlay = UIImage(icon: .FAPlay, size: CGSize(width: 66, height: 66), textColor: .white, backgroundColor: .clear)
    var imageButtonPause = UIImage(icon: .FAPause, size: CGSize(width: 66, height: 66), textColor: .white, backgroundColor: .clear)

    
    override open func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        
        self.labelSubtitles.text = ""
        self.showCloseCaption = false
        
        
        
//        self.setupStyle()
        
        if let image = UIImage(named: "AppIconNavBarLogo") {
            self.navigationItem.titleView = UIImageView(image: image) //imageView
        }
        
        
        //self.requestAds()
//        self.viewVideoControls.isHidden = true
        self.updateSubtitlesPosition()
        
        self.initialFirstViewFrame = self.view.frame
        
        self.viewVideoControlWithAd.layer.anchorPoint.applying(CGAffineTransform.init(translationX: -0.5, y: -0.5))
        
        self.registerNotifications()
    
    }
    
    deinit {
        self.deRegisterNotifications()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        self.setupStyle()
//        if SPLTConfig.USE_NAVIGATIONBAR_ON_CHANNEL_SCREEN {
//            self.buttonTopBarClose.isHidden = true
//            self.constraintTopBarCloseWidth.constant = 0
//            self.constraintSpaceCloseCast.constant = 0
//            self.barButtonItemClose?.image = nil
//            self.barButtonItemShare?.image = nil
//            self.navigationController?.navigationBar.isHidden = false
//        }
        
        self.applicationDidBecomeActive()
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        self.playerController.view.frame = self.viewVideo.bounds
        self.adsLoader?.delegate = self
        self.viewVideoFrame = self.viewVideo.frame
        
//        self.buttonTopBarClose.setFAIcon(icon: .FAClose, forState: .normal)
        self.buttonTopBarClose.fa.setTitle(.close, for: .normal)
//        self.buttonTopBarShare.setFAIcon(icon: .FAShare, forState: .normal)
        self.buttonTopBarShare.fa.setTitle(.shareAlt, for: .normal)
        self.setPlayButtonType(.playButton)
//        self.buttonExpandFullScreen.setFAIcon(icon: .FAExpand, forState: .normal)
        self.buttonExpandFullScreen.fa.setTitle(.expand, for: .normal)
//        self.buttonCloseCaption.setFAIcon(icon: .FACc, forState: .normal)
        self.buttonCloseCaption.fa.setTitle(.cc, for: .normal)
//        self.buttonCloseCaption.setFAIcon(icon: .FACc, forState: .selected)
        self.buttonCloseCaption.fa.setTitle(.cc, for: .selected)
        
//        if SPLTConfig.USE_NAVIGATIONBAR_ON_CHANNEL_SCREEN {
//            self.buttonTopBarClose.isHidden = true
//            self.constraintTopBarCloseWidth.constant = 0
//            self.constraintSpaceCloseCast.constant = 0
//            self.barButtonItemClose?.image = nil
//            self.barButtonItemShare?.image = nil
//            if UIDevice.current.userInterfaceIdiom == .pad {
//                self.barButtonItemClose?.setFAIcon(icon: .FAChevronLeft, iconSize: 33.0)
//                self.barButtonItemShare?.setFAIcon(icon: .FAShare, iconSize: 44.0)
//            } else {
//                self.barButtonItemClose?.setFAIcon(icon: .FAChevronLeft, iconSize: 22.0)
//                self.barButtonItemShare?.setFAIcon(icon: .FAShare, iconSize: 22.0)
//            }
//            self.navigationController?.navigationBar.isHidden = false
//        }
        self.checkAndHideTheCloseButton()
    }
    
    func checkAndHideVideoControls() {
        if self.dontShowVideoControls {
            self.viewVideoControls.isHidden = true
        }
        if self.dontShowTopVideoControls {
            self.viewVideoControlsTop.isHidden = true
        }
        if self.dontShowBottomVideoControls {
            self.viewVideoControlsBottom.isHidden = true
        }
    }
    func checkAndHideTheCloseButton() {
        if self.isTopBarCloseButtonHidden == true {
            self.buttonTopBarCloseWidthConstant?.constant = 0
            self.buttonTopBarClose.isHidden = self.isTopBarCloseButtonHidden
            self.buttonTopBarClose.updateConstraints()
        }
    }
    
    func setupStyle() {
        self.imageButtonPlay = UIImage(icon: .FAPlay, size: CGSize(width: 66, height: 66), textColor: self.style.playpauseIconColor, backgroundColor: .clear)
        self.imageButtonPause = UIImage(icon: .FAPause, size: CGSize(width: 66, height: 66), textColor: self.style.playpauseIconColor, backgroundColor: .clear)
        
        let imageTopBarClose = UIImage(icon: .FAClose, size: self.imageIconDefaultSize, textColor: self.style.closeIconColor, backgroundColor: .clear)
        self.buttonTopBarClose.setImage(imageTopBarClose, for: .normal)
        
        let imageTopBarShare = UIImage(icon: .FAShare, size: self.imageIconDefaultSize, textColor: self.style.shareIconColor, backgroundColor: .clear)
        self.buttonTopBarShare.setImage(imageTopBarShare, for: .normal)
        
        self.setPlayButtonType(.playButton)
        self.buttonPlayPause.backgroundColor = UIColor.clear
        
        let imageExpandFullScreen = UIImage(icon: .FAExpand, size: self.imageIconDefaultSize, textColor: self.style.expandIconColor, backgroundColor: .clear)
        self.buttonExpandFullScreen.setImage(imageExpandFullScreen, for: .normal)
        
        let imageCloseCaption = UIImage(icon: .FACc, size: CGSize(width: self.imageIconDefaultSize.width-10, height: self.imageIconDefaultSize.height-10), textColor: self.style.closeCaptionIconColor, backgroundColor: .clear)
        let imageCloseCaptionSelected = UIImage(icon: .FACc, size: CGSize(width: self.imageIconDefaultSize.width-10, height: self.imageIconDefaultSize.height-10), textColor: .darkGray, backgroundColor: .clear)

        self.buttonCloseCaption.setImage(imageCloseCaption, for: .normal)
        self.buttonCloseCaption.setImage(imageCloseCaptionSelected, for: .selected)
        self.buttonCloseCaption.isHidden = true
        
        self.labelVideoTitle.textColor = self.style.labelVideoTitleColor
        self.labelVideoProgress.textColor = self.style.labelVideoProgressColor
        self.labelVideoDuration.textColor = self.style.labelVideoDurationColor
        self.labelVideoLiveStreaming.textColor = self.style.labelVideoLiveStreamingColor
        self.labelSubtitles.textColor = self.style.labelSubtitleColor
        self.sliderVideo.thumbTintColor = self.style.sliderVideoThumbTintColor
        self.sliderVideo.tintColor = self.style.sliderVideoTintColor
        
        self.viewVideoControlsTop.backgroundColor = self.style.topBarBackgroundColor
        self.viewVideoControlsTop.firstColor = self.style.topBarFirstColor
        self.viewVideoControlsTop.secondColor = self.style.topBarSecondColor
        self.viewVideoControlsBottom.backgroundColor = self.style.bottomBarBackgroundColor
        self.viewVideoControlsBottom.firstColor = self.style.bottomBarFirstColor
        self.viewVideoControlsBottom.secondColor = self.style.bottomBarSecondColor
    }
    
    var shouldIgnoreRemovingContentPlayer: Bool = false
    override open func viewWillDisappear(_ animated: Bool) {
        self.applicationWillResignActive()
        super.viewWillDisappear(animated)
    }

    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        if self.shouldSkipResetViewsFrameBasedOnOrientation {
            return
        }
        self.resetViewsFrameBasedOnOrientation()
        self.checkAndHideVideoControls()
    }
    
    override open func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.resetViewLayersFrame()
        
        self.checkAndHideTheCloseButton()
        self.checkAndHideVideoControls()
    }
    
    open func deallocateThePlayerObject() {
        if self.shouldIgnoreRemovingContentPlayer {
            return
        }
        // cancelled & removed complete player, so it doesn't play in background.
        if let curVideo = self.curVideo {
            curVideo.cancelLoadFullVideo()
        }
        self.adsLoader?.delegate = nil
        self.adsLoader = nil
        // Don't reset if we're presenting a modal view (e.g. in-app clickthrough).
        //        if ((self.navigationController?.viewControllers as NSArray).index(of: self) == NSNotFound) {
        if let adsManager = self.adsManager {
            adsManager.destroy()
        }
        self.adsManager = nil
        if let contentPlayer = self.contentPlayer {
            self.removeObservers(contentPlayer)
            contentPlayer.pause()
            contentPlayer.replaceCurrentItem(with: nil)
        }
        self.contentPlayer = nil
        //        }
    }
    
    open func resetViewsFrameBasedOnOrientation() {
        var isLandscape = UIDevice.current.orientation.isLandscape
        if UIDevice.current.orientation.isPortrait {
            isLandscape = false
        }
        let sizeView = self.view.frame.size
        if UIDevice.current.orientation.isFlat {
            if sizeView.width > sizeView.height {
                isLandscape = true
            } else {
                isLandscape = false
            }
        }
        if isLandscape {
            let frameWidth = sizeView.width
            let frameHeight = sizeView.height
            self.viewVideoControlWithAd.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
            self.isFullscreen = true
        } else {
            let frameWidth = sizeView.width
            let frameHeight = frameWidth * 9.0 / 16.0
            self.viewVideoControlWithAd.frame = CGRect(x: 0, y: 0, width: frameWidth, height: frameHeight)
            self.isFullscreen = false
        }
        self.viewVideo.frame = self.viewVideoControlWithAd.bounds
        self.viewVideoControls.frame = self.viewVideoControlWithAd.bounds
        self.viewVideoControlsBottom.frame = CGRect(x: 0, y: self.viewVideoControls.frame.height - self.viewVideoControlsBottom.frame.height, width: self.viewVideoControls.frame.width, height: self.viewVideoControlsBottom.frame.height)
        self.resetViewLayersFrame()
    }
    open func resetViewLayersFrame() {
        self.viewVideoControlsTop.gradientLayer?.frame = self.viewVideoControlsTop.bounds
        self.viewVideoControlsBottom.gradientLayer?.frame = self.viewVideoControlsBottom.bounds
        self.playerLayer?.frame = self.viewVideo.layer.bounds
    }
    
    open func registerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    open func deRegisterNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    override open var prefersStatusBarHidden: Bool {
        if self.isFullscreen {
            return true
        }
        return false
//        if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
//            return true
//        }
//        return false
    }
    override open var shouldAutorotate: Bool {
        get {
            return true
        }
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        get {
            return .all
            //            if fullscreen {
            //                return UIInterfaceOrientationMask.landscape
            //            } else {
            //                return UIInterfaceOrientationMask.portrait
            //            }
        }
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            print("Landscape")
            if let window = self.viewVideoControlWithAd.window {
                self.viewVideoControlWithAd.removeFromSuperview()
                window.addSubview(self.viewVideoControlWithAd)
                self.viewVideoControlWithAd.frame = window.bounds
                self.splt_constrainViewEqual(holderView: window, view: self.viewVideoControlWithAd)
            }
            self.isFullscreen = true
            //            UIApplication.shared.isStatusBarHidden = true
        } else if UIDevice.current.orientation.isPortrait {
            print("Portrait")
            self.viewVideoControlWithAd.removeFromSuperview()
            self.view.addSubview(self.viewVideoControlWithAd)
            self.viewVideoControlWithAd.frame = self.view.frame
            self.splt_constrainViewEqual(holderView: self.view, view: self.viewVideoControlWithAd)
            self.isFullscreen = false
            //            UIApplication.shared.isStatusBarHidden = false
        }
        self.view.layoutSubviews()
        self.setNeedsStatusBarAppearanceUpdate()
        //        if (UIDevice.current.userInterfaceIdiom == .pad) {
        //            if(UIDeviceOrientationIsLandscape(UIDevice.current.orientation)) {
        //                self.setUIforLandscapeIPADChannel()
        //            } else {
        //                self.setUIforPortraitIPADChannel()
        //            }
        //        }
        
    }
    
    func playNextVideo() { // interface, so next video can be played after ad finish playing.
    }
    func closeViewController() {
        self.saveCurrentVideoProgress()
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.end_playback, video: self.curVideo)
        self.addAnalyticsEvent(.playback, analyticsEventType: .end_playback)
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
    open func setCurrentVideo(curVideo: SPLTVideo) {
        if self.isVideoSetupOnGoing {
            return
        }
        
        self.isVideoSetupOnGoing = true
        
        // check and unload old data
        self.showFullDescription = false
        //        self.buttonClose.isHidden = false
//        self.viewVideoControls.isHidden = true
        self.updateSubtitlesPosition()
        
        if let oldVideo = self.curVideo {
            self.saveCurrentVideoProgress()
            oldVideo.cancelLoadFullVideo()
        }
        self.adsLoader?.delegate = nil
        self.adsLoader = nil
        if (self.adsManager != nil) {
            self.adsManager?.destroy()
            self.adsManager = nil
        }
        
        if let contentPlayer = self.contentPlayer {
            self.removeObservers(contentPlayer)
            contentPlayer.pause()
            contentPlayer.replaceCurrentItem(with: nil)
        }
        self.contentPlayer = nil
        self.iCurElapsedSeconds = 0
        self.isFirstFramePlayed = false
        self.bVideoQuartilesWatched = [false, false, false]
        self.isVideoContentCompletePlaying = false

        
        //        self.showProgressVideoView()
        self.curVideo = curVideo
        curVideo.resetAdPlayedData() // reseting ad played data

        // if it is Teaser trailer video, play it directly.
        /*if curVideo.isTeaserTrailer {
            self.isVideoSetupOnGoing = false
            self.checkStatusAndPlayCurrentVideo(curVideo: curVideo)
        } else {*/
            if self.shouldSkipLoadingFullVideo {
                self.checkStatusAndPlayCurrentVideo(curVideo: curVideo)
            } else {
                curVideo.loadFullVideo({ (dictVideo) in
                    if curVideo.isGeoblocked {
                        self.labelSubtitles.isHidden = false
                        self.labelSubtitles.text = "This content is geoblocked in your region."
                        self.isVideoSetupOnGoing = false
                        self.showAlertWithMessage(message: "This content is geoblocked in your region.")
                        return
                    }
                    if let progressPoint = curVideo.progressPoint, !curVideo.isLiveStreaming {
                        if (progressPoint > 30 && (curVideo.iDuration == 0 || ((curVideo.iDuration - progressPoint) > 30))) {
                            let alert = UIAlertController(title: curVideo.strTitle, message: nil, preferredStyle: UIAlertController.Style.alert)
                            alert.addAction(UIAlertAction(title: "Resume from \(curVideo.strProgressDuration)", style: .default, handler: { action in
                                self.iCurVideoProgressPoint = progressPoint
                                self.checkStatusAndPlayCurrentVideo(curVideo: curVideo)
                            }))
                            alert.addAction(UIAlertAction(title: "Play from beginning", style: .default, handler: { action in
                                self.checkStatusAndPlayCurrentVideo(curVideo: curVideo)
                            }))
                            self.present(alert, animated: true, completion: nil)
                            return
                        }
                    }
                    self.checkStatusAndPlayCurrentVideo(curVideo: curVideo)
                }) { (error) in
                    //print("3: called after receiving video error")
                }
            }
        //}
    }
    
    func showAlertWithMessage(message:String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default) { (action:UIAlertAction!) in
        })
        self.present(alertController, animated: true)
    }
  
    func checkStatusAndPlayCurrentVideo(curVideo: SPLTVideo) {
        if curVideo.videoAccess ==  SPLTVideoAccessType.videoPaywall {
                SPLTInAppPurchaseUtility.shared.checkAndPurchaseVideoFromItunes(spltVideo: self.curVideo, fromViewController: self) { (success) in
                    if success == true {
                        if let curVideo = self.curVideo {
                            self.playCurrentVideo(curVideo: curVideo)
                        }
                    } else {
                        //error case if some thing is happen at server end
                        self.isVideoSetupOnGoing = false
                    }
                }
            return
        } else {
            if let curVideo = self.curVideo {
                self.playCurrentVideo(curVideo: curVideo)
            }
        }
    }
    
    func playCurrentVideo(curVideo: SPLTVideo) {
        // recheck if curVideo is not set to nil, then stop proceeding so video doesn't play in background.
        if self.view.window == nil {
            self.isVideoSetupOnGoing = false
            return
        }
        
        // check geoblock issue and show message on subtitles label.
        //            if curVideo.isGeoblocked {
        //                self.labelSubtitles.isHidden = false
        //                self.labelSubtitles.text = "This content is geoblocked in your region."
        //                self.isVideoSetupOnGoing = false
        //                return
        //            }
        
        // Check For Live Streaming...
        if curVideo.isLiveStreaming {
            self.labelVideoLiveStreaming.isHidden = false
            self.labelVideoProgress.isHidden = true
            self.sliderVideo.isHidden = true
            self.labelVideoDuration.isHidden = true
            self.buttonCloseCaption.isHidden = true
            
        } else {
            self.labelVideoLiveStreaming.isHidden = true
            self.labelVideoProgress.isHidden = false
            self.sliderVideo.isHidden = false
            self.labelVideoDuration.isHidden = false
            self.buttonCloseCaption.isHidden = false
        }
        
        if curVideo.haveServerSideAds {
            self.bAdsEnabled = false
        }
        
        
        self.labelSubtitles.isHidden = true
        
        self.initializeAnalyticsForCurVideo()
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_event, video: self.curVideo)
        self.setUpContentPlayer(curVideo: curVideo)
        
        if self.shouldAutoRotateToLandscape {
            let value = UIInterfaceOrientation.landscapeRight.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        
//        #if SKIP_ADS
        /*if curVideo.isTeaserTrailer {
            self.isVideoSetupOnGoing = false
            self.contentPlayer?.play()
            self.startHideControlsTimer()
        } else {*/
//        #else
            if self.bAdsEnabled {
                self.setUpAdsLoader()
                self.requestAds(curVideo: curVideo)
                self.startHideControlsTimer()
            } else {
                self.isVideoSetupOnGoing = false
                self.contentPlayer?.play()
                self.startHideControlsTimer()
            }
        //}
//        #endif
        self.setupCastData()
        
        self.setVideoWaterMark(curVideo: curVideo)        
    }
    
    func setVideoWaterMark(curVideo: SPLTVideo) {
        //        self.imageViewVideoWaterMark.superview?.bringSubview(toFront: self.imageViewVideoWaterMark)
        if curVideo.isVideoWaterMarkingEnabled {
            self.imageViewVideoWaterMark.isHidden = false
            if let strVideoWaterMarkId = curVideo.strVideoWaterMarkId {
                if let fWaterMarkOpacity = curVideo.fWaterMarkOpacity {
                    self.imageViewVideoWaterMark.alpha = fWaterMarkOpacity
                }
                let strFullVideoWaterMarkPath = SPLTFullPathRouter.imageFullPath(strVideoWaterMarkId).URLString
                if let url = URL(string: strFullVideoWaterMarkPath) {
//                    self.imageViewVideoWaterMark.splt_setImageFromURL(url, placeholder: nil)
                    self.imageViewVideoWaterMark.splt_setImageFromURL(url)
                } else {
                    self.imageViewVideoWaterMark.image = nil
                }
            } else {
                //self.imageViewVideoWaterMark.image = nil
            }
        } else {
            self.imageViewVideoWaterMark.isHidden = true
        }
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
    
    // Updates progress bar for provided time and duration.
    var iCurElapsedSeconds: Int = 0
    var bVideoQuartilesWatched: [Bool] = [false, false, false]
    func updateWithVideoElapsedSeconds(_ iSeconds: Int, iDuration: Int) {
        //        if self.isAdPlayback {
        //            return
        //        }
        for (index, bVideoQuartileWatched) in bVideoQuartilesWatched.enumerated() {
            if !bVideoQuartileWatched {
                let iQuartileVideoPoint = ((index + 1) * iDuration / 4 )
                if iSeconds > iQuartileVideoPoint {
                    // Crossed quartile.
                    self.bVideoQuartilesWatched[index] = true
                    print("quartile crossed : \(index)")
                    switch index {
                    case 0:
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_quartile_1, video: self.curVideo)
                        self.addAnalyticsEvent(.playback, analyticsEventType: .first_quartile)
                        break
                    case 1:
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_quartile_2, video: self.curVideo)
                        self.addAnalyticsEvent(.playback, analyticsEventType: .second_quartile)
                        break
                    case 2:
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_quartile_3, video: self.curVideo)
                        self.addAnalyticsEvent(.playback, analyticsEventType: .third_quartile)
                        break
                    default: break
                    }
                } else {
                    // break loop as if elapsed seconds didn't cross 1st quartile, no need to check 2nd & 3rd.
                    break
                }
            }
        }
        
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
            self.addAnalyticsEvent(.playback, analyticsEventType: .first_frame)
            SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_first_frame, video: self.curVideo)
            self.isFirstFramePlayed = true
        }
        if let iDuration = self.getSecondsFromTime(time: duration) {
            self.updateWithVideoElapsedSeconds(self.iCurElapsedSeconds, iDuration: iDuration)
        }
        
        self.sliderVideo.value = Float(currentTime)
        self.labelVideoProgress.text =
            NSString(format: "%d:%02d", Int(currentTime / 60), Int(currentTime.truncatingRemainder(dividingBy: 60))) as String
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
        self.sliderVideo.maximumValue = Float(durationValue)
        self.labelVideoDuration.text =
            NSString(format: "%d:%02d", Int(durationValue / 60), Int(durationValue.truncatingRemainder(dividingBy: 60))) as String
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
    
    func resetVideoPlaybackToZero() {
        self.contentPlayer?.seek(to: CMTime.zero)
        self.viewVideoControls.isHidden = false
        self.updateSubtitlesPosition()
        self.viewVideoControlsTop.alpha = 0.9
        self.buttonPlayPause.alpha = 0.9
        self.viewVideoControlsBottom.alpha = 0.9
        self.checkAndHideVideoControls()
    }
    
    
    
    
    //MARK: - Add/Remove Player Observers
    var periodicTimeObserver: Any?
    var isObserversAdded: Bool = false
    var isNotificationAVPlayerItemDidPlayToEndTimeAdded: Bool = false
    func addObservers(_ contentPlayer: AVPlayer) {
        self.periodicTimeObserver = contentPlayer.addPeriodicTimeObserver(
            forInterval: CMTimeMake(value: 1, timescale: 30), //CMTimeMake(1, 1), //CMTimeMake(1, 30),
            queue: nil,
            using: {(time: CMTime) -> Void in
                if (self.contentPlayer != nil) {
                    let duration = self.getPlayerItemDuration(self.contentPlayer!.currentItem!)
                    self.updatePlayheadWithTime(time, duration: duration)
                }
        })
        contentPlayer.addObserver(
            self,
            forKeyPath: "rate",
            options: NSKeyValueObservingOptions.new,
            context: &contentRateContext)
        contentPlayer.addObserver(
            self,
            forKeyPath: "currentItem.duration",
            options: NSKeyValueObservingOptions.new,
            context: &contentDurationContext)
        contentPlayer.addObserver(
            self,
            forKeyPath: "status",
            options: NSKeyValueObservingOptions.new,
            context: &statusContext)
        self.isObserversAdded = true
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.contentDidFinishPlaying(_:)),
            name: Notification.Name.AVPlayerItemDidPlayToEndTime,
            object: contentPlayer.currentItem);
        self.isNotificationAVPlayerItemDidPlayToEndTimeAdded = true
        
    }
    func removeObservers(_ contentPlayer: AVPlayer) {
        if let periodicTimeObserver = self.periodicTimeObserver {
            contentPlayer.removeTimeObserver(periodicTimeObserver)
            self.periodicTimeObserver = nil
        }
        if self.isObserversAdded {
            contentPlayer.removeObserver(self, forKeyPath: "rate")
            contentPlayer.removeObserver(self, forKeyPath: "currentItem.duration")
            contentPlayer.removeObserver(self, forKeyPath: "status")
            self.isObserversAdded = false
        }
        if self.isNotificationAVPlayerItemDidPlayToEndTimeAdded {
            NotificationCenter.default.removeObserver(self, name: Notification.Name.AVPlayerItemDidPlayToEndTime, object: contentPlayer.currentItem)
            self.isNotificationAVPlayerItemDidPlayToEndTimeAdded = false
        }
    }
    
    //MARK: - Loading UI Helper Methods
    func updateSubtitlesPosition() {
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            if self.viewVideoControls.isHidden {
//                self.constraintLabelSubtitlesBottom.constant = 20.0
//            } else {
//                self.constraintLabelSubtitlesBottom.constant = self.viewVideoControlsBottom.frame.height + 20.0
//            }
//        } else {
//            if self.viewVideoControls.isHidden {
//                self.constraintLabelSubtitlesBottom.constant = 10.0
//            } else {
//                self.constraintLabelSubtitlesBottom.constant = self.viewVideoControlsBottom.frame.height + 10.0
//            }
//        }
    }
    
    //MARK: - Loading UI Progress Helper Methods
    //    var progressHUDVideoView: MBProgressHUD?
    //    func showProgressVideoView() {
    //        self.progressHUDVideoView?.hide(animated: true)
    //        if (self.progressHUDVideoView == nil) {
    //            self.progressHUDVideoView = MBProgressHUD(view: self.viewVideoControlWithAd)
    //            self.progressHUDVideoView?.backgroundView.style = .solidColor
    //            self.viewVideoControlWithAd.addSubview(self.progressHUDVideoView!)
    //        }
    //        //        self.progressHUD.labelText = "Updating Profile..."
    ////        self.progressHUDVideoView?.dimBackground = false
    //        self.progressHUDVideoView?.show(animated: true)
    //    }
    //    func hideProgressVideoView() {
    //        self.progressHUDVideoView?.hide(animated: true)
    //    }
    
    
    //MARK: -  Handle Rotation
    func viewDidEnterLandscape() {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.isFullscreen = true
        //self.setFrameForLandscapeMode()
    }
    func setFrameForLandscapeMode() {
        let screenRect = UIScreen.main.bounds
        //        let rectViewVideoFrame = CGRect(x: 0, y: 0, width: screenRect.height, height: screenRect.width)
        self.viewVideoControlsTop.gradientLayer?.frame = self.viewVideoControlsTop.bounds
        self.viewVideoControlsBottom.gradientLayer?.frame = self.viewVideoControlsBottom.bounds
        self.playerLayer?.frame = self.viewVideo.layer.bounds
    }
    
    func viewDidEnterPortrait() {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.isFullscreen = false
    }
    func setFrameForPortraitMode() {
        //        if let rectViewVideoFrame = self.viewVideoFrame {
        self.viewVideoControlsTop.gradientLayer?.frame = self.viewVideoControlsTop.bounds
        self.viewVideoControlsBottom.gradientLayer?.frame = self.viewVideoControlsBottom.bounds
        self.playerLayer?.frame = self.viewVideo.layer.bounds
        //        }
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
                        self.viewVideoControls.isHidden = false
                        self.checkAndHideVideoControls()
                        self.updateSubtitlesPosition()
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_player_ready, video: self.curVideo)
                        self.addAnalyticsEvent(.player_setup, analyticsEventType: .player_setup_ready)
                    }
                    
                default: break
                    
                }
            }
        }
        
        
        
        
        
        
    }
    
    
    //MARK: - IBAction methods
    
    @IBAction func onClickCloseButton(_ sender: Any) {
        //self.closeViewController()
        // This method will be overridden
    }
    @IBAction func onClickCastButton(_ sender: Any) {
        //self.castVideo()
        // This method will be overridden
    }
    @IBAction func onClickCastButtonFromCastViewToDisconnect(_ sender: Any) {
        self.stopCasting()
    }
    @IBAction func onClickShareButton(_ sender: UIButton) {
        //self.shareButtonTapped(sender: sender)
        // This method will be overridden
    }

    @IBAction func onClickCloseCaption(_ sender: Any) {
        self.buttonCloseCaption.isSelected = !self.buttonCloseCaption.isSelected
        if self.buttonCloseCaption.isSelected {
            self.showCloseCaption = true
        } else {
            self.showCloseCaption = false
        }
    }
    
    @IBAction func onFullScreenClicked(_ sender: AnyObject) {
        let size = UIScreen.main.bounds
        if size.width > size.height {
            self.isFullscreen = false
            let value = UIInterfaceOrientation.portrait.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        } else {
            self.isFullscreen = true
            
            let value = self.defaultLandscapeOrientation.rawValue //UIInterfaceOrientation.landscapeLeft.rawValue
            UIDevice.current.setValue(value, forKey: "orientation")
        }
        self.addAnalyticsEvent(.player_setup, analyticsEventType: .player_setup_resize)
    }
    
    // Handle clicks on play/pause button.
    @IBAction func onPlayPauseClicked(_ sender: AnyObject) {
        if (!self.isAdPlayback) {
            if (self.contentPlayer?.rate == 0) {
                self.playContent()
            } else {
                self.pauseContent()
            }
        } else {
            if (self.buttonPlayPause.tag == SPLTVideoPlayButtonType.playButton.rawValue) {
                self.resumeAd()
            } else {
                self.pauseAd()
            }
        }
    }
    open func isContentPlaying() -> Bool {
        if (!self.isAdPlayback) {
            if (self.contentPlayer?.rate == 0) {
                return false
            } else {
                return true
            }
        } else {
            if (self.buttonPlayPause.tag == SPLTVideoPlayButtonType.playButton.rawValue) {
                return false
            } else {
                return true
            }
        }
    }
    open func play() {
        if (self.isAdPlayback) {
            self.resumeAd()
        } else {
            self.playContent()
        }
    }
    open func pause() {
        if (self.isAdPlayback) {
            self.pauseAd()
        } else {
            self.pauseContent()
        }
    }
    open func stop() {
        if let oldVideo = self.curVideo {
            self.saveCurrentVideoProgress()
            oldVideo.cancelLoadFullVideo()
        }
        self.adsLoader?.delegate = nil
        self.adsLoader = nil
        if (self.adsManager != nil) {
            self.adsManager?.destroy()
            self.adsManager = nil
        }
        
        if let contentPlayer = self.contentPlayer {
            self.removeObservers(contentPlayer)
            contentPlayer.pause()
            contentPlayer.replaceCurrentItem(with: nil)
        }
        self.contentPlayer = nil
    }
    open func playContent() {
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_event, video: self.curVideo)
        self.addAnalyticsEvent(.playback, analyticsEventType: .play)
        self.contentPlayer?.play()
        // Hide controls timer when played again.
        self.startHideControlsTimer()
    }
    open func pauseContent() {
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.pause_event, video: self.curVideo)
        self.addAnalyticsEvent(.playback, analyticsEventType: .pause)
        self.contentPlayer?.pause()
        // don't hide controls when paused.
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(SPLTVideoViewController.hideFullscreenControls),
            object: self)
    }
//    open func stopContent() {
//
//    }
    open func resumeAd() {
        self.adsManager?.resume()
        setPlayButtonType(SPLTVideoPlayButtonType.pauseButton)
    }
    open func pauseAd() {
        self.adsManager?.pause()
        setPlayButtonType(SPLTVideoPlayButtonType.playButton)
    }
//    open func stopAd() {
//    }
    
    // Updates play button for provided playback state.
    func updatePlayheadState(_ isPlaying: Bool) {
        setPlayButtonType(isPlaying ? SPLTVideoPlayButtonType.pauseButton : SPLTVideoPlayButtonType.playButton)
    }
    
    // Sets play button type.
    func setPlayButtonType(_ buttonType: SPLTVideoPlayButtonType) {
        print(buttonType.rawValue)
        self.buttonPlayPause.tag = buttonType.rawValue
        if self.buttonPlayPause.tag == SPLTVideoPlayButtonType.playButton.rawValue {
            self.buttonPlayPause.setImage(self.imageButtonPlay, for: .normal)
        } else {
            self.buttonPlayPause.setImage(self.imageButtonPause, for: .normal)
        }
    }
    
    // Called when the user seeks.
    @IBAction func playheadValueChanged(_ sender: AnyObject) {
        if (!(sender is UISlider)) {
            return
        }
        if (!self.isAdPlayback) {
            let slider = sender as! UISlider
            let seek_end_time = Int(slider.value)
            let position_before_seeking = self.iCurElapsedSeconds
            //            self.addAnalyticsEvent(.playback, analyticsEventType: .seek, position_end: seek_end_time)
            //contentPlayer!.seek(to: CMTimeMake(Int64(slider.value), 1))
            self.contentPlayer?.seek(to: CMTimeMake(value: Int64(slider.value), timescale: 1), completionHandler: { (bValue) in
                // Seeked to position
                print("seek success/false  -> \(bValue)") //
                if bValue == true {
                    // last seek which was success, all other canceled out.
                    SPLTAnalyticsUtility.sharedInstance.trackSeekEventWith(.seek, video: self.curVideo, position: position_before_seeking, position_end: seek_end_time)
                    SPLTAnalyticsUtility.sharedInstance.trackSeekEventWith(.resume_after_seek, video: self.curVideo, position: seek_end_time, position_end: nil)
                    self.addAnalyticsEvent(.playback, analyticsEventType: .seek, position: position_before_seeking, position_end: seek_end_time)
                    self.addAnalyticsEvent(.playback, analyticsEventType: .resume_after_seek, position: seek_end_time, position_end: nil)
                }
            })
        }
    }
    
    @IBAction func videoControlsTouchStarted(_ sender: AnyObject) {
        NSObject.cancelPreviousPerformRequests(
            withTarget: self,
            selector: #selector(SPLTVideoViewController.hideFullscreenControls),
            object: self)
    }
    
    @IBAction func videoControlsTouchEnded(_ sender: AnyObject) {
        startHideControlsTimer()
    }
    
    @objc func showFullscreenControls(_ recognizer: UITapGestureRecognizer?) {
        if !self.isAdPlayback {
            //        if self.isFullscreen {
            self.viewVideoControls.isHidden = false
            self.updateSubtitlesPosition()
            //            self.viewVideoControls.alpha = 0.9
            self.viewVideoControlsTop.alpha = 0.9
            self.buttonPlayPause.alpha = 0.9
            self.viewVideoControlsBottom.alpha = 0.9
            startHideControlsTimer()
        }
    }
    
    func startHideControlsTimer() {
        //        Timer.scheduledTimer(
        //            timeInterval: 3,
        //            target: self,
        //            selector: #selector(SPLTVideoViewController.hideFullscreenControls),
        //            userInfo: nil,
        //            repeats: false)
        self.perform(#selector(SPLTVideoViewController.hideFullscreenControls), with: self, afterDelay: 3)
        self.checkAndHideVideoControls()
        //        NSObject.cancelPreviousPerformRequests(
        //            withTarget: self,
        //            selector: #selector(SPLTVideoViewController.hideFullscreenControls),
        //            object: self)
    }
    
    @objc func hideFullscreenControls() {
        UIView.animate(withDuration: 0.5, animations: {() -> Void in self.viewVideoControlsTop.alpha = 0.0})
        UIView.animate(withDuration: 0.5, animations: {() -> Void in self.buttonPlayPause.alpha = 0.0})
        //UIView.animate(withDuration: 0.5, animations: {() -> Void in self.viewVideoControlsBottom.alpha = 0.0})
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewVideoControlsBottom.alpha = 0.0
        }) { (bValue) in
            self.viewVideoControls.isHidden = true
            self.updateSubtitlesPosition()
        }
        
    }

    
    
    //    @IBAction func onPipButtonClicked(_ sender: AnyObject) {
    //        if (pictureInPictureController!.isPictureInPictureActive) {
    //            pictureInPictureController!.stopPictureInPicture();
    //        } else {
    //            pictureInPictureController!.startPictureInPicture();
    //        }
    //    }
    
    
    
    
}




//MARK: -
//MARK: - extension Google IMA Ads Integration
extension SPLTVideoViewController {
    func setUpContentPlayer(curVideo: SPLTVideo) {
        self.setUpContentPlayerForGoogleIMA(curVideo: curVideo)
    }
    
    func playPostRollAd() -> Bool {
            //                self.playPostRollAdForGoogleIMA()
        return false
    }
    
    @objc func allContentDidFinishPlayingWithAd() {
        
    }
    
    @objc func contentDidFinishPlaying(_ notification: Notification) {
        // Make sure we don't call contentComplete as a result of an ad completing.
        if (notification.object as! AVPlayerItem) == contentPlayer?.currentItem {
            if self.isVideoContentCompletePlaying == false {
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.view_content_ended, video: self.curVideo)
                self.labelVideoProgress.text = self.labelVideoDuration.text
                if (notification.object as! AVPlayerItem) == contentPlayer?.currentItem {
                    self.addAnalyticsEvent(.playback, analyticsEventType: .complete)
                }
                self.isVideoContentCompletePlaying = true
            }
            
            if self.isPostAdAvailable() {
                self.adsLoader?.contentComplete()
                self.allContentDidFinishPlayingWithAd()
            } else {
                self.allContentDidFinishPlayingWithAd()
            }
        }
    }
    
    func setUpAdsLoader() {
        self.setUpAdsLoaderForGoogleIMA()
    }
    
    func getVmapAdTagParameters() -> String? {
        var strAdTagParams: String? = nil
            strAdTagParams = self.getVmapAdTagParametersForGoogleIMA()
        return strAdTagParams
    }
    @objc func getVmapAdTag(curVideo: SPLTVideo) -> String? {
        var strAdTag: String? = nil
        strAdTag = self.getVmapAdTagForGoogleIMA(curVideo: curVideo)
        return strAdTag
    }
    
    func requestAds(curVideo: SPLTVideo) {
        self.requestAdsForGoogleIMA(curVideo: curVideo)
    }
    
}



//MARK: -
//MARK: - extension App Become Active/Deactive scenarios
extension SPLTVideoViewController {
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
        if UIDevice.current.orientation.isLandscape {
            self.setFrameForLandscapeMode()
        } else {
            self.setFrameForPortraitMode()
        }
    }
}


//MARK: -
//MARK: - extension Analytics Event helper method
extension SPLTVideoViewController {
    
    func initializeAnalyticsForCurVideo() {
        if let curVideo = self.curVideo {
            if let strVideoId = curVideo.strId, let strVideoCompanyId = curVideo.strComapnyId {
                let channel_spotlight_company_id = strVideoCompanyId
                SPLTAnalyticsEventsHelper.sharedInstance.initializeWith(nil, pageVideoId: strVideoId, pageVideoCompanyId: strVideoCompanyId, pagePlaylistId: nil, pageCompanyId: channel_spotlight_company_id)
            }
        }
    }
    
    func addAnalyticsEvent(_ analyticsEventCategory :SPLTAnalyticsEventCategory, analyticsEventType: SPLTAnalyticsEventType, position: Int? = nil, position_end: Int? = nil) {
        if let curVideo = self.curVideo {
            var cur_position = self.iCurElapsedSeconds
            if let position_ = position {
                cur_position = position_
            }
            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: analyticsEventCategory, analyticsEventType: analyticsEventType, duration: curVideo.iDuration, position: cur_position, position_end: position_end, message: "width: \(Int(self.viewVideoControlWithAd.frame.width)), height: \(Int(self.viewVideoControlWithAd.frame.height))")
            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
        }
    }
    
    func addAnalyticsResizeEvent(_ newSize: CGSize) {
        let analyticsEventCategory :SPLTAnalyticsEventCategory = SPLTAnalyticsEventCategory.player_setup
        let analyticsEventType: SPLTAnalyticsEventType = SPLTAnalyticsEventType.player_setup_resize
        if let curVideo = self.curVideo {
            let analyticsEvent = SPLTAnalyticsEvent(analyticsEventCategory: analyticsEventCategory, analyticsEventType: analyticsEventType, duration: curVideo.iDuration, position: self.iCurElapsedSeconds, position_end: nil, message: "width: \(Int(newSize.width)), height: \(Int(newSize.height))")
            SPLTAnalyticsEventsHelper.sharedInstance.addEvent(analyticsEvent)
        }
    }
}

//MARK: -
//MARK: - extension save video progress
extension SPLTVideoViewController {
    func saveCurrentVideoProgress() {
        if let currentTime_cmtime = self.contentPlayer?.currentTime(), currentTime_cmtime.isValid {
            let floatCurrentTime = CMTimeGetSeconds(currentTime_cmtime)
            if !floatCurrentTime.isNaN {
                let currentTime: Int = Int(floatCurrentTime)
                if let curVideo = self.curVideo, let strVideoId = curVideo.strId, !curVideo.isLiveStreaming {
//                    if SPLTConfig.bEnableResumePlayback == true {
                        curVideo.progressPoint = currentTime
                        SPLTVideoProgressAPI().setVideoProgress(strVideoId, iVideoDuration: currentTime, completion: { (responseDict) in
                            // success
                            print(responseDict)
                        }, completionError: { (error) in
                            // error
                        })
//                    }
                }
            }
        }
    }
    
    
    //MARK: -
    //MARK: - extension IMAAdsLoaderDelegate methods
    open func adsLoader(_ loader: IMAAdsLoader!, adsLoadedWith adsLoadedData: IMAAdsLoadedData!) {
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_loaded, video: self.curVideo)
        self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_loaded)
        
        // Grab the instance of the IMAAdsManager and set ourselves as the delegate.
        self.adsManager = adsLoadedData.adsManager
        self.adsManager?.delegate = self
        // Create ads rendering settings to tell the SDK to use the in-app browser.
        let adsRenderingSettings = IMAAdsRenderingSettings()
        //            adsRenderingSettings.webOpenerPresentingController = self
        //            adsRenderingSettings.webOpenerDelegate = self
        // Initialize the ads manager.
        self.adsManager?.initialize(with: adsRenderingSettings)
        self.isVideoSetupOnGoing = false
    }
    
    open func adsLoader(_ loader: IMAAdsLoader!, failedWith adErrorData: IMAAdLoadingErrorData!) {
        // Something went wrong loading ads. Log the error and play the content.
        //            logMessage("Error loading ads: \(adErrorData.adError.message)")
        self.isAdPlayback = false
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.ad_error, video: self.curVideo)
        self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_error)
        self.addAnalyticsEvent(.playback, analyticsEventType: .play)
        self.setPlayButtonType(SPLTVideoPlayButtonType.pauseButton)
        self.contentPlayer?.play()
        self.isVideoSetupOnGoing = false
    }
    
    
    //MARK: -
    //MARK: - extension IMAAdsManagerDelegate
    open func adsManager(_ adsManager: IMAAdsManager!, didReceive event: IMAAdEvent!) {
            //            logMessage("AdsManager event \(event.typeString!)")
            switch (event.type) {
            case IMAAdEventType.AD_BREAK_READY:
                break
            case IMAAdEventType.CLICKED:
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.ad_clicked, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_click)
                break
            case IMAAdEventType.SKIPPED:
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.ad_skipped, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_skip)
                break
            case IMAAdEventType.LOADED:
                //                if (pictureInPictureController == nil ||
                //                    !pictureInPictureController!.isPictureInPictureActive) {
                //                    adsManager.start()
                //                }
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_impression, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_impression)
                self.adsManager?.start()
                break
            case IMAAdEventType.PAUSE:
                self.setPlayButtonType(SPLTVideoPlayButtonType.playButton)
                break
            case IMAAdEventType.RESUME:
                self.setPlayButtonType(SPLTVideoPlayButtonType.pauseButton)
                break
            case IMAAdEventType.STARTED:
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_started, video: self.curVideo)
                break
            case IMAAdEventType.COMPLETE:
                SPLTAnalyticsUtility.sharedInstance.trackEventWith(.setup_ad_complete, video: self.curVideo)
                self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_complete)
                break
            case IMAAdEventType.TAPPED:
                //                showFullscreenControls(nil)
                break
            default:
                break
            }
        }
        
        open func adsManager(_ adsManager: IMAAdsManager!, didReceive error: IMAAdError!) {
            // Something went wrong with the ads manager after ads were loaded. Log the error and play the
            // content.
            //            logMessage("AdsManager error: \(error.message)")
            self.isAdPlayback = false
            self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_error)
            
            if self.isVideoContentCompletePlaying {
                self.allContentDidFinishPlayingWithAd()
            } else {
//                self.addAnalyticsEvent(.playback, analyticsEventType: .play)
                self.setPlayButtonType(SPLTVideoPlayButtonType.pauseButton)
                self.contentPlayer?.play()
            }
        }
        
        open func adsManagerDidRequestContentPause(_ adsManager: IMAAdsManager!) {
            // The SDK is going to play ads, so pause the content.
            self.isAdPlayback = true
            //            self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_impression)
            self.hideFullscreenControls()
            self.setPlayButtonType(SPLTVideoPlayButtonType.pauseButton)
            self.contentPlayer?.pause()
            //            self.buttonClose.isHidden = true
        }
        
        open func adsManagerDidRequestContentResume(_ adsManager: IMAAdsManager!) {
            // The SDK is done playing ads (at least for now), so resume the content.
            self.isAdPlayback = false
            //            self.addAnalyticsEvent(.advertising, analyticsEventType: .ad_complete)
            self.showFullscreenControls(nil)
            if self.isVideoContentCompletePlaying {
                self.allContentDidFinishPlayingWithAd()
            } else {
                self.setPlayButtonType(SPLTVideoPlayButtonType.playButton)
//                self.addAnalyticsEvent(.playback, analyticsEventType: .play)
                self.contentPlayer?.play()
                //            self.buttonClose.isHidden = false
            }
        }

}

////MARK: -
////MARK: - UIGestureRecognizerDelegate methods
//extension SPLTVideoViewController: UIGestureRecognizerDelegate {
//    
//    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if let iGestureRecognizerViewFrameY = gestureRecognizer.view?.frame.origin.y {
//            if iGestureRecognizerViewFrameY < 0 {
//                return false
//            }
//        }
//        return true
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
//    
//}









