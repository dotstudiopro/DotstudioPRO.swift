//
//  SPLTCategoriesViewController.swift
//  DotstudioUI
//
//  Created by Ketan Sakariya on 09/05/18.
//

import Foundation
//import DotstudioAPI
import UIKit

open class SPLTCategoriesViewController: SPLTBaseViewController {
    @IBOutlet weak open var collectionView: UICollectionView?
    open var categories: [SPLTCategory] = []
    
    @IBInspectable open var collectionViewNumberOfColumns:Int = 1
    @IBInspectable open var collectionViewItemSpacing:Int = 10
    @IBInspectable open var collectionViewItemSize:CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewItemSizeForIpad: CGSize = CGSize(width: 320, height: 180)
    @IBInspectable open var collectionViewImageSize:CGSize = CGSize(width: 160, height: 90)
    @IBInspectable open var collectionViewImageSizeForIpad: CGSize = CGSize(width: 320, height: 180)
    open var filterCriteria: String = "menu"

   open override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    open func reloadData() {
        self.collectionView?.reloadData()
    }
    
    open func sequenceAndSetCategories(categories: [SPLTCategory]) {
        let filteredCategories = categories.filter { (category) -> Bool in
            
            if self.filterCriteria == "menu" {
                return category.bMenu
            } else if self.filterCriteria == "homepage" {
                return category.bHomePage
            } else {
                for custom_field in category.custom_fields {
                    if let strCustomFieldTitle = custom_field["field_title"] as? String, let strCustomFieldValue = custom_field["field_value"] as? String, strCustomFieldTitle.lowercased() == self.filterCriteria.lowercased() {
                        if strCustomFieldValue == "true" {
                            return true
                        }
                    }
                }
                return false
            }
        }
        let sortedCategories = filteredCategories.sorted { (category1, category2) -> Bool in
            if category1.weight < category2.weight {
                return true
            }
            return false
        }
        self.categories = sortedCategories
    }
}
///MARK: -
//MARK: - extension UICollectionViewDataSource
extension SPLTCategoriesViewController: UICollectionViewDataSource {
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

//MARK: -
//MARK: - extension UICollectionViewDelegateFlowLayout
extension SPLTCategoriesViewController: UICollectionViewDelegateFlowLayout {
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {}
}




