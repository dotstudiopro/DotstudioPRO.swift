//
//  SPLTHorizontalBaseCollectionViewCell.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 11/05/18.
//

import Foundation
import UIKit



open class SPLTHorizontalBaseCollectionViewCell: UICollectionViewCell  {
    @IBOutlet weak open var imageViewCell: SPLTBaseImageView?
    @IBOutlet weak open var labelPrimaryTitle: UILabel?
    @IBOutlet weak open var labelSecondaryTitle: UILabel?
    @IBOutlet weak open var baseVideoProgressView: SPLTBaseVideoProgressView?
    
    open var collectionViewImageSize:CGSize = CGSize(width: 160, height: 90)
    open var channel: SPLTChannel?
    open var video: SPLTVideo?
    @IBInspectable open var imageKey: String = "poster"

    open override func prepareForReuse() {
        super.prepareForReuse()
        //        self.imageViewCell.image = nil
        self.channel = nil
        self.video = nil
        self.imageViewCell?.image = nil
        self.labelPrimaryTitle?.text = ""
        self.labelSecondaryTitle?.text = ""
//        self.baseVideoProgressView?.clearProgress()
    }
    
    open func setChannel(channel: SPLTChannel, collectionViewImageSize: CGSize) {
        self.channel = channel
        self.collectionViewImageSize = collectionViewImageSize
//        var strImageUrl = "" //"https://f9q4g5j6.ssl.hwcdn.net/5a5816cd97f8156c1988d889"
        
        if self.imageKey == "poster", let strImageUrl = channel.poster {
            self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
        } else if self.imageKey == "spotlight_poster", let strImageUrl = channel.spotlight_poster {
            self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
        } else if let strPosterUrl = channel.poster {
            self.imageViewCell?.splt_setImageFromStrImagePath(strPosterUrl, sizeImage: collectionViewImageSize)
        }
        
        if let strTitle = channel.strTitle {
            self.labelPrimaryTitle?.text = strTitle
        }
        self.labelSecondaryTitle?.text = ""
    }
    open func setVideo(video: SPLTVideo, collectionViewImageSize: CGSize) {
        self.video = video
        self.collectionViewImageSize = collectionViewImageSize
        
        if self.imageKey == "thumb", let strImageUrl = video.thumb {
            self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
        } else if self.imageKey == "wallpaper", let strImageUrl = video.wallpaper {
            self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
        } else if let strPosterUrl = video.thumb {
            self.imageViewCell?.splt_setImageFromStrImagePath(strPosterUrl, sizeImage: collectionViewImageSize)
        }

        if let strTitle = video.strTitle {
            self.labelPrimaryTitle?.text = strTitle
        }
        self.labelSecondaryTitle?.text = ""
        self.baseVideoProgressView?.setCellVideo(video)
    }
    
}





