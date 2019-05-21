//
//  SPLTCompanyData.swift
//  DotstudioPRO
//
//  Created by ketan on 07/04/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation

public protocol SPLTCompanyDataDelegate {
    func didUpdateCategories()
    func didUpdateChannels()
}

open class SPLTCompanyData: NSObject {
    
    public static let sharedInstance = SPLTCompanyData()
    open var bUseCustomCategories: Bool = true //false
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(SPLTCompanyData.didCompleteLogin), name: NSNotification.Name.SPLT_LOGIN_COMPLETED, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SPLTCompanyData.didCompleteLogout), name: NSNotification.Name.SPLT_LOGOUT_COMPLETED, object: nil)
    }
    open var delegate: SPLTCompanyDataDelegate?
    open var categoriesDict: [[String: AnyObject]] = [[:]] {
        didSet {
//            self.categories = []
//            for categoryDict in categoriesDict {
//                let spltCategory: SPLTCategory = SPLTCategory(categoryDict: categoryDict)
//                spltCategory.loadCategoryChannels(completion: { (dictCategoryChannel) in
//                    // dict category channels loaded.
//                }, completionError: { (error) in
//                    // error while loading category channels.
//                })
//                
//                #if USE_MORE_LIKE_THIS_RECOMMENDATION
//                    if spltCategory.strSlug == "more-like-this" {
//                        self.categoryMoreLikeThis = spltCategory
//                        self.spltRecommandedData = SPLTRecommandedData(categoryMoreLikeThis: spltCategory)
//                        self.categoryMoreLikeThis?.delegate = self.spltRecommandedData!
//                    }
//                #endif
//                self.categories.append(spltCategory)
//            }
//            self.delegate?.didUpdateCategories()
//            NotificationCenter.default.post(name: Notification.Name(rawValue: SPLTConstants.SPLTCompanyData_DidUpdateCategories), object: nil)
        }
    }
    open var categories: [SPLTCategory] = []
    open var homepageCategories: [SPLTCategory] = []
    open var customCategories: [SPLTCustomCategory] = []
    open var categoryMoreLikeThis: SPLTCategory?
    open var spltRecommandedData: SPLTRecommandedData?
    
    open var channelsDict: [[String: AnyObject]] = [[:]] {
        didSet {
            self.channels.removeAll()
            for channelDict in channelsDict {
                var spltChannel: SPLTChannel?
                if let childChannels = channelDict["childchannels"] as? [AnyObject], childChannels.count > 0 {
                    // Create SPLTMultiLevelChannel
                } else if (channelDict["playlist_id"] as? String) != nil {
                    spltChannel = SPLTPlaylistChannel(channelDict: channelDict)
                } else if let playlist = channelDict["playlist"] as? [[String: AnyObject]], playlist.count > 0 {
                    // Create SPLTPlaylistChannel
                    spltChannel = SPLTPlaylistChannel(channelDict: channelDict)
//                } else if let videoDict = channelDict["video"] as? [String: AnyObject] {
//                    // Create single video channel
                }
                if (spltChannel != nil) {
                    self.channels.append(spltChannel!)
                }
            }
            self.delegate?.didUpdateChannels()
        }
    }
    open var channels: [SPLTChannel] = []

    
    open var featuredChannelDict: [String: AnyObject] = [:] {
        didSet {
            if let childChannels = featuredChannelDict["childchannels"] as? [AnyObject], childChannels.count > 0 {
                // Create SPLTMultiLevelChannel
            } else if (featuredChannelDict["playlist_id"] as? String) != nil {
                self.featuredChannel = SPLTPlaylistChannel(channelDict: featuredChannelDict)
            } else if let playlist = featuredChannelDict["playlist"] as? [[String: AnyObject]], playlist.count > 0 {
                // Create SPLTPlaylistChannel
                self.featuredChannel = SPLTPlaylistChannel(channelDict: featuredChannelDict)
//            } else if let videoDict = featuredChannelDict["video"] as? [String: AnyObject] {
//                // Create single video channel
            }
        }
    }
    open var featuredChannel: SPLTPlaylistChannel? {
        didSet {
//            self.delegate?.didUpdateTopShelfChannel()
        }
    }
    
    
    
}

//MARK: - Get Categories
extension SPLTCompanyData {
    open func removeAllCategories() {
        self.categories.removeAll()
        self.customCategories.removeAll()
        self.delegate?.didUpdateCategories()
        NotificationCenter.default.post(name: Notification.Name(rawValue: SPLTConstants.SPLTCompanyData_DidUpdateCategories), object: nil)
    }
    open func getCategories() {
        SPLTTokenAPI.checkAccessTokenExpiryAndRefresh { (bRefresedToken) in
            self.getCategoriesAfterValidatingTokens()
        }
    }
    open func getCategoriesAfterValidatingTokens() {
        SPLTCategoriesAPI().getCategories({ (categoriesDict) in
                // received Categories
            
                let appleCategoriesDict = categoriesDict.filter { (category) -> Bool in
                    #if os(tvOS)
                        if let platformsDicts = category["platforms"] as? [[String: AnyObject]], platformsDicts.count > 0 {
                            if let bSupportsAppleTV = platformsDicts[0]["apple_tv"] as? Bool {
                                if bSupportsAppleTV == true {
                                    return true
                                }
                            }
                            if let strSupportsAppleTV = platformsDicts[0]["apple_tv"] as? String {
                                if strSupportsAppleTV == "true" {
                                    return true
                                }
                            }
                        }
                    #else
                        if let platformsDicts = category["platforms"] as? [[String: AnyObject]], platformsDicts.count > 0 {
                            if let bSupportsAppleTV = platformsDicts[0]["ios"] as? Bool {
                                if bSupportsAppleTV == true {
                                    return true
                                }
                            }
                            if let strSupportsAppleTV = platformsDicts[0]["ios"] as? String {
                                if strSupportsAppleTV == "true" {
                                    return true
                                }
                            }
                        }
                    #endif
                    return false
                }

                self.categoriesDict = appleCategoriesDict
                self.setCategories()
                if SPLTConfig.shouldAutoLoadCategoryChannels {
                    self.loadCategories()
                }
            
            }) { (error) in
                // Error while receiving categories...
        }
        
        self.getCustomCategoriesIfRequired()
    }
    
    open func setCategories() {
        self.categories = []
        for categoryDict in categoriesDict {
            let spltCategory: SPLTCategory = SPLTCategory(categoryDict: categoryDict)
            #if USE_MORE_LIKE_THIS_RECOMMENDATION
                if spltCategory.strSlug == "more-like-this" {
                    self.categoryMoreLikeThis = spltCategory
                    self.spltRecommandedData = SPLTRecommandedData(categoryMoreLikeThis: spltCategory)
                    self.categoryMoreLikeThis?.delegate = self.spltRecommandedData!
                }
            #endif
            self.categories.append(spltCategory)
        }
        self.addCustomCategories()
        self.delegate?.didUpdateCategories()
        NotificationCenter.default.post(name: Notification.Name(rawValue: SPLTConstants.SPLTCompanyData_DidUpdateCategories), object: nil)
    }
    open func loadCategories() {
        
        var isAnyCategoryLeanDataPending: Bool = false
        for category in self.categories {
            if category is SPLTCustomCategory {
                continue
            }
            if category.isCategoryChannelsLeanDataLoaded {
                continue
            } else if category.bHomePage {
                category.loadCategoryChannels(completion: { (dictCategoryChannel) in
                    // dict category channels loaded.
                    category.isCategoryChannelsLeanDataLoaded = true
                    self.loadCategories()
                }, completionError: { (error) in
                    // error while loading category channels.
                    category.isCategoryChannelsLeanDataLoaded = true
                    self.loadCategories()
                })
                isAnyCategoryLeanDataPending = true
                return
            } else {
                continue
            }
        }
    }
    
    open func checkTokenAndLoadHomePageData(_ completion: @escaping (_ homepageCategories: [SPLTCategory]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTTokenAPI.checkAccessTokenExpiryAndRefresh { (bRefresedToken) in
            self.getHomepageData(completion, completionError: completionError)
            self.getCategoriesAfterValidatingTokens()
        }
    }
    open func getHomepageData(_ completion: @escaping (_ homepageCategories: [SPLTCategory]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTHomepageAPI().loadHomepagedata({ (homePageData) in
            // homepage Data dict received. parse & create categories data...
            var homepageCategories: [SPLTCategory] = []
            for homePageCategory in homePageData {
                if let categoryDataDict = homePageCategory["category"] as? [String: Any] {
                    let category = SPLTCategory(categoryDict: categoryDataDict)
                    if let channelsDict = homePageCategory["channels"] as? [[String: Any]] {
                        var categoryChannels: [SPLTChannel] = []
                        for channelDict in channelsDict {
                            if let channel_type = channelDict["channel_type"] as? String {
                                var spltChannel: SPLTChannel
                                if (channel_type == "parent") {
                                    spltChannel = SPLTMultiLevelChannel(channelDict: channelDict)
                                } else if (channel_type == "playlist") {
                                    spltChannel = SPLTPlaylistChannel(channelDict: channelDict)
                                } else if (channel_type == "video") {
                                    spltChannel = SPLTVideoChannel(channelDict: channelDict)
                                } else {
                                    spltChannel = SPLTChannel(channelDict: channelDict)
                                }
                                categoryChannels.append(spltChannel)
                            } else {
                                let channel = SPLTChannel(channelDict: channelDict)
                                categoryChannels.append(channel)
                            }
                        }
                        category.channels = categoryChannels
                    }
                    homepageCategories.append(category)
                }
            }
            self.homepageCategories = homepageCategories
            self.addCustomCategories()
            completion(homepageCategories)
        }) { (error) in
            // error while retriving home page data...
            completionError(NSError(domain: "SPLTCompanyData", code: 1, userInfo: nil))
        }
    }
    
    open func getChannels() {
        
//        SPLTChannelsAPI().getChannels({ (channelsDict) in
//                self.channelsDict = channelsDict
//            }) { (error) in
//                // Error while receiving channels
//        }
        
        
        SPLTChannelsAPI().getChannelsOfCategory(strCategorySlug: "channels", completion: { (categoryChannels) in
            if categoryChannels.count > 0 {
                self.channelsDict = categoryChannels
            }
            }, completionError: { (error) in
                // Error while receiving featured channel
        })

    }
    
    //MARK: - GET Featured Channels list
    open func getTopShelfChannels(_ completion: @escaping (_ featuredChannel: SPLTPlaylistChannel?) -> Void) {
        SPLTChannelsAPI().getChannelsOfCategory(strCategorySlug: "top-shelf", completion: { (categoryChannels) in
            if categoryChannels.count > 0 {
                self.featuredChannelDict = categoryChannels[0]
                completion(self.featuredChannel)
            }
            }, completionError: { (error) in
                // Error while receiving featured channel
        })
        
    }


//    func getTopShelfChannels() {
//        SPLTChannelsAPI().getChannelsOfCategory(strCategorySlug: "featured", completion: { (categoryChannels) in
//            <#code#>
//            }, completionError: { (error) in
//                // Error while receiving featured channel
//        })
//            
//            .getChannels({ (channelsDict) in
//            self.channelsDict = channelsDict
//        }) { (error) in
//            // Error while receiving channels
//        }
//    }
}

////MARK: -
////MARK: - extension SPLTVideoAPIDelegate
//extension SPLTCompanyData: SPLTVideoAPIDelegate {
//    func didReceiveVideoData(infoDict: [String: AnyObject]) {
////        self.mapFromVideoDictionary(infoDict)
////        self.delegate?.didUpdateVideoData(infoDict)
//    }
//    func didFailedVideoAPICall() {
//        //        self.delegate?.didFailedChannelAPICall()
//    }
//    //    func didReceiveChannel(spotlightChannel_: [String : AnyObject]) {
//    //        self.mapFromVideoDictionary(spotlightChannel_)
//    ////        self.delegate?.didUpdateChannelData(spotlightChannel_)
//    //    }
//    //    func didFailedChannelAPICall() {
//    //        //        self.delegate?.didFailedChannelAPICall()
//    //    }
//}


//MARK: -
//MARK: - Get custom Categories
extension SPLTCompanyData {
    open func addCustomCategories() {
        self.AddCustomCategoriesToMainSPLTCategoriesList()
        self.AddCustomCategoriesToHomepageCategoriesList()
    }
    open func AddCustomCategoriesToMainSPLTCategoriesList() {
        let allCategories = self.categories
        let filteredCategories = allCategories.filter { (spltCategory) -> Bool in
            if spltCategory is SPLTCustomCategory {
                return false
            }
            return true
        }
        self.categories = self.addCustomCategoriesToFilteredCategories(filteredCategories)
    }
    open func AddCustomCategoriesToHomepageCategoriesList() {
        let allCategories = self.homepageCategories
        let filteredCategories = allCategories.filter { (spltCategory) -> Bool in
            if spltCategory is SPLTCustomCategory {
                return false
            }
            return true
        }
        self.homepageCategories = self.addCustomCategoriesToFilteredCategories(filteredCategories)
    }

    open func addCustomCategoriesToFilteredCategories(_ filteredCategories: [SPLTCategory]) -> [SPLTCategory] {
        var filteredAllCategories = filteredCategories
        for customCategory in self.customCategories {
            if customCategory.enumSPLTCustomCategoryType == .continueWatching {
                if SPLTConfig.iCustomCategoryContinueWatchingIndex == -1 {
                    filteredAllCategories.insert(customCategory, at:filteredAllCategories.endIndex)
                } else {
                    if SPLTConfig.iCustomCategoryContinueWatchingIndex < filteredAllCategories.count {
                        filteredAllCategories.insert(customCategory, at: SPLTConfig.iCustomCategoryContinueWatchingIndex)
                    } else {
                        filteredAllCategories.insert(customCategory, at:filteredAllCategories.endIndex)
                    }
                }
                //                filteredAllCategories.insert(customCategory, at: 0)
            } else if customCategory.enumSPLTCustomCategoryType == .watchAgain {
                if SPLTConfig.iCustomCategoryWatchAgainIndex == -1 {
                    filteredAllCategories.insert(customCategory, at:filteredAllCategories.endIndex)
                } else {
                    if SPLTConfig.iCustomCategoryWatchAgainIndex < filteredAllCategories.count {
                        filteredAllCategories.insert(customCategory, at: SPLTConfig.iCustomCategoryWatchAgainIndex)
                    } else {
                        filteredAllCategories.insert(customCategory, at:filteredAllCategories.endIndex)
                    }
                }
                //                filteredAllCategories.append(customCategory)
            }
        }
        return filteredAllCategories
    }
    
    open func setCustomCategoriesFromDict(_ customCategoriesDict: [String: AnyObject]) {
        self.customCategories.removeAll()
        if let arrayCategoriesDict = customCategoriesDict["continue-watching"] as? [[String: AnyObject]], arrayCategoriesDict.count > 0 {
            let continueWatchingCategory = SPLTCustomCategory(.continueWatching, customChannelVideosArray: arrayCategoriesDict)
            continueWatchingCategory.isCategoryChannelsLeanDataLoaded = true
            self.customCategories.append(continueWatchingCategory)
        }
        if let arrayCategoriesDict = customCategoriesDict["watch-again"] as? [[String: AnyObject]], arrayCategoriesDict.count > 0 {
            let watchAgainCategory = SPLTCustomCategory(.watchAgain, customChannelVideosArray: arrayCategoriesDict)
            watchAgainCategory.isCategoryChannelsLeanDataLoaded = true
            self.customCategories.append(watchAgainCategory)
        }
    }
    open func getCustomCategoriesIfRequired() {
        if self.bUseCustomCategories {
            self.getCustomCategories()
        }
    }
    open func getCustomCategories() {
        if SPLTRouter.strClientToken == nil {
            return
        }
        SPLTResumptionAPI().getResumptionVideos({ (responseDict) in
            // success
            self.setCustomCategoriesFromDict(responseDict)
            self.addCustomCategories()
            self.delegate?.didUpdateCategories()
            NotificationCenter.default.post(name: Notification.Name(rawValue: SPLTConstants.SPLTCompanyData_DidUpdateCategories), object: nil)

        }) { (error) in
            // error
        }
    }
}

//MARK: -
//MARK: - Get Notification methods
extension SPLTCompanyData {
    @objc open func didCompleteLogin() {
        self.removeAllCategories()
        self.getCategories()
    }
    @objc open func didCompleteLogout() {
        self.removeAllCategories()
        self.getCategories()
    }
}












