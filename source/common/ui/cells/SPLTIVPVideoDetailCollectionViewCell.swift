//
//  SPLTIVPVideoDetailTableViewCell.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 21/05/18.
//

import Foundation
import UIKit


open class SPLTIVPVideoDetailCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak open var imageViewCell: SPLTBaseImageView?
    @IBOutlet weak open var labelTitle: UILabel?
    @IBOutlet weak open var labelSeriesTitle: UILabel?
    @IBOutlet weak open var labelInfo: UILabel?
    @IBOutlet weak open var labelDescription: UILabel?
    @IBOutlet weak open var textViewDescription: UITextView?
    @IBOutlet weak open var baseVideoProgressView: SPLTBaseVideoProgressView?

    open var video: SPLTVideo?
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.baseVideoProgressView?.clearProgress()
    }
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.imageViewCell?.image = nil
        self.labelTitle?.text = ""
        self.labelSeriesTitle?.text = ""
        self.labelInfo?.text = ""
        self.labelDescription?.text = ""
        self.textViewDescription?.text = ""
//        self.baseVideoProgressView?.clearProgress()
    }
    
    
    
    open func setCellData(_ video: SPLTVideo) {
        self.video = video
        self.updateUI()
    }
    
    open func updateUI(){
        if let video = self.video {
            if let strThumbUrl = video.thumb {
                if let imageViewCell = self.imageViewCell {
                    let size = CGSize(width: imageViewCell.frame.width, height: imageViewCell.frame.height)
                    imageViewCell.splt_setImageFromStrImagePath(strThumbUrl, sizeImage: size)
                }
            }
            if let strTitle = video.strTitle {
                self.labelTitle?.text = strTitle
            }
            if let strSeriesTitle = video.strSeriesTitle {
                self.labelSeriesTitle?.text = strSeriesTitle
            }
            if let strInfo = video.strVideoInfo {
                self.labelInfo?.text = strInfo
            }
            if let strDescription = video.strDescription {
                self.labelDescription?.text = strDescription
                self.textViewDescription?.text = strDescription
            }
            self.baseVideoProgressView?.setCellVideo(video)
        }
    }
}



