//
//  SPLTIVPChannelRecommandedVideosTableViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

public protocol SPLTIVPChannelRecommandedVideosTableViewCellDelegate {
    func didHighlightRecommandedVideoAtIndex(_ video: SPLTVideo, index: Int)
    func didSelectRecommandedVideoAtIndex(_ video: SPLTVideo, index: Int)
    func didHighlightRecommandedChannelAtIndex(_ channel: SPLTChannel, index: Int)
    func didSelectRecommandedChannelAtIndex(_ channel: SPLTChannel, index: Int)
}

open class SPLTIVPChannelRecommandedVideosTableViewCell: UITableViewCell {

    open var recommendationVideos: [SPLTVideo] = []
    open var recommendationChannels: [SPLTChannel] = []
    open var recommendationType: RecommendationType = .none

//    open var recommendationVideos: [SPLTVideo] = []
    open var channel: SPLTChannel? {
        didSet {
            self.updateUI()
            self.collectionView?.reloadData()
        }
    }
  
    open var delegate: SPLTIVPChannelRecommandedVideosTableViewCellDelegate?
    
    @IBOutlet open weak var imageViewChannelVideo: UIImageView?
    @IBOutlet open weak var labelTitle: UILabel?
    @IBOutlet open weak var collectionView: UICollectionView?
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        
//        self.collectionView?.register(UINib(nibName: "DSIVPChannelRecommandedVideoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "SPLTIVPChannelRecommandedVideoCollectionViewCell")
    }
    
    open func setupCellData(_ recommendationVideos: [SPLTVideo]) {
        self.recommendationType = .video
        self.recommendationVideos = recommendationVideos
        self.updateUI()
        self.collectionView?.reloadData()
    }
    open func setupCellData(_ recommendationChannels: [SPLTChannel]) {
        self.recommendationType = .channel
        self.recommendationChannels = recommendationChannels
        self.updateUI()
        self.collectionView?.reloadData()
    }
    
    open func reloadData() {
        self.collectionView?.reloadData()
    }
    
    open func updateUI() {
        if let channel = self.channel {
            self.labelTitle?.text = channel.strTitle
        }
    }
}

//MARK: -
//MARK: - extension UICollectionViewDataSource
extension SPLTIVPChannelRecommandedVideosTableViewCell: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.recommendationType {
            case .video:
                return self.recommendationVideos.count
            case .channel:
                return self.recommendationChannels.count
            case .none:
                return 0
        }
//        return self.recommendationVideos.count
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let tvosChannelRecommandedVideoCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPLTIVPChannelRecommandedVideoCollectionViewCell", for: indexPath) as? SPLTIVPChannelRecommandedVideoCollectionViewCell {
            switch self.recommendationType {
            case .video:
                if indexPath.row < self.recommendationVideos.count {
                    let recommendationVideo = self.recommendationVideos[indexPath.row]
                    tvosChannelRecommandedVideoCollectionViewCell.setupCellData(recommendationVideo)
                }
                break
            case .channel:
                if indexPath.row < self.recommendationChannels.count {
                    let recommendationChannel = self.recommendationChannels[indexPath.row]
                    tvosChannelRecommandedVideoCollectionViewCell.setupCellData(recommendationChannel)
                }
                break
            default: break
            }
            //        let recommendationVideo = self.recommendationVideos[indexPath.row]
            return tvosChannelRecommandedVideoCollectionViewCell
        }
        return UICollectionViewCell()
    }
}

//MARK: -
//MARK: - extension UICollectionViewDelegate
extension SPLTIVPChannelRecommandedVideosTableViewCell: UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if let currentFocusedIndexPath = context.nextFocusedIndexPath {
            switch self.recommendationType {
            case .video:
                if currentFocusedIndexPath.row < self.recommendationVideos.count {
                    let video = self.recommendationVideos[currentFocusedIndexPath.row]
                    self.delegate?.didHighlightRecommandedVideoAtIndex(video, index: currentFocusedIndexPath.row)
                }
            break
            case .channel:
                if currentFocusedIndexPath.row < self.recommendationChannels.count {
                    let channel = self.recommendationChannels[currentFocusedIndexPath.row]
                    self.delegate?.didHighlightRecommandedChannelAtIndex(channel, index: currentFocusedIndexPath.row)
                }
            break
            default: break
            }
        }
    }
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch self.recommendationType {
        case .video:
            if indexPath.row < self.recommendationVideos.count {
                let video = self.recommendationVideos[indexPath.row]
                self.delegate?.didSelectRecommandedVideoAtIndex(video, index: indexPath.row)
            }
        break
        case .channel:
            if indexPath.row < self.recommendationChannels.count {
                let channel = self.recommendationChannels[indexPath.row]
                self.delegate?.didSelectRecommandedChannelAtIndex(channel, index: indexPath.row)
            }
        break
        default: break
        }
    }
}
