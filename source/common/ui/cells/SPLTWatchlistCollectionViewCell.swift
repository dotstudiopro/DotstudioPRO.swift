//
//  SPLTWatchlistCollectionViewCell.swift
//  RevryApp-iOS
//
//  Created by Ketan Sakariya on 05/06/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import Foundation

import UIKit

public protocol SPLTWatchlistCollectionViewCellDelegate {
    func didClickRemoveChannelFromWatchlist(_ spltWatchlistCollectionViewCell: SPLTWatchlistCollectionViewCell)
}
open class SPLTWatchlistCollectionViewCell: SPLTBaseCollectionViewCell {

    open var delegate: SPLTWatchlistCollectionViewCellDelegate?

    @IBOutlet weak open var buttonRemoveWatchlistChannel: UIButton?
    @IBInspectable open var imageKey: String = "poster"
    open var watchlistChannelDict: [String: Any] = [:]

    override open func prepareForReuse() {
        super.prepareForReuse()
        self.imageViewCell?.image = nil
        self.labelPrimaryTitle?.text = ""
        self.labelSecondaryTitle?.text = ""
    }

    open func setWatchlistChannelDict(_ watchlistChannelDict: [String: Any], collectionViewImageSize: CGSize) {
        self.watchlistChannelDict = watchlistChannelDict
        self.collectionViewImageSize = collectionViewImageSize
        self.updateUI()
    }

    open func updateUI() {
        var wlChannelDict = self.watchlistChannelDict
        if let parentChannelDict = self.watchlistChannelDict["parent_channel"] as? [String:Any] {
            wlChannelDict = parentChannelDict
        }
        
        if let strTitle = wlChannelDict["title"] as? String {
            self.labelPrimaryTitle?.text = strTitle
        }
        
        if self.imageKey == "poster", let strImageUrl = wlChannelDict["poster"] as? String {
            self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
        } else if self.imageKey == "spotlight_poster", let strImageUrl = wlChannelDict["spotlight_poster"] as? String {
            self.imageViewCell?.splt_setImageFromStrImagePath(strImageUrl, sizeImage: collectionViewImageSize)
        } else if let strPosterUrl = wlChannelDict["poster"] as? String {
            self.imageViewCell?.splt_setImageFromStrImagePath(strPosterUrl, sizeImage: collectionViewImageSize)
        }
    }
    
    @IBAction open func didClickRemoveFromWatchlistButton(_ sender: Any) {
        self.delegate?.didClickRemoveChannelFromWatchlist(self)
    }
    
}









