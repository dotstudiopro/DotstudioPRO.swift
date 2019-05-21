//
//  SPLTIVPMultiSeriesChannelVideoSeriesSeasonCollectionViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
public protocol SPLTIVPMultiSeriesChannelVideoSeriesSeasonCellDelegate {
    func didHighlightSeasonAtIndex(_ index: Int)
    func didSelectSeasonAtIndex(_ index: Int)
}

open class SPLTIVPMultiSeriesChannelVideoSeriesSeasonCollectionViewCell: UICollectionViewCell {
    open var delegate: SPLTIVPMultiSeriesChannelVideoSeriesSeasonCellDelegate?
    open var iSeasonNo: Int = 0 {
        didSet {
            self.labelSeasonNo.text = "\(iSeasonNo + 1)"
        }
    }
    @IBOutlet open weak var labelSeasonNo: UILabel!
    
    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        super.didUpdateFocus(in: context, with: coordinator)
        if self.isFocused {
//            if let corporateColor = K10Theme.corporateColor {
  //              self.labelSeasonNo.textColor = corporateColor
    //        }
            self.delegate?.didSelectSeasonAtIndex(self.iSeasonNo)
        } else {
      //      if let fontColor = K10Theme.fontColor {
        //        self.labelSeasonNo.textColor = fontColor
          //  }
        }
    }
}
