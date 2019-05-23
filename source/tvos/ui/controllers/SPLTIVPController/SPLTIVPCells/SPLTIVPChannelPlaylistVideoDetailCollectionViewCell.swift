//
//  SPLTIVPChannelPlaylistVideoDetailCollectionViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit


public protocol SPLTIVPChannelPlaylistVideoDetailCollectionViewCellDelegate {
    //func didClickPlayButton(_ sender: AnyObject)
}

open class SPLTIVPChannelPlaylistVideoDetailCollectionViewCell: UICollectionViewCell {
    open var video: SPLTVideo? {
        didSet {
            self.updateUI()
        }
    }
    //var delegate: TVOSChannelVideoDetailTableViewCellDelegate?
    
    @IBOutlet open weak var imageViewChannelVideo: UIImageView?
    @IBOutlet open weak var labelTitle: UILabel?
    @IBOutlet open weak var labelNormalTitle: UILabel?
    @IBOutlet open weak var labelSecondaryTitle: UILabel?
//    @IBOutlet open weak var progressViewVideoProgress: UIProgressView?
    @IBOutlet weak open var baseVideoProgressView: SPLTBaseVideoProgressView?

    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.labelTitle?.text = ""
        self.labelNormalTitle?.text = ""
        self.imageViewChannelVideo?.image = nil
        self.baseVideoProgressView?.clearProgress()
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
//        self.baseVideoProgressView?.clearProgress()
    }
    open func updateUI() {
        if let video = self.video {
            self.labelTitle?.text = video.strTitle
            self.labelNormalTitle?.text = video.strTitle
            self.labelSecondaryTitle?.text = video.strSeriesTitle
            if let strImagePath = video.thumb {
                do {
                    let imageFrame = self.imageViewChannelVideo?.frame
                    let url = try SPLTFullPathRouter.imagePath(strImagePath, Int((imageFrame?.width)!), Int((imageFrame?.height)!)).asURL()
                    self.imageViewChannelVideo?.splt_setImageFromURL(url)
                } catch  {
                    print("error while seting hnk image")
                }
            }
            self.baseVideoProgressView?.setCellVideo(video)
        }
//        self.progressViewVideoProgress?.isHidden = true
//        self.updateVideoProgressUI()
    }
//    open func updateVideoProgressUI() {
//        self.alpha = 1.0
//        if let fVideoProgress = self.video?.videoProgressForProgressView() {
//            self.progressViewVideoProgress?.isHidden = false
//            self.progressViewVideoProgress?.progress = fVideoProgress
//        }
//    }
}
