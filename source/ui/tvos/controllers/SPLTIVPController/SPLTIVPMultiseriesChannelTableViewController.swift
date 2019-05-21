//
//  SPLTIVPMultiseriesChannelTableViewController.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

open class SPLTIVPMultiseriesChannelTableViewController: SPLTIVPSeriesChannelTableViewController {
    open var iCurChildChannelIndex: Int = 0
    open override func requestChannel() {
        
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            self.showProgress()
            spltMultiLevelChannel.loadPartialChannel({ (dictChannel) in
                spltMultiLevelChannel.mapFromChannelDict(dictChannel)
                self.loadRecommendationChannels()
                self.reloadAllData()
                self.tableView?.reloadData()
                self.hideProgress()
                
            }, completionErrorChannel: { (error) in
                print(error.debugDescription)
                self.hideProgress()
            })
        } else {
            super.requestChannel()
        }
    }
    
    open func updateCurSeason(_ iCurSeasonNo: Int) {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            spltMultiLevelChannel.iCurChildChannelIndex = iCurSeasonNo
            self.tableView?.beginUpdates()
            self.tableView?.reloadSections([1], with: .automatic)
            self.tableView?.endUpdates()
        }
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.tableView?.register(UINib(nibName: "DSIVPChannelPlaylistVideoDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "SPLTIVPChannelPlaylistVideoDetailsTableViewCell")

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
    
    open override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: -
//MARK: - extension UITableViewDataSource
extension SPLTIVPMultiseriesChannelTableViewController {
    open override func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.channel as? SPLTMultiLevelChannel {
            if self.recommendationType == .none {
                return 1
            } else if self.recommendationType == .channel, self.recommendationChannels.count == 0 {
                return 1
            }
            return 2
        }
        return super.numberOfSections(in: tableView)
    }
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // for channel episodes list
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            if section == 0 {
                return spltMultiLevelChannel.childChannels.count
            } else if section == 1 {
                return 1 // for recommendation
            }
            //return 1
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    override open  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // for channel episodes list
        if let _ = self.channel as? SPLTMultiLevelChannel {
            if indexPath.section == 0 {
                if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
                    if let tvosChannelPlaylistVideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SPLTIVPChannelPlaylistVideoDetailsTableViewCell") as? SPLTIVPChannelPlaylistVideoDetailsTableViewCell {
                        tvosChannelPlaylistVideoDetailsTableViewCell.delegate = self
                        if indexPath.row < spltMultiLevelChannel.childChannels.count {
                            let spltPlaylistChannel = spltMultiLevelChannel.childChannels[indexPath.row]
                            tvosChannelPlaylistVideoDetailsTableViewCell.channel = spltPlaylistChannel
                        }
                        return tvosChannelPlaylistVideoDetailsTableViewCell
                    }
                }
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}

//MARK: -
//MARK: - extension TVOSMultiSeriesChannelVideoDetailTableViewCellDelegate
extension SPLTIVPMultiseriesChannelTableViewController {
    open func didHighlightSeasonAtIndex(_ index: Int) {
        
    }
    open func didSelectSeasonAtIndex(_ index: Int) {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            let iCurChildChannelIndex = index
            if iCurChildChannelIndex < spltMultiLevelChannel.childChannels.count {
                let spltChannel = spltMultiLevelChannel.childChannels[iCurChildChannelIndex]
                if spltChannel.isFullChannelLoaded {
                    self.updateCurSeason(iCurChildChannelIndex)
                } else {
                    spltChannel.loadFullChannel({ (channelDict) in
                        self.updateCurSeason(iCurChildChannelIndex)
                    }, completionError: { (error) in
                        // handle error.
                    })
                }
            }
        }
        
    }
}

//MARK: -
//MARK: - extension TVOSChannelPlaylistVideoDetailsTableViewCell
extension SPLTIVPMultiseriesChannelTableViewController {
    
     override open func didSelectVideoAtIndex(_ video: SPLTVideo, index: Int, tvosChannelPlaylistVideoDetailsTableViewCell: SPLTIVPChannelPlaylistVideoDetailsTableViewCell) {
        if let indexPath = self.tableView?.indexPath(for: tvosChannelPlaylistVideoDetailsTableViewCell) {
            self.iCurChildChannelIndex = indexPath.row
            super.didSelectVideoAtIndex(video, index: index, tvosChannelPlaylistVideoDetailsTableViewCell: tvosChannelPlaylistVideoDetailsTableViewCell)
        }
    }
}


//MARK: -
//MARK: - extension TVOSVideoViewControllerDelegate methods
extension SPLTIVPMultiseriesChannelTableViewController {
    override open func didFinishPlayingVideo(_ tvosVideoViewController: SPLTIVPVideoViewController) {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            if self.iCurChildChannelIndex < spltMultiLevelChannel.childChannels.count {
                if let spltPlaylistChannel = spltMultiLevelChannel.childChannels[self.iCurChildChannelIndex] as? SPLTPlaylistChannel {
                    let iNextVideoIndex = self.iCurVideoIndex + 1
                    if iNextVideoIndex < spltPlaylistChannel.playlistVideos.count {
                        self.iCurVideoIndex = iNextVideoIndex
                        let video = spltPlaylistChannel.playlistVideos[self.iCurVideoIndex]
                        self.playVideoOnTVOSVideoViewController(video)
                    }
                }
            }
        } else {
            super.didFinishPlayingVideo(tvosVideoViewController)
        }
    }
    override open func didFinishPlayingVideoOnTVOSPlayerViewController(_ tvosPlayerViewController: SPLTIVPPlayerViewController) {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            if self.iCurChildChannelIndex < spltMultiLevelChannel.childChannels.count {
                if let spltPlaylistChannel = spltMultiLevelChannel.childChannels[self.iCurChildChannelIndex] as? SPLTPlaylistChannel {
                    let iNextVideoIndex = self.iCurVideoIndex + 1
                    if iNextVideoIndex < spltPlaylistChannel.playlistVideos.count {
                        self.iCurVideoIndex = iNextVideoIndex
                        let video = spltPlaylistChannel.playlistVideos[self.iCurVideoIndex]
                        self.playVideoOnTVOSVideoViewController(video)
                    }
                }
            }
        } else {
            super.didFinishPlayingVideoOnTVOSPlayerViewController(tvosPlayerViewController)
        }
    }
    
}

