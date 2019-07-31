//
//  SPLTHomeTabBarController.swift
//  DotstudioUI-iOS
//
//  Created by Ketan Sakariya on 09/05/18.
//

import Foundation

import UIKit

open class SPLTHomeTabBarController: SPLTBaseTabBarController, SPLTCompanyDataDelegate, SPLTCategoryDelegate {
    
    public let spltCompanyData: SPLTCompanyData = SPLTCompanyData.sharedInstance
    
    open var spltBrowseViewController: SPLTBrowseViewController?
    open var spltCategoriesViewController: SPLTCategoriesViewController?
    
    open var tabViewControllers: [UIViewController] = []
    open var tabBarNavigationViewControllers: [SPLTTabBarBaseNavigationViewController] = []

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.addTabBarViewControllers()
        #if os(iOS)
            self.setViewControllers(self.tabBarNavigationViewControllers, animated: false)
        #elseif os(tvOS)
            self.setViewControllers(self.tabViewControllers, animated: false)
        #endif
        
        self.startLoadingData()
        
//        SPLTAppVersionCheckerUtility.sharedInstance.checkAppVersionFromVC(viewController: self)
        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

    }
    
    open func startLoadingData() {
        self.spltCompanyData.delegate = self
        self.spltCompanyData.bUseCustomCategories = true
        
        if SPLTConfig.shouldAutoLoadCategoryChannels {
          self.spltCompanyData.getCategories()
        } else {
            self.spltCompanyData.checkTokenAndLoadHomePageData({ (cateogries) in
                self.reloadBrowseAndCategoriesViewControllers()
            }) { (error) in
                print(error)
            }
        }
    }
    
    open func reloadBrowseAndCategoriesViewControllers()
    {
        if SPLTConfig.shouldAutoLoadCategoryChannels {
            self.spltBrowseViewController?.sequenceAndSetCategories(categories: self.spltCompanyData.categories)
        } else {
            self.spltBrowseViewController?.categoriesBrowse = self.spltCompanyData.homepageCategories
        }
        self.spltBrowseViewController?.reloadData()
        self.spltCategoriesViewController?.sequenceAndSetCategories(categories: self.spltCompanyData.categories)
        self.spltCategoriesViewController?.reloadData()
        

    }
    
    open func addTabBarViewControllers() {
        self.addBrowseViewController()
        self.addCategoriesViewController()
    }
    
    open func addBrowseViewController() {
        if let spltBrowseViewController = self.getViewControllerFromStoryboardName("browse", strViewControllerIdentifier: "SPLTBrowseViewController") as? SPLTBrowseViewController {
            self.spltBrowseViewController = spltBrowseViewController
            self.tabViewControllers.append(spltBrowseViewController)
             #if os(iOS)
                let spltTabBarBaseNavigationViewController = SPLTTabBarBaseNavigationViewController(rootViewController: spltBrowseViewController)
                self.tabBarNavigationViewControllers.append(spltTabBarBaseNavigationViewController)
            #endif
        }
    }
    
    open func addCategoriesViewController() {
        if let spltCategoriesViewController = self.getViewControllerFromStoryboardName("categories", strViewControllerIdentifier: "SPLTCategoriesViewController") as? SPLTCategoriesViewController {
            self.spltCategoriesViewController = spltCategoriesViewController
            self.tabViewControllers.append(spltCategoriesViewController)
            #if os(iOS)
                let spltTabBarBaseNavigationViewController = SPLTTabBarBaseNavigationViewController(rootViewController: spltCategoriesViewController)
                self.tabBarNavigationViewControllers.append(spltTabBarBaseNavigationViewController)
            #endif
        }
    }

    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.loginIntroSwipeViewController?.viewWillAppear(animated)
        
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    open func reloadData() {
    }

//MARK: -
//MARK: - extension Observers
    @objc open func applicationDidBecomeActive() {
//        SPLTAppVersionCheckerUtility.sharedInstance.checkAppVersionFromVC(viewController: self)
       // self.spltCompanyData.getCategories()
        self.spltCompanyData.checkTokenAndLoadHomePageData({ (cateogries) in
            self.reloadBrowseAndCategoriesViewControllers()
        }) { (error) in
            print(error)
        }
    }

//MARK: -
//MARK: - extension SPLTCompanyDataDelegate
    open func didUpdateCategories() {
       // if SPLTConfig.shouldAutoLoadCategoryChannels {
            self.reloadBrowseAndCategoriesViewControllers()
        //}
    }
    
    open func didUpdateChannels() {
        //self.updateABSTableViewCellDataSources()
    }
    
    open func didUpdateTopShelfChannel() {
        
    }

//MARK: -
//MARK: - extension SPLTCategoryDelegate
    open func didUpdateCategoryChannels() {
    }
    
    open func didUpdateCategoryChannelsForCategory(_ category: SPLTCategory) {
//        self.updateABSTableViewCellDataSources()
//        self.reloadCategory(category: category)
//        if category.channels.count == 1 {
//            self.loadAllChannelsOfCategory(category: category)
//        }
    }
}



