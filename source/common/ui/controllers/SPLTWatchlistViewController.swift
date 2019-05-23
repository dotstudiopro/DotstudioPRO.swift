//
//  SPLTWatchlistViewController.swift
//  RevryApp
//
//  Created by Ketan Sakariya on 05/06/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import Foundation

import UIKit

open class SPLTWatchlistViewController: SPLTBaseViewController, SPLTWatchlistCollectionViewCellDelegate {
    @IBOutlet weak open var collectionView: UICollectionView?
    
    @IBInspectable open var collectionViewNumberOfColumns:Int = 1
    @IBInspectable open var collectionViewItemSpacing:Int = 10
    @IBInspectable open var collectionViewItemSize:CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewItemSizeForIpad: CGSize = CGSize(width: 320, height: 180)
    @IBInspectable open var collectionViewImageSize:CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewImageSizeForIpad: CGSize = CGSize(width: 320, height: 180)
    open var watchlistDicts: [[String: Any]] = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SPLTWatchlistUtility.shared.delegate = self
        self.watchlistDicts = SPLTWatchlistUtility.shared.watchlistDicts

    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if SPLTUser.sharedInstance.isLoggedinUser() {
            SPLTWatchlistUtility.shared.reloadWatchList()
        }
    }
    
    open func reloadData() {
        self.collectionView?.reloadData()
    }
    
    //MARK: - extension SPLTWatchlistCollectionViewCellDelegate methods
    open func didClickRemoveChannelFromWatchlist(_ spltWatchlistCollectionViewCell: SPLTWatchlistCollectionViewCell) {
        if let indexPath = self.collectionView?.indexPath(for: spltWatchlistCollectionViewCell) {
            if indexPath.row < self.watchlistDicts.count {
                let watchlistDict = self.watchlistDicts[indexPath.row]
                if let strChannelId = watchlistDict["_id"] as? String {
                    print(strChannelId)
                    SPLTWatchlistUtility.shared.removeChannelFromWatchlist(strChannelId, completion: { (watchlistDicts) in
                        // success
                    }) { (error) in
                        // error
                    }
                }
            }
        }
    }

}
///MARK: -
//MARK: - extension UICollectionViewDataSource
extension SPLTWatchlistViewController: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.watchlistDicts.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//MARK: -
//MARK: - extension UICollectionViewDelegateFlowLayout
extension SPLTWatchlistViewController: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}

extension SPLTWatchlistViewController : SPLTWatchlistUtilityDelegate {
    public func didUpdateWatchlistChannels(watchlistDicts: [[String : Any]]) {
        self.watchlistDicts = watchlistDicts
        self.hideProgress()
        self.reloadData()
    }
    
    public func didFailedToUpdateWatchlistChannels() {
        self.reloadData()
    }
}




