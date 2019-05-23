//
//  SPLTChannelsViewController.swift
//  DotstudioUI
//
//  Created by Anwer on 5/16/18.
//

import UIKit
import Foundation


open class SPLTCategoryViewController: SPLTBaseViewController {
    @IBOutlet weak open var collectionView: UICollectionView?
    open var category: SPLTCategory?
    
    @IBInspectable open var collectionViewItemSize:CGSize = CGSize(width: 320, height: 180)
    @IBInspectable open var collectionViewImageSize:CGSize = CGSize(width: 320, height: 180)
    @IBInspectable open var collectionViewNumberOfColumns:Int = 1
    @IBInspectable open var collectionViewItemSpacing:Int = 10
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.resetCollectionViewSize(self.collectionViewItemSize)
        self.setTitle();
    }
    
    open func reloadData() {
        self.collectionView?.reloadData()
    }
    
    open func getCollectionViewItemSize() -> CGSize {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.getCollectionViewItemSizeForIpad()
        }
        #endif
        return self.collectionViewItemSize
    }
    
    open func getCollectionViewImageSize() -> CGSize {
        #if os(iOS)
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.getCollectionViewImageSizeForIpad()
        }
        #endif
        return self.collectionViewImageSize
    }
    #if os(iOS)
    open func getCollectionViewImageSizeForIpad() -> CGSize {
        return CGSize(width: self.collectionViewImageSize.width*2, height: self.collectionViewImageSize.height*2)
    }
    
    open func getCollectionViewItemSizeForIpad() -> CGSize {
        return CGSize(width: self.collectionViewItemSize.width*2, height: self.collectionViewItemSize.height*2)
    }
    #endif
    
    open func resetCollectionViewSize(_ collectionViewItemSize: CGSize) {
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = self.getCollectionViewItemSize()
        }
    }
    
    open func setTitle() {
        if let strTitle = self.category?.strName {
            self.title = strTitle
        }
    }
}
///MARK: -
//MARK: - extension UICollectionViewDataSource
extension SPLTCategoryViewController: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.category!.channels.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//MARK: -
//MARK: - extension UICollectionViewDelegateFlowLayout
extension SPLTCategoryViewController: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}
