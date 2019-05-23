//
//  SPLTIVPChannelRecommandedVideoCollectionViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit


public protocol SPLTIVPChannelRecommandedVideoCollectionViewCellDelegate {
    //func didClickPlayButton(_ sender: AnyObject)
}

open class SPLTIVPChannelRecommandedVideoCollectionViewCell: UICollectionViewCell {
//    var video: SPLTVideo? {
//        didSet {
//            self.updateUI()
//        }
//    }
    open var delegate: SPLTIVPChannelRecommandedVideoCollectionViewCellDelegate?
    
    @IBOutlet open weak var imageViewChannelVideo: UIImageView?
    @IBOutlet open weak var labelTitle: UILabel?
    @IBOutlet open weak var labelNormalTitle: UILabel?
    @IBOutlet open weak var labelSecondaryTitle: UILabel?
    
    open var recommendationVideo: SPLTVideo?
    open var recommendationChannel: SPLTChannel?
    open var recommendationType: RecommendationType = .none

    override open func awakeFromNib() {
        super.awakeFromNib()
        self.labelTitle?.text = ""
        self.labelNormalTitle?.text = ""
    }
    
    open func setupCellData(_ recommendationVideo: SPLTVideo) {
        self.recommendationType = .video
        self.recommendationVideo = recommendationVideo
        self.updateUI()
//        self.collectionView?.reloadData()
    }
    open func setupCellData(_ recommendationChannel: SPLTChannel) {
        self.recommendationType = .channel
        self.recommendationChannel = recommendationChannel
        self.updateUI()
//        self.collectionView?.reloadData()
    }
    open func updateUI() {
        switch self.recommendationType {
        case .video:
            return self.updateVideoUI()
        case .channel:
            return self.updateChannelUI()
        default:break
        }
    }
    open func updateChannelUI() {
        if let recommendationChannel = self.recommendationChannel {
            self.labelTitle?.text = recommendationChannel.strTitle
            self.labelNormalTitle?.text = recommendationChannel.strTitle
//            self.labelSecondaryTitle?.text = recommendationChannel.strSeriesTitle
            if let strImagePath = recommendationChannel.poster {
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
    open func updateVideoUI() {
        if let recommendationVideo = self.recommendationVideo {
            self.labelTitle?.text = recommendationVideo.strTitle
            self.labelNormalTitle?.text = recommendationVideo.strTitle
            self.labelSecondaryTitle?.text = recommendationVideo.strSeriesTitle
            if let strImagePath = recommendationVideo.thumb {
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
}
