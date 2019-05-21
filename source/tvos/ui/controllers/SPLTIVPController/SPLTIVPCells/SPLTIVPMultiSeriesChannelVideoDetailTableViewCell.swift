//
//  SPLTIVPMultiSeriesChannelVideoDetailTableViewCell.swift
//  DotstudioUI-tvOS
//
//  Created by Anwer on 5/30/18.
//

import UIKit
//import DotstudioAPI

public protocol SPLTIVPMultiSeriesChannelVideoDetailTableViewCellDelegate: SPLTIVPSeriesChannelVideoDetailTableViewCellDelegate {
    func didHighlightSeasonAtIndex(_ index: Int)
    func didSelectSeasonAtIndex(_ index: Int)
}

open class SPLTIVPMultiSeriesChannelVideoDetailTableViewCell: SPLTIVPSeriesChannelVideoDetailTableViewCell {

    open var delegate: SPLTIVPMultiSeriesChannelVideoDetailTableViewCellDelegate?
    @IBOutlet open weak var collectionView: UICollectionView?
    
    override open var channel: SPLTChannel? {
        didSet {
            self.updateUI()
            if (self.channel as? SPLTMultiLevelChannel) != nil {
                self.buttonPlay?.isHidden = true
                self.collectionView?.reloadData()
            }
        }
    }
    
    
    private var focusGuide = UIFocusGuide()
    
    var isFocusGuideSetup: Bool = false
    func setupFocusGuide() {
        if self.isFocusGuideSetup {
            return
        }
        self.isFocusGuideSetup = true
        self.focusGuide.preferredFocusedView = self.collectionView
        self.addLayoutGuide(self.focusGuide)
        self.focusGuide.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        self.focusGuide.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.focusGuide.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.focusGuide.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    override func updateUI() {
        super.updateUI()
        self.setupFocusGuide()
    }
    
    //MARK:- IBAction methods
    @IBAction func didClickPlayButton(_ sender: AnyObject) {
        self.delegate?.didClickPlayButton(sender)
    }
}

//MARK: -
//MARK: - extension UICollectionViewDataSource
extension SPLTIVPMultiSeriesChannelVideoDetailTableViewCell: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let spltMultiLevelChannel = self.channel as? SPLTMultiLevelChannel {
            return spltMultiLevelChannel.childChannels.count
        }
        return 0
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tvosMultiSeriesChannelVideoSeriesSeasonCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SPLTIVPMultiSeriesChannelVideoSeriesSeasonCollectionViewCell", for: indexPath) as! SPLTIVPMultiSeriesChannelVideoSeriesSeasonCollectionViewCell
        if (self.channel as? SPLTMultiLevelChannel) != nil {
            tvosMultiSeriesChannelVideoSeriesSeasonCell.iSeasonNo = indexPath.row
        }
        tvosMultiSeriesChannelVideoSeriesSeasonCell.delegate = self
        return tvosMultiSeriesChannelVideoSeriesSeasonCell
    }
}

//MARK: -
//MARK: - extension UICollectionViewDelegate
extension SPLTIVPMultiSeriesChannelVideoDetailTableViewCell: UICollectionViewDelegate {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (self.channel as? SPLTMultiLevelChannel) != nil {
            let iCurChildChannelIndex = indexPath.row
            //self.delegate?.didUpdateCurSeason(iCurChildChannelIndex)
            self.delegate?.didSelectSeasonAtIndex(iCurChildChannelIndex)
        }
    }
}

//MARK: -
//MARK: - extension TVOSMultiSeriesChannelVideoSeriesSeasonCellDelegate
extension SPLTIVPMultiSeriesChannelVideoDetailTableViewCell: SPLTIVPMultiSeriesChannelVideoSeriesSeasonCellDelegate {
    open func didHighlightSeasonAtIndex(_ index: Int) {
        self.delegate?.didHighlightSeasonAtIndex(index)
    }
    open func didSelectSeasonAtIndex(_ index: Int) {
        self.delegate?.didSelectSeasonAtIndex(index)
    }
}
