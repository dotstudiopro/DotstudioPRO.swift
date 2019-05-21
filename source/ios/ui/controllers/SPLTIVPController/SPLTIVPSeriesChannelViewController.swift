//
//  SPLTIVPSeriesChannelViewController.swift
//  DotstudioUI-iOS
//
//  Created by Anwer on 5/17/18.
//

import UIKit
////import DotstudioAPI

open class SPLTIVPSeriesChannelViewController: SPLTIVPVideoChannelViewController {

   open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    open var isMoreEpisodesListHidden: Bool = false
    open var iCurVideoIndex = 0
    open var autoPlayIndex: Int?
    
    
    open func setCurrentVideo() {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            if (self.iCurVideoIndex < playlistChannel.playlistVideos.count) {
                let curVideo = playlistChannel.playlistVideos[self.iCurVideoIndex]
                self.setCurrentVideo(curVideo: curVideo)
            }
        }
    }
    
    open override func showChannelFromRecommendation(_ channel: SPLTChannel) {
        self.iCurVideoIndex = 0
        self.autoPlayIndex = nil
        self.isMoreEpisodesListHidden = false
        super.showChannelFromRecommendation(channel)
    }
    
    override open func reloadAllData() {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            if let autoPlayIndex = self.autoPlayIndex {
                self.iCurVideoIndex = autoPlayIndex
                self.autoPlayIndex = nil
            } else {
                for (index, playlistVideo) in playlistChannel.playlistVideos.enumerated() {
                    if self.curVideo?.strId == playlistVideo.strId {
                        self.iCurVideoIndex = index
                        break
                    }
                }
            }
            
            if self.iCurVideoIndex < playlistChannel.playlistVideos.count, self.iCurVideoIndex >= 0 {
                self.setCurrentVideo(curVideo: playlistChannel.playlistVideos[self.iCurVideoIndex])
            }
            
/*            for (index, playlistVideo) in playlistChannel.playlistVideos.enumerated() {
                if index == self.iCurVideoIndex {
                    //                    SPLTAnalyticsUtility.sharedInstance.trackEventWith("Play", action: "AutoPlay", label: playlistVideo.strId, value: nil)
                    self.setCurrentVideo(curVideo: playlistVideo)
                }
            }*/
        }
        super.reloadAllData()
    }
    override open func setNextVideo() {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            if ((self.iCurVideoIndex + 1) < playlistChannel.playlistVideos.count) {
//                let prevIndexPath = IndexPath(row: self.iCurVideoIndex, section: 1)
                self.iCurVideoIndex = self.iCurVideoIndex + 1
//                let nextIndexPath = IndexPath(row: self.iCurVideoIndex, section: 1)
//                let videoDetailIndexPath = IndexPath(row: 0, section: 0)
                self.setCurrentVideo()
                self.reloadAllUI()
            }
        } else {
            self.resetVideoPlaybackToZero()
        }
    }
//    override func contentDidFinishPlaying(_ notification: Notification) {
//        super.contentDidFinishPlaying(notification)
//        if self.playPostRollAd() {
//
//        } else {
//            self.setNextVideo()
//        }
//    }
    

    //MARK: -
    //MARK: - UICollectionViewDataSource methods
//    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        if self.recommendationType == .none {
//            return 2
//        }
//        return 3
//    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if let playlistChannel = self.channel as? SPLTPlaylistChannel {
                if !self.isMoreEpisodesListHidden {
                    return playlistChannel.playlistVideos.count
                }
            }
            return 0
        }
        return super.collectionView(collectionView, numberOfItemsInSection: section)
        
    }
    
    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // for channel episodes list
        if indexPath.section == 1 {
            return UICollectionViewCell()
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)
        
    }
    
    //MARK: -
    //MARK: - UICollectionViewDelegateFlowLayout methods
//    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 1 {
//            if let playlistChannel = self.channel as? SPLTPlaylistChannel {
//                if playlistChannel.playlistVideos.count > 0 {
//                    if UIDevice.current.userInterfaceIdiom == .pad {
//                        return CGSize(width: 375.0, height: 80.0)
//                    }
//                    return CGSize(width: 375.0, height: 40.0)
//                }
//            }
//            return CGSize(width: 0.0, height: 0.0)
//        }
//        return super.collectionView(collectionView, layout: collectionViewLayout, referenceSizeForHeaderInSection: section)
//    }
//    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        if indexPath.section == 0 {
//            if #available(iOS 10.0, *) {
//                return UICollectionViewFlowLayoutAutomaticSize
//            } else {
//                // Fallback on earlier versions
//                return CGSize(width: 375.0, height: 100.0)
//            } //120.0
//        }
//        return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
//    }
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let playlistChannel = self.channel as? SPLTPlaylistChannel {
                if (indexPath.row < playlistChannel.playlistVideos.count) {
                    let prevIndexPath = IndexPath(row: self.iCurVideoIndex, section: 1)
                    self.iCurVideoIndex = indexPath.row
                    let nextIndexPath = IndexPath(row: self.iCurVideoIndex, section: 1)
                    let videoDetailIndexPath = IndexPath(row: 0, section: 0)
                    
                    let nextVideoToPlay = playlistChannel.playlistVideos[self.iCurVideoIndex]
                    SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_button_click, video: nextVideoToPlay)
                    
                    self.setCurrentVideo()
                    self.reloadAllUI()
                }
            }
        } else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
}
