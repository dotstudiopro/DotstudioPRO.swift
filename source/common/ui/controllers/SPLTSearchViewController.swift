//
//  SPLTSearchViewController.swift
//  DotstudioSampleApp-iOS
//
//  Created by Ketan Sakariya on 29/05/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import Foundation
import UIKit


public protocol SPLTSearchViewControllerDelegate {
    func didSelectSearchVideo(video: SPLTVideo)
    func didSelectSearchChannel(channel: SPLTChannel)
}

open class SPLTSearchViewController: SPLTBaseViewController, UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    open var searchType: SearchType = .video
    open var delegate: SPLTSearchViewControllerDelegate?
    @IBOutlet open weak var searchBar: UISearchBar?
    @IBOutlet open weak var collectionView: UICollectionView?
    @IBInspectable open var collectionViewNumberOfColumns:Int = 1
    @IBInspectable open var collectionViewItemSpacing:Int = 10
    @IBInspectable open var collectionViewItemSize:CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewImageSize:CGSize = CGSize(width: 160, height: 90)
    @IBOutlet open weak var constraintCollectionViewBottom: NSLayoutConstraint?
    
    public let spltSearchAPI = SPLTSearchAPI()
    open var videosDict: [[String: AnyObject]] = [[:]] {
        didSet {
            self.videos.removeAll()
            for videoDict in videosDict {
                let spltVideo = SPLTVideo(searchResultVideoDict: videoDict)
                self.videos.append(spltVideo)
            }
        }
    }
    open var videos: [SPLTVideo] = []
    open var channelsDict: [[String: AnyObject]] = [[:]] {
        didSet {
            self.channels.removeAll()
            for channelDict in channelsDict {
                let spltChannel = SPLTChannel(searchResultChannelDict: channelDict)
                self.channels.append(spltChannel)
            }
        }
    }
    open var channels: [SPLTChannel] = []
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        var collectionViewItemWidth = self.view.frame.width - (CGFloat(self.collectionViewNumberOfColumns + 1) * CGFloat(self.collectionViewItemSpacing))
        if self.collectionViewNumberOfColumns == 1 {
            collectionViewItemWidth = self.view.frame.width
        }
        collectionViewItemWidth = collectionViewItemWidth / CGFloat(self.collectionViewNumberOfColumns)
        collectionViewItemWidth = floor(collectionViewItemWidth)
        let collectionViewItemHeight = collectionViewItemWidth
        let size = CGSize(width: collectionViewItemWidth, height: collectionViewItemHeight)
        self.collectionViewItemSize = size
        self.resetCollectionViewSize(size)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.collectionViewLayout.invalidateLayout()
        self.collectionView?.reloadData()
        
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        #if os(iOS)
        NotificationCenter.default.addObserver(self, selector: #selector(self.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillAppear(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        #endif
    }
    
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    open func resetCollectionViewSize(_ collectionViewItemSize: CGSize) {
        if let flowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = collectionViewItemSize
        }
        
    }
   
    @objc open func rotated() {
        #if os(iOS)
        if (UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeLeft || UIApplication.shared.statusBarOrientation == UIInterfaceOrientation.landscapeRight) {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        } else {
            self.collectionView?.collectionViewLayout.invalidateLayout()
            self.collectionView?.reloadData()
        }
        #endif
    }
    
    
    
    //MARK: - Search Helper methods
    open func searchResultsWithTerm(strSearchTerm: String) {
        let strSearchTermLoweredCase = strSearchTerm.lowercased()
        switch self.searchType {
            case .channel: self.searchChannelResultsWithTerm(strSearchTerm: strSearchTermLoweredCase)
            case .video: self.searchVideoResultsWithTerm(strSearchTerm: strSearchTermLoweredCase)
        }
    }
    
    open func searchVideoResultsWithTerm(strSearchTerm: String) {
        //        self.showProgress()
        SPLTSearchAPI().searchVideoResults(strSearchTerm, completion: { (searchVideoResults) in
            if let videoDictSearchResults = searchVideoResults["hits"] as? [[String: AnyObject]] {
                self.videosDict = videoDictSearchResults
                self.collectionView?.reloadData()
                
            }
            //            self.hideProgress()
        }) { (error) in
            // Handle Error
        }
    }
    open func searchChannelResultsWithTerm(strSearchTerm: String) {
        //        self.showProgress()
        SPLTSearchAPI().getSearchResults(strSearchTerm, completion: { (searchChannelResults) in
            if let channelDictSearchResults = searchChannelResults["hits"] as? [[String: AnyObject]] {
                self.channelsDict = channelDictSearchResults
                self.collectionView?.reloadData()
                
            }
            //            self.hideProgress()
        }) { (error) in
            // Handle Error
        }
    }
    
    //MARK: - Notification methods.
    @objc open func keyboardWillAppear(notification: NSNotification) {
        #if os(iOS)
        if let keyboardInfo = notification.userInfo! as? [String : AnyObject] {
            if let keyboardFrameBeginValue = keyboardInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue {
                let keyboardFrameBeginRect = keyboardFrameBeginValue.cgRectValue
                self.constraintCollectionViewBottom?.constant = keyboardFrameBeginRect.height
            }
        }
        #endif
    }
    
    @objc open func keyboardWillHide(notification: NSNotification) {
        self.constraintCollectionViewBottom?.constant = 0
    }
    

//MARK: -
//MARK: - extension UISearchResultsUpdating
    open func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //strSearchBarText.characters.count
        if let strSearchBarText = searchBar.text, strSearchBarText.count >= 2 {
            self.searchResultsWithTerm(strSearchTerm: searchBar.text!)
        } else {
            self.channels.removeAll()
            self.videos.removeAll()
        }
    }
    
    open func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    open func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    open func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.isFirstResponder) {
            searchBar.resignFirstResponder()
        }
        if let strSearchText = searchBar.text {
            self.searchResultsWithTerm(strSearchTerm: strSearchText)
        }
    }


//MARK: -
//MARK: - extension UICollectionViewDataSource
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch self.searchType {
            case .channel: return self.channels.count
            case .video: return self.videos.count
        }
    }
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    open func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    
    
//MARK: -
//MARK: - extension UICollectionViewDelegate
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
    
}





