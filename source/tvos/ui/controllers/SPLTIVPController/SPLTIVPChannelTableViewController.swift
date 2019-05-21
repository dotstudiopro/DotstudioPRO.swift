//
//  SPLTIVPChannelTableViewController.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

public protocol SPLTIVPChannelTableViewControllerDelegate {
    func didCloseSPLTIVPChannelTableViewController()
}

public enum RecommendationType {
    case none
    case video
    case channel
}
open class SPLTIVPChannelTableViewController: SPLTBaseViewController {
    
    open var channel: SPLTChannel?
    open var curVideo: SPLTVideo?
    
    open var recommendationVideos: [SPLTVideo] = []
    open var recommendationChannels: [SPLTChannel] = []
    open var recommendationType: RecommendationType = .none
//    #if USE_MORE_LIKE_THIS_RECOMMENDATION
//    open var recommendationVideos: [SPLTVideo] = []
//    #else
//    open var recommandationDictArray: [[String: AnyObject]] = []
//    #endif
    @IBOutlet open weak var tableView: UITableView?
    
    @IBOutlet open weak var imageViewChannelVideo: UIImageView?
    @IBOutlet open weak var viewChannelDetail: UIView?
    
    @IBOutlet open weak var viewGradient: EZYGradientView?
    @IBOutlet open weak var viewGradientBottom: EZYGradientView?
    @IBOutlet open weak var imageViewGradient: UIImageView?
    
    
    @IBOutlet open weak var viewChannelVIdeoInfo: UIView?
    @IBOutlet open weak var labelTitle: UILabel?
    @IBOutlet open weak var labelDescription: UILabel?
    @IBOutlet open weak  var textViewDescription: UITextView?
    @IBOutlet open weak var labelInfo: UILabel?
    @IBOutlet open weak var imageViewChannelLogo: SPLTBaseImageView?
    
    override open var preferredFocusedView: UIView? {
        return self.tableView
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationController?.isNavigationBarHidden = true
        self.tableView?.mask = nil
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0) //(20, 0, 200, 0) //(50, 0, 200, 0)
        self.tableView?.sectionHeaderHeight = 0.0;
        self.tableView?.sectionFooterHeight = 0.0;
        self.tableView?.clipsToBounds = true
        
        self.labelTitle?.text = ""
        self.labelInfo?.text = ""
        self.labelDescription?.text = ""
        self.textViewDescription?.text = ""
        
        self.startLoadingData()
        
//        self.tableView?.register(UINib(nibName: "DSIVPChannelRecommandedVideosTableViewCell", bundle: nil), forCellReuseIdentifier: "SPLTIVPChannelRecommandedVideosTableViewCell")
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView?.reloadData()
    }
    
    open func updateChannelUI() {
        if let strChannelLogoPath = self.channel?.channel_logo {
            if let imageViewChannelLogo = self.imageViewChannelLogo {
                imageViewChannelLogo.splt_setImageFromStrImagePath(strChannelLogoPath, width: 0, height: Int(imageViewChannelLogo.frame.height))
            }
        }
    }
    
    open func updateUI() {
        if let curVideo = self.curVideo {
            self.labelTitle?.text = curVideo.strTitle
            self.labelInfo?.text = curVideo.strVideoInfo
            self.labelDescription?.text = curVideo.strDescription
            self.textViewDescription?.text = curVideo.strDescription
            if let strImagePath = curVideo.thumb {
                do {
                    let imageFrame = self.imageViewChannelVideo?.frame
                    let url = try SPLTFullPathRouter.imagePath(strImagePath, Int((imageFrame?.width)!), Int((imageFrame?.height)!)).asURL()
                    self.imageViewChannelVideo?.splt_setImageFromURL(url)
                } catch {
                    print("error while seting hnk image")
                }
            }
        }
    }
    
    open func startLoadingData() {
        self.requestChannel()
//        self.loadRecommendationChannels()
    }
    
    open func loadRecommendationChannels() {
        if let channel = self.channel {
            if self.recommendationType == .channel {
                self.setupRecommandationSection(curChannel: channel)
            }
        }
    }
    
    open func requestChannel() {
        if let channel = self.channel {
            self.showProgress()
            channel.loadFullChannel({ (dictChannel) in
                print("channel loaded")
                self.loadRecommendationChannels()
                self.reloadAllData()
                self.tableView?.reloadData()
                self.hideProgress()
            }, completionError: { (error) in
                print(error.debugDescription)
                self.hideProgress()
            })
        }
    }
    
    open func loadChannelVideos() {
        if let channel = self.channel {
            channel.loadChannelVideos({ (bValue) in
                // completion
                self.reloadAllData()
                self.hideProgress()
            }, completionError: { (error) in
                // errror
                self.hideProgress()
            })
        } else {
            self.hideProgress()
        }
    }
    
    
    open func reloadAllData() {
        //self.setupRecommandation()
        if self.channel == nil {
            if let curVideo = self.curVideo {
                self.setCurrentVideo(curVideo: curVideo)
            }
        }
        self.updateChannelUI()
        self.updateUI()
    }
    
    open func reloadAllUI() {
        self.tableView?.reloadData()
    }

//    open func setupRecommandation() {
//        if let spltRecommandedData = SPLTCompanyData.sharedInstance.spltRecommandedData {
//            #if USE_MORE_LIKE_THIS_RECOMMENDATION
//            self.recommendationVideos = spltRecommandedData.recommendationVideos
//            #endif
//        }
//    }
    
    
    
    //MARK:- set Player methods
    open func setCurrentVideo(curVideo: SPLTVideo) {
        self.curVideo = curVideo
        if self.recommendationType == .video {
            self.setupRecommandationSection(curVideo: curVideo)
        }
        self.updateUI()
        self.setVideoImagesForCurVideo()
        //        self.tableView.reloadData()
    }
    
//    open func setupRecommandationSection(curVideo: SPLTVideo) {
//        if let strVideoId = curVideo.strId {
//            #if USE_MORE_LIKE_THIS_RECOMMENDATION
//            if let spltRecommandedData = SPLTCompanyData.sharedInstance.spltRecommandedData {
//                self.recommendationVideos = spltRecommandedData.recommendationVideos
//            }
//            #else
//            SPLTRecommandationAPI().getRecommandationForVideo(strVideoId, completion: { (recommandationDictArray) in
//                // recommandation Dict
//                self.recommandationDictArray = recommandationDictArray
//                self.tableView?.beginUpdates()
//                self.tableView?.deleteSections(IndexSet(integer: 2), with: .automatic)
//                self.tableView?.insertSections(IndexSet(integer: 2), with: .automatic)
//                //                    self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
//                self.tableView?.endUpdates()
//            }, completionError: { (error) in
//                print("Error while loading recommandation for video")
//            })
//            #endif
//        }
//
//    }
    open func setupRecommandationSection(curVideo: SPLTVideo) {
        if let strVideoId = curVideo.strId {
            SPLTRecommandationAPI().getRecommandationForVideo(strVideoId, completion: { (recommandationDictArray) in
                // recommandation Dict
                self.recommendationVideos.removeAll()
                for recommandationDict in recommandationDictArray {
                    if let strType = recommandationDict["_type"] as? String, strType == "video" {
                        if let sourceDict = recommandationDict["_source"] as? [String: Any] {
                            let spltVideo = SPLTVideo(videoDict: sourceDict)
                            if let strId = recommandationDict["_id"] as? String {
                                spltVideo.strId = strId
                                self.recommendationVideos.append(spltVideo)
                            }
                        }
                    }
                }
                self.reloadAllUI()
            }, completionError: { (error) in
                print("Error while loading recommandation for video")
            })
        }
    }
    open func setupRecommandationSection(curChannel: SPLTChannel) {
        if let strChannelId = curChannel.dspro_id {
            SPLTRecommandationAPI().getRecommandationForChannel(strChannelId, completion: { (recommandationDictArray) in
                self.recommendationChannels.removeAll()
                for recommandationDict in recommandationDictArray {
                    if let strType = recommandationDict["_type"] as? String, strType == "channel" {
                        if let sourceDict = recommandationDict["_source"] as? [String: Any] {
                            let spltChannel = SPLTChannel(channelDict: sourceDict)
                            if let strId = recommandationDict["_id"] as? String {
                                spltChannel.strId = strId
                                self.recommendationChannels.append(spltChannel)
                            }
                        }
                    }
                }
                self.reloadAllUI()
            }) { (error) in
                print("Error while loading recommandation for channel")
            }
        }
    }
    
    
    open func showChannelFromRecommendation(_ channel: SPLTChannel) {
        channel.loadPartialChannel({ (channelDict) in
            // success
            self.channel = SPLTChannel.getChannelFromChannelDict(channelDict)
            // success
            //self.tableView?.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self.tableView?.setContentOffset(.zero, animated: true)
            self.startLoadingData()
        }) { (error) in
            // error
        }
        
    }
    
    
    
    // MARK:- rolling thumbs animation
    open func setVideoImagesForCurVideo() {
        self.imageViewChannelVideo?.layer.removeAllAnimations()
        self.animationCount = 0
        self.animationTimer?.invalidate()
        self.animationTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(SPLTIVPChannelTableViewController.animateVideoImagesFromCurrentVideo), userInfo: nil, repeats: true)
        self.animateVideoImagesFromCurrentVideo()
        
    }
    
    
    open var animationCount: Int = 0
    open var curFocusedVideoIndex: Int = 0
    open var animationTimer: Timer?
    
    @objc open func animateVideoImagesFromCurrentVideo() {
        if let curVideo = self.curVideo {
            let totalThumbUrls = curVideo.thumbs.count
            var strImagePath = ""
            if let strThumb = curVideo.thumb {
                strImagePath = strThumb
            }
            
            if (totalThumbUrls > 0) {
                strImagePath = curVideo.thumbs[(self.animationCount % totalThumbUrls)]
            }
            let width = Int((self.imageViewChannelVideo?.frame.width)!)
            let height = Int((self.imageViewChannelVideo?.frame.height)!)
            
            self.animationCount += 1
            
            if let url = URL(string: "\(strImagePath)/\(width)/\(height)"), let imageViewChannelVideo = self.imageViewChannelVideo {
                self.imageViewChannelVideo?.splt_setImageFromURL(url, placeholder: nil, format: nil, failure: { (error) in
                    print("Revry"+error.debugDescription)
                }, success: { (image) in
                    UIView.transition(with: imageViewChannelVideo,
                                      duration:1,
                                      options: UIView.AnimationOptions.transitionCrossDissolve,
                                      animations: {
                                        imageViewChannelVideo.image = image
                    },
                                      completion: nil)

                })
            }
        }
        
    }
    
   open func playVideoOnTVOSVideoViewController(_ video: SPLTVideo) {
/*        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tvosVideoViewController = storyboard.instantiateViewController(withIdentifier: "TVOSPlayerViewController") as? TVOSPlayerViewController else {
            fatalError("Unable to instatiate a TVOSVideoViewController from the storyboard.")
        }
        tvosVideoViewController.delegate = self
        #if USE_PLAY2_ROUTE
        tvosVideoViewController.channel = self.channel
        #endif
        tvosVideoViewController.spltVideo = video
        self.show(tvosVideoViewController, sender: self)*/
    }
}


//MARK: -
//MARK: - extension UITableViewDataSource
extension SPLTIVPChannelTableViewController: UITableViewDataSource {
    
    open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // last pending section here called should be recommendation section.
        return 1 // till related content data is decided.
        //            return 1 // for related content section
    }
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section 2 for recommandation data
        // last pending section here called should be recommendation section.
//        if indexPath.section == 1 {
            if let tvosChannelRecommandedVideosTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SPLTIVPChannelRecommandedVideosTableViewCell") as? SPLTIVPChannelRecommandedVideosTableViewCell {
                tvosChannelRecommandedVideosTableViewCell.delegate = self
                switch self.recommendationType {
                    case .video:
                        tvosChannelRecommandedVideosTableViewCell.setupCellData(self.recommendationVideos)
                    break
                    case .channel:
                        tvosChannelRecommandedVideosTableViewCell.setupCellData(self.recommendationChannels)
                    break
                    default: break
                    
                }
                return tvosChannelRecommandedVideosTableViewCell
            }
//        }
        
        return UITableViewCell()
    }
}

//MARK: -
//MARK: - extension UITableViewDelegate
extension SPLTIVPChannelTableViewController: UITableViewDelegate {
    
}
//MARK: -
//MARK: - extension SPLTIVPChannelPlaylistVideoDetailsTableViewCell
extension SPLTIVPChannelTableViewController: SPLTIVPChannelRecommandedVideosTableViewCellDelegate {
    open func didHighlightRecommandedVideoAtIndex(_ video: SPLTVideo, index: Int) {
        self.setCurrentVideo(curVideo: video)
    }
    open func didSelectRecommandedVideoAtIndex(_ video: SPLTVideo, index: Int) {
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_button_click, video: video)
        self.playVideoOnTVOSVideoViewController(video)
    }
    public func didHighlightRecommandedChannelAtIndex(_ channel: SPLTChannel, index: Int) {
        //self.setCurrentVideo(curVideo: video) // do nothing to setchannel for now.
    }
    public func didSelectRecommandedChannelAtIndex(_ channel: SPLTChannel, index: Int) {
        self.showChannelFromRecommendation(channel)
    }
}

//MARK: -
//MARK: - extension SPLTIVPVideoViewControllerDelegate methods
extension SPLTIVPChannelTableViewController: SPLTIVPVideoViewControllerDelegate {
    open func didSelectVideo(_ video: SPLTVideo) {
    }
    
    /*open func didFinishPlayingVideo(_ tvosVideoViewController: SPLTIVPVideoViewController) {
        
    }*/
}

//MARK: -
//MARK: - extension SPLTIVPPlayerViewControllerDelegate methods
extension SPLTIVPChannelTableViewController: SPLTIVPPlayerViewControllerDelegate {
   @objc open func didFinishPlayingVideoOnTVOSPlayerViewController(_ tvosPlayerViewController: SPLTIVPPlayerViewController) {
        
    }
}
