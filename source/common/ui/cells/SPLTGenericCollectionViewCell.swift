//
//  SPLTCategoriesCollectionViewCell.swift
//  DotstudioUI
//
//  Created by Anwer on 5/15/18.
//

import UIKit
//import DotstudioAPI

open class SPLTGenericCollectionViewCell: SPLTBaseCollectionViewCell {
    public enum CellType {
        case none
        case category
        case channel
        case video
    }
    
    open var category: SPLTCategory?
    open var channel: SPLTChannel?
    open var video: SPLTVideo?
    open var cellType: CellType = .none
    @IBInspectable open var imageKey: String = "poster"
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.category = nil
        self.channel = nil
        self.video = nil
    }
    
    open func setCellData(_ category: SPLTCategory, collectionViewImageSize: CGSize) {
        self.cellType = .category
        self.collectionViewImageSize = collectionViewImageSize
        self.category = category
        self.updateUI()
    }
    
    open func setCellChannelData(_ channel: SPLTChannel, collectionViewImageSize: CGSize) {
        self.cellType = .channel
        self.collectionViewImageSize = collectionViewImageSize
        self.channel = channel
        self.updateUI()
    }

    open func setCellVideoData(_ video: SPLTVideo, collectionViewImageSize: CGSize) {
        self.cellType = .video
        self.collectionViewImageSize = collectionViewImageSize
        self.video = video
        self.updateUI()
    }

    open func updateUI(){
        switch self.cellType {
            case .category:
                self.updateCategoriesUI()
                break
            case .channel:
                self.updateChannelUI()
                break
            case .video:
                self.updateVideoUI()
                break
            default:break
        }
    }
    
    func updateCategoriesUI(){
        if let category = self.category {
            if let strTitle = category.strName {
                self.labelPrimaryTitle?.text = strTitle
            }
            
            if self.imageKey == "poster", let strImageUrl = category.poster {
                self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
            } else if self.imageKey == "wallpaper", let strImageUrl = category.wallpaper {
                self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
            } else if let strPosterUrl = category.poster {
                self.imageViewCell?.splt_setImageFromStrImagePath(strPosterUrl, sizeImage: collectionViewImageSize)
            }
            
        }
    }
    
    open func updateChannelUI(){
        if let channel = self.channel {
            if let strTitle = channel.strTitle {
                self.labelPrimaryTitle?.text = strTitle
            }
            
            if self.imageKey == "poster", let strImageUrl = channel.poster {
                self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
            } else if self.imageKey == "spotlight_poster", let strImageUrl = channel.spotlight_poster {
                self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
            } else if let strPosterUrl = channel.poster {
                self.imageViewCell?.splt_setImageFromStrImagePath(strPosterUrl, sizeImage: collectionViewImageSize)
            }
        }
    }
    
    open func updateVideoUI(){
        if let video = self.video {
            if let strTitle = video.strTitle {
                self.labelPrimaryTitle?.text = strTitle
            }
            
            if self.imageKey == "thumb", let strImageUrl = video.thumb {
                self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
            } else if self.imageKey == "poster", let strImageUrl = video.poster {
                self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
            } else if let strThumbUrl = video.thumb {
                self.imageViewCell?.splt_setImageFromStrImagePath(strThumbUrl, sizeImage: collectionViewImageSize)
            }
        }
    }
}




