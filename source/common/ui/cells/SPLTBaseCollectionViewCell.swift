//
//  SPLTBaseCollectionViewCell.swift
//  DotstudioUI
//
//  Created by Anwer on 5/16/18.
//

import UIKit

open class SPLTBaseCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak open var imageViewCell: SPLTBaseImageView?
    @IBOutlet weak open var labelPrimaryTitle: UILabel?
    @IBOutlet weak open var labelSecondaryTitle: UILabel?
    
    open var collectionViewImageSize:CGSize = CGSize(width: 320, height: 180)
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        self.imageViewCell?.image = nil
        self.labelPrimaryTitle?.text = ""
        self.labelSecondaryTitle?.text = ""
    }
}
