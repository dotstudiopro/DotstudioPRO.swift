//
//  SPLTIVPVideoChannelViewController.swift
//  DotstudioUI-iOS
//
//  Created by Anwer on 5/17/18.
//

import UIKit
//import DotstudioAPI

open class SPLTIVPVideoChannelViewController: SPLTIVPChannelViewController {

    open var showFullDescription: Bool = false
    open override func viewDidLoad() {
        super.viewDidLoad()

//        self.tableView.estimatedRowHeight = 60.0 // 120.0
//        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override open func reloadAllData() {
        if let spltVideoChannel = self.channel as? SPLTVideoChannel {
            if let video = spltVideoChannel.video {
                //                SPLTAnalyticsUtility.sharedInstance.trackEventWith("Play", action: "AutoPlay", label: video.strId, value: nil)
                self.setCurrentVideo(curVideo: video)
            }
        }
        super.reloadAllData()
    }
    
    


//MARK: -
//MARK: - UICollectionViewDataSource methods
    open override func numberOfSections(in collectionView: UICollectionView) -> Int {
        if self.recommendationType == .none {
            return 2
        } else if self.recommendationType == .channel && self.recommendationChannels.count == 0 {
            return 2
        } else if self.recommendationType == .video && self.recommendationVideos.count == 0 {
            return 2
        }
        return 3
    }
    
    open override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if self.curVideo != nil {
                return 1 // for Video Detail section
            } else {
                return 0
            }
        } else if section == 1 {
            return 0 // for channel episodes list
        }
        return super.collectionView(collectionView, numberOfItemsInSection: section)

    }

    open override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            return UICollectionViewCell()
        }
        return super.collectionView(collectionView, cellForItemAt: indexPath)

    }

//MARK: -
//MARK: - UICollectionViewDelegateFlowLayout methods
//    open override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
//        if section == 0 {
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
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.showFullDescription = !self.showFullDescription
                self.reloadAllUI()
            }
        } else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
}



