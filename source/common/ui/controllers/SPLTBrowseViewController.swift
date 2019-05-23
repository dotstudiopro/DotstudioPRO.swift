//
//  SPLTBrowseViewController.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 09/05/18.
//

import Foundation
import UIKit


open class SPLTBrowseViewController: SPLTBaseViewController, UITableViewDataSource, UITableViewDelegate, SPLTHorizontalBaseTableViewCellDelegate {
    
    @IBOutlet weak open var barButtonItemSearch: UIBarButtonItem!
    @IBOutlet weak open var tableView: UITableView?
    open var categoriesBrowse: [SPLTCategory] = []
    
    @IBInspectable open var tableViewHeight: CGFloat = 100.0
    @IBInspectable open var tableViewHeightForIpad: CGFloat = 200.0
    @IBInspectable open var collectionViewItemSize: CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewItemSizeForIpad: CGSize = CGSize(width: 320, height: 180)
    @IBInspectable open var collectionViewImageSize: CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewImageSizeForIpad: CGSize = CGSize(width: 320, height: 180)
    
    open override func viewDidLoad() {
        super.viewDidLoad()
//        #if os(tvOS)
            self.tableView?.mask = nil
//        #endif
    }
    open func reloadSectionAtIndex(index: Int) {
        if let tableView = self.tableView {
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integer: index) as IndexSet, with: .automatic)
            tableView.endUpdates()
        }
    }
    open func reloadData() {
        self.tableView?.reloadData()
    }
    
    open func sequenceAndSetCategories(categories: [SPLTCategory]) {
        self.categoriesBrowse.removeAll()
        let filteredCategories = categories.filter { (category) -> Bool in
            return category.bHomePage
        }
        categoriesBrowse.append(contentsOf: filteredCategories)
        var sortedCategoriesBrowse = categoriesBrowse.sorted { (category1, category2) -> Bool in
            if category1.weight < category2.weight {
                return true
            }
            return false
        }
        
        // filter & get custom categories and add those
        //        if SPLTConfig.UseCustomCategories {
        let customCategories = categories.filter { (spltCategory) -> Bool in
            if spltCategory is SPLTCustomCategory {
                return true
            }
            return false
        }
        for customCategory in customCategories {
            if let spltCustomCategory = customCategory as? SPLTCustomCategory {
                if spltCustomCategory.enumSPLTCustomCategoryType == .continueWatching {
                    if SPLTConfig.iCustomCategoryContinueWatchingIndex == -1 {
                        sortedCategoriesBrowse.insert(customCategory, at:sortedCategoriesBrowse.endIndex)
                    } else {
                        if sortedCategoriesBrowse.count > SPLTConfig.iCustomCategoryContinueWatchingIndex {
                            sortedCategoriesBrowse.insert(customCategory, at: SPLTConfig.iCustomCategoryContinueWatchingIndex)
                        }
                    }
//                    if sortedCategoriesBrowse.count > 1 {
//                        sortedCategoriesBrowse.insert(spltCustomCategory, at: 1)
//                    }
                } else if spltCustomCategory.enumSPLTCustomCategoryType == .watchAgain {
                    if SPLTConfig.iCustomCategoryWatchAgainIndex == -1 {
                        sortedCategoriesBrowse.insert(customCategory, at:sortedCategoriesBrowse.endIndex)
                    } else {
                        if sortedCategoriesBrowse.count > SPLTConfig.iCustomCategoryWatchAgainIndex {
                            sortedCategoriesBrowse.insert(customCategory, at: SPLTConfig.iCustomCategoryWatchAgainIndex)
                        }
                    }
//                    sortedCategoriesBrowse.append(spltCustomCategory)
                }
            }
        }
        //        }
        self.categoriesBrowse = sortedCategoriesBrowse
    }
    
    //MARK: - IBAction methods
    
    @IBAction open func didClickSettingButton(sender: AnyObject) {
        //self.delegate?.didClickSettingButton()
    }
    @IBAction open func didClickSearchButton(sender: AnyObject) {
        //self.delegate?.didClickSearchButton()
    }
    
    open func reloadCategory(category: SPLTCategory) {
        if let index = self.categoriesBrowse.index(of: category) {
            self.reloadSectionAtIndex(index: index)
        }
    }

//MARK: -
//MARK: - extension UITableViewDataSource
    open func numberOfSections(in tableView: UITableView) -> Int {
        return self.categoriesBrowse.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    #if os(tvOS)
    open func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    #endif

//MARK: -
//MARK: - extension SPLTHorizontalBaseTableViewCellDelegate methods
    open func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didSelectCategory category: SPLTCategory) {
        print("show Category")
    }
    open func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didSelectChannel channel: SPLTChannel, atIndex index: Int) {
        print("channel selected")
        if let spltIVPPresentor = SPLTAppDelegate.shared.window?.rootViewController as? SPLTIVPPresentor {
            spltIVPPresentor.openIVPViewControllerVideo(video: nil, in: channel, atAutoPlayIndex: index, spltIVPViewControllerDelegate: nil)
        }
    }
    
    open func spltHorizontalBaseTableViewCell(_ spltHorizontalBaseTableViewCell: SPLTHorizontalBaseTableViewCell, didSelectVideo video: SPLTVideo, inChannel channel: SPLTChannel?, atIndex index: Int) {
        print("video selected")
        if let spltIVPPresentor = SPLTAppDelegate.shared.window?.rootViewController as? SPLTIVPPresentor {
            spltIVPPresentor.openIVPViewControllerVideo(video: nil, in: channel, atAutoPlayIndex: index, spltIVPViewControllerDelegate: nil)
        }
    }
    
    
}






