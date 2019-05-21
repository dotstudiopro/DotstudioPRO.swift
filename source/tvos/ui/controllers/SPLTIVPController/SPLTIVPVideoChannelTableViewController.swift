//
//  SPLTIVPVideoChannelTableViewController.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

open class SPLTIVPVideoChannelTableViewController: SPLTIVPChannelTableViewController {
    override open func reloadAllData() {
        if let spltVideoChannel = self.channel as? SPLTVideoChannel {
            if let video = spltVideoChannel.video {
                //                SPLTAnalyticsUtility.sharedInstance.trackEventWith("Play", action: "AutoPlay", label: video.strId, value: nil)
                self.setCurrentVideo(curVideo: video)
            }
        }
        super.reloadAllData()
    }
}

//MARK: -
//MARK: - extension UITableViewDataSource
extension SPLTIVPVideoChannelTableViewController {
//    override open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.section == 0 {
//            return true
//        }
//        return super.tableView(tableView, canFocusRowAt: indexPath)
//    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        if self.recommendationType == .none {
            return 0
        } else if self.recommendationType == .channel, self.recommendationChannels.count == 0 {
            return 0
        }
        return 1 //2
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return super.tableView(tableView, heightForRowAt: indexPath)
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // for channel episodes list
        if let _ = self.channel as? SPLTVideoChannel {
            if section == 0 {
                return 1 // for recommendation
            }
        }
        return super.tableView(tableView, numberOfRowsInSection: section)
    }
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return super.tableView(tableView, cellForRowAt: indexPath)
    }
}
