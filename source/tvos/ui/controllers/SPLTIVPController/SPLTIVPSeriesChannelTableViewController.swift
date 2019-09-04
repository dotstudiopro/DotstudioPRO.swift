//
//  SPLTIVPSeriesChannelTableViewController.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit


open class SPLTIVPSeriesChannelTableViewController: SPLTIVPVideoChannelTableViewController {
   open var autoPlayIndex: Int?
    open var iCurVideoIndex: Int = 0
    
    open override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView?.register(UINib(nibName: "DSIVPChannelPlaylistVideoDetailsTableViewCell", bundle: nil), forCellReuseIdentifier: "SPLTIVPChannelPlaylistVideoDetailsTableViewCell")
    }
    
}

//MARK: -
//MARK: - extension UITableViewDataSource
extension SPLTIVPSeriesChannelTableViewController {
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if let _ = self.channel as? SPLTPlaylistChannel {
            if self.recommendationType == .none {
                return 1
            } else if self.recommendationType == .channel, self.recommendationChannels.count == 0 {
                return 1
            }
            return 2
        }
        return super.numberOfSections(in: tableView)
    }
    
    open func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        if self.autoPlayIndex != nil {
            return IndexPath(row: 0, section: 0)
        }
        return nil
    }
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 350.0
        }
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // for channel episodes list
        if let _ = self.channel as? SPLTPlaylistChannel {
            if section == 0 {
                return 1
            } else if section == 1 {
                return 1 // for recommendation
            }
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // for channel episodes list
        if let _ = self.channel as? SPLTPlaylistChannel {
            if indexPath.section == 0 {
                if let tvosChannelPlaylistVideoDetailsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SPLTIVPChannelPlaylistVideoDetailsTableViewCell") as? SPLTIVPChannelPlaylistVideoDetailsTableViewCell {
                    tvosChannelPlaylistVideoDetailsTableViewCell.delegate = self
                    if let channel = self.channel {
                        tvosChannelPlaylistVideoDetailsTableViewCell.channel = channel
                    }
                    tvosChannelPlaylistVideoDetailsTableViewCell.autoPlayIndex = nil
                    if self.autoPlayIndex != nil {
                        tvosChannelPlaylistVideoDetailsTableViewCell.autoPlayIndex = self.autoPlayIndex
                    }
                    return tvosChannelPlaylistVideoDetailsTableViewCell
                }
            }
        }
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}

//MARK: -
//MARK: - extension UITableViewDelegate
extension SPLTIVPSeriesChannelTableViewController {
    open func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let playlistChannel = self.channel as? SPLTPlaylistChannel {
                if indexPath.row < playlistChannel.playlistVideos.count {
                    let video = playlistChannel.playlistVideos[indexPath.row]
                    self.setCurrentVideo(curVideo: video)
                }
            }
        }
    }
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

//MARK: -
//MARK: - extension TVOSChannelPlaylistVideoDetailsTableViewCell
extension SPLTIVPSeriesChannelTableViewController: SPLTIVPChannelPlaylistVideoDetailsTableViewCellDelegate {
    @objc open func didHighlightVideoAtIndex(_ video: SPLTVideo, index: Int) {
        self.setCurrentVideo(curVideo: video)
    }
    @objc open func didSelectVideoAtIndex(_ video: SPLTVideo, index: Int, tvosChannelPlaylistVideoDetailsTableViewCell: SPLTIVPChannelPlaylistVideoDetailsTableViewCell) {
        self.iCurVideoIndex = index
        
        SPLTAnalyticsUtility.sharedInstance.trackEventWith(.play_button_click, video: video)
        self.playVideoOnTVOSVideoViewController(video)
    }
    @objc open func didLoadedChannelVideosForPlaylistVideoDetailsTableViewCell(_ channel: SPLTChannel) {
//        self.setupRecommandation()
        self.tableView?.reloadData()
    }
}

//MARK: -
//MARK: - extension SPLTIVPVideoViewControllerDelegate methods
extension SPLTIVPSeriesChannelTableViewController {
    @objc open func didFinishPlayingVideo(_ spltVideoViewController: SPLTIVPVideoViewController) {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            let iNextVideoIndex = self.iCurVideoIndex + 1
            if iNextVideoIndex < playlistChannel.playlistVideos.count {
                self.iCurVideoIndex = iNextVideoIndex
                let video = playlistChannel.playlistVideos[self.iCurVideoIndex]
                self.playVideoOnTVOSVideoViewController(video)
            }
        }
    }
    
    open override func didFinishPlayingVideoOnTVOSPlayerViewController(_ dspPlayerViewController: SPLTIVPPlayerViewController) {
        if let playlistChannel = self.channel as? SPLTPlaylistChannel {
            let iNextVideoIndex = self.iCurVideoIndex + 1
            if iNextVideoIndex < playlistChannel.playlistVideos.count {
                self.iCurVideoIndex = iNextVideoIndex
                let video = playlistChannel.playlistVideos[self.iCurVideoIndex]
                self.playVideoOnTVOSVideoViewController(video)
            }
        }
    }
}
