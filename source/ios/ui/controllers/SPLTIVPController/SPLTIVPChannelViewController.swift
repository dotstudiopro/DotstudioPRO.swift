//
//  SPLTIVPChannelViewController.swift
//  DotstudioUI-iOS
//
//  Created by Anwer on 5/17/18.
//

import UIKit


open class SPLTIVPChannelViewController: SPLTIVPVideoViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    public enum RecommendationType {
        case none
        case video
        case channel
    }
    @IBOutlet weak open var collectionView: UICollectionView?
    open var strChannelSlug: String?
    open var channel: SPLTChannel? {
        didSet {
            
        }
    }
    open var curChannel: SPLTChannel?
    open var recommendationVideos: [SPLTVideo] = []
    open var recommendationChannels: [SPLTChannel] = []
    open var recommendationType: RecommendationType = .none

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.startLoadingData()
    }
    
    
    open func startLoadingData() {
        self.requestChannel()
        //self.loadRecommendationChannels()
    }
    open func requestChannel() {
        if let channel = self.channel {
            self.showProgress()
            channel.loadFullChannel({ (dictChannel) in
                print("channel loaded")
                self.loadRecommendationChannels()
                self.reloadAllData()
//                self.collectionView?.reloadData()
                self.hideProgress()
            }, completionError: { (error) in
                print(error.debugDescription)
                self.hideProgress()
            })
        } else if let curVideo = self.curVideo {
            curVideo.loadFullVideo({ (dictVideo) in
                // received full video detail
                self.reloadAllData()
//                self.collectionView?.reloadData()
                self.hideProgress()
            }, completionError: { (error) in
                print("error while loading video")
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
        if self.channel == nil {
            if let curVideo = self.curVideo {
                self.setCurrentVideo(curVideo: curVideo)
            }
        }
        self.reloadAllUI()
    }
    
    open func reloadAllUI() {
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
    }
    
    //MARK:- set Player methods
    override open func setCurrentVideo(curVideo: SPLTVideo) {
        super.setCurrentVideo(curVideo: curVideo)
        if self.recommendationType == .video {
            self.setupRecommandationSection(curVideo: curVideo)
        }
        self.reloadAllUI()
    }
    
    open func loadRecommendationChannels() {
        if let channel = self.channel {
            if self.recommendationType == .channel {
                self.setupRecommandationSection(curChannel: channel)
            }
        }
    }
    
    override open func getVmapAdTag(curVideo: SPLTVideo) -> String? {
        if let channel = self.channel {
            if let strVideoId = curVideo.strId, let strChannelId = channel.strId {
                let screenRect = UIScreen.main.bounds
                var screenWidth = Int(screenRect.width * UIScreen.main.scale)
                var screenHeight = Int(screenRect.height * UIScreen.main.scale)
                if screenRect.height > screenRect.width {
                    screenWidth = Int(screenRect.height * UIScreen.main.scale)
                    screenHeight = Int(screenRect.width * UIScreen.main.scale)
                }
                var adTagUrl = "https://api.myspotlight.tv/vmap/\(strVideoId)/\(screenWidth)/\(screenHeight)/\(strChannelId)"
                if let strVmapAdTagParameters = self.getVmapAdTagParameters() {
                    adTagUrl += "?\(strVmapAdTagParameters)"
                }
                return adTagUrl
                // For Test
                //return "http://dev.api.myspotlight.tv/vmap/57be8615d66da81809a33855/1855/1043/57be8615d66da81809a33855"
            }
        }
        return super.getVmapAdTag(curVideo: curVideo)
    }
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
        self.curVideo = nil
        channel.loadPartialChannel({ (channelDict) in
            // success
            self.channel = SPLTChannel.getChannelFromChannelDict(channelDict)
            // success
            self.collectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            self.startLoadingData()
        }) { (error) in
            // error
        }
        
    }
    
    
//MARK: -
//MARK: - UICollectionViewDataSource methods

//    open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        return UICollectionReusableView()
//    }

    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.recommendationType == .none {
            return 0
        }
        return 1
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 2 {
            switch self.recommendationType {
                case .video:
                    let iTotalCount = Int(self.recommendationVideos.count)
                    return iTotalCount
                case .channel:
                    let iTotalCount = Int(self.recommendationChannels.count)
                    return iTotalCount
                case .none:
                    return 0
            }
        }
        return 0
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
//MARK: -
//MARK: - UICollectionViewDelegateFlowLayout methods
//    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        return CGSize(width: 0.0, height: 0.0)
//    }
//    open func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: 0.0, height: 0.0)
//    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // for Recommendation
        if indexPath.section == 2 {
            if self.recommendationType == .video {
                if indexPath.row < self.recommendationVideos.count {
                    self.channel = nil //is nil becouse it won't show the current epesodes of channels
                    let video = self.recommendationVideos[indexPath.row]
                    self.setCurrentVideo(curVideo: video)
                }
            } else if self.recommendationType == .channel {
                if indexPath.row < self.recommendationChannels.count {
                    let channel = self.recommendationChannels[indexPath.row]
                    self.showChannelFromRecommendation(channel)
                }
            }
        }
    }
    
}





