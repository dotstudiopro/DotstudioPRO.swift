//
//  SPLTIVPMultiSeriesChannelViewController.swift
//  DotstudioUI-iOS
//
//  Created by Anwer on 5/17/18.
//

import UIKit
//import DotstudioAPI

open class SPLTIVPMultiSeriesChannelViewController: SPLTIVPSeriesChannelViewController {

    open var iCurPlayingVideoSeasonIndex = 0

    open override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override open func setCurrentVideo() {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            if let playlistChannel = spltMultiLevelChannel.childChannels[self.iCurPlayingVideoSeasonIndex] as? SPLTPlaylistChannel {
                if (self.iCurVideoIndex < playlistChannel.playlistVideos.count) {
                    let curVideo = playlistChannel.playlistVideos[self.iCurVideoIndex]
                    self.setCurrentVideo(curVideo: curVideo)
                }
            } else if let videoChannel = spltMultiLevelChannel.childChannels[self.iCurPlayingVideoSeasonIndex] as? SPLTVideoChannel {
                if let curVideo = videoChannel.video {
                    self.setCurrentVideo(curVideo: curVideo)
                }
            }
        } else {
            super.setCurrentVideo()
        }
    }
    
    open func isAllowedChannelOnCurPlatform() -> (Bool) {
        var hasPlatformAccess = false
        if let channel = self.channel {
            hasPlatformAccess = channel.hasPlatformAccess
            if !hasPlatformAccess {
                if let strTitle = channel.strTitle {
                    var alertMessage = "This title is not available on this device."
                    var strPlatforms = ""
                    
                    if channel.availablePlatforms.count > 0 {
                        strPlatforms = "\(SPLTUIUtility.shared.getStringPlatformWithChannel(channel: channel))"
                        alertMessage += " You can access this title on \(strPlatforms)."
                    }
                    let alert = UIAlertController(title: strTitle, message: alertMessage, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
                        self.closeIVP()
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        return hasPlatformAccess
    }
    
    open func closeIVP() {}
    
    override open func reloadAllData() {
        super.reloadAllData()
//        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
//            self.viewChannelVCPlaylistHeader.spltMultiLevelChannel = spltMultiLevelChannel
//        }
    }
    
    
    override open func requestChannel() {
        
        if let _ = self.channel as? SPLTCustomPlaylistChannel {
            self.reloadAllData()
            self.reloadAllUI()
        } else if let strChannelSlug = self.strChannelSlug {
            self.showProgress()
            SPLTChannelAPI().getPartialChannel(strChannelSlug, completion: { (channelDict) in
                if let retrieviedChannel = SPLTChannel.getChannelFromChannelDict(channelDict) {
                    self.channel = retrieviedChannel
                    self.loadRecommendationChannels()
                    if let spltMultiLevelChannel = retrieviedChannel as? SPLTMultiLevelChannel {
                        self.requestFullChannelForMultiLevelChannel(spltMultiLevelChannel)
                    } else {
                        super.requestChannel()
                    }
                } else {
                    self.hideProgress()
                }
            }, completionError: { (error) in
                self.hideProgress()
            })
        } else if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            self.showProgress()
            spltMultiLevelChannel.loadPartialChannel({ (dictChannel) in
                spltMultiLevelChannel.mapFromChannelDict(dictChannel)
                self.loadRecommendationChannels()
                self.requestFullChannelForMultiLevelChannel(spltMultiLevelChannel)
            }, completionErrorChannel: { (error) in
                print(error.debugDescription)
                self.hideProgress()
            })
        } else {
            super.requestChannel()
        }
    }
    
    open func requestFullChannelForMultiLevelChannel(_ spltMultiLevelChannel: SPLTMultiLevelChannel) {
        for (index,childChannel) in spltMultiLevelChannel.childChannels.enumerated() {
            childChannel.loadFullChannel({ (dictChildChannel) in
                // loaded child channel.
                if index == 0 {
                    spltMultiLevelChannel.iCurChildChannelIndex = 0
                }
                self.reloadAllData()
                self.reloadAllUI()
                self.hideProgress()
            }, completionError: { (error) in
                // Error while loading child channel
                self.hideProgress()
                self.closeViewController()
            })
            break
        }
    }
    
    open func updateCurSeason(_ iCurSeasonNo: Int) {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            spltMultiLevelChannel.iCurChildChannelIndex = iCurSeasonNo
            //self.reloadAllData()
//            self.tableView.beginUpdates()
//            self.tableView.reloadSections([1], with: .automatic)
//            self.tableView.endUpdates()
            self.reloadAllUI()
//            self.viewChannelVCPlaylistHeader.updateUI()
        }
    }
    
    override open func setNextVideo() {
        if let multiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            //self.iCurVideoSeasonIndex
            if let playlistChannel = multiLevelChannel.childChannels[self.iCurPlayingVideoSeasonIndex] as? SPLTPlaylistChannel {
                if ((self.iCurVideoIndex + 1) < playlistChannel.playlistVideos.count) {
//                    let prevIndexPath = IndexPath(row: self.iCurVideoIndex, section: 1)
                    self.iCurVideoIndex = self.iCurVideoIndex + 1
//                    let nextIndexPath = IndexPath(row: self.iCurVideoIndex, section: 1)
//                    let videoDetailIndexPath = IndexPath(row: 0, section: 0)
                    self.setCurrentVideo()
                    self.reloadAllUI()
                    //                    self.tableView.beginUpdates()
                    //                    self.tableView.reloadRows(at: [videoDetailIndexPath,prevIndexPath,nextIndexPath], with: .automatic)
                    //                    self.tableView.endUpdates()
                }
            }
        } else {
            super.setNextVideo()
        }
    }
    
    
    
    //MARK: -
    //MARK: - UICollectionViewDataSource methods
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
                if !self.isMoreEpisodesListHidden {
                    if spltMultiLevelChannel.iCurChildChannelIndex < spltMultiLevelChannel.childChannels.count {
                        let curChildChannel_ = spltMultiLevelChannel.childChannels[spltMultiLevelChannel.iCurChildChannelIndex]
                        if let curChildChannel = curChildChannel_ as? SPLTPlaylistChannel {
                            return curChildChannel.playlistVideos.count
                        } else if let curChildChannel = curChildChannel_ as? SPLTVideoChannel {
                            return 1 // as it's video channel
                        }
                    }
                }
                return 0
            }
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
    
    open override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
                self.iCurPlayingVideoSeasonIndex = spltMultiLevelChannel.iCurChildChannelIndex
                let curChildChannel = spltMultiLevelChannel.childChannels[self.iCurPlayingVideoSeasonIndex]
                if let playlistChannel = curChildChannel as? SPLTPlaylistChannel {
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
                } else if let videoChannel = curChildChannel as? SPLTVideoChannel {
                    if let nextVideoToPlay = videoChannel.video {
                        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_button_click, video: nextVideoToPlay)
                        self.setCurrentVideo()
                        self.reloadAllUI()
                    }
                }
            } else {
                super.collectionView(collectionView, didSelectItemAt: indexPath)
            }
        } else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}






