//
//  SPLTHelper.swift
//  DotstudioPRO
//
//  Created by ketan on 19/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation

protocol SPLTHelperAPIDelegate {
    
    func didLoadSpotlightData(_ spotlightDataMutableArray: NSMutableArray)
    func didFailedToLoadSpotlightData()
}

class SPLTHelperAPI: NSObject {
    
    var delegate: SPLTHelperAPIDelegate?
    var spotlightCategories: [[String:AnyObject]] = []
    var spotlightChannels: [[String:AnyObject]] = []
    
    let spotlightCategoriesAPI: SPLTCategoriesAPI = SPLTCategoriesAPI()
    let spotlightChannelsAPI: SPLTChannelsAPI = SPLTChannelsAPI()
    
    //MARK: - Helper methods
    func startLoadingData() {
        
//        if (SPLTRouter.strAccessToken == nil) {
//            SPLTTokenAPI().getToken({ (strToken) -> Void in
//                self.requestChannels()
//            })
////            return
//        } else {
//            self.requestChannels()
//        }
        
        self.requestChannels()

    }
    
    func requestChannels() {
        //        self.isLoadingData = true

        self.spotlightCategoriesAPI.delegate = self
        
        if (SPLTRouter.strAccessToken == nil) {
            self.spotlightCategoriesAPI.regenerateAccessTokenAndGetCategories()
        } else {
            self.spotlightCategoriesAPI.getCategories()
        }
    }
    
    func mergeSpotlightCategoriesAndChannels() {
        if (self.spotlightCategories.count<=0 || self.spotlightChannels.count<=0) {
            return;
        }
        
        let dictCategories: NSMutableDictionary = NSMutableDictionary()
        
        for spotlightCategory:[String:AnyObject] in self.spotlightCategories {
            if let spotlightCategoryId = spotlightCategory["_id"] as? String {
                let dictCategory: NSMutableDictionary = NSMutableDictionary()
                dictCategory["text"] = spotlightCategory["name"] as? String
                dictCategory["name"] = spotlightCategory["name"]
                if let iSpotlightCategoryWeight = spotlightCategory["weight"] as? Int {
                    dictCategory["weight"] = iSpotlightCategoryWeight
                }
                if let strSpotlightCategorySlug = spotlightCategory["slug"] as? String {
                    dictCategory["slug"] = strSpotlightCategorySlug
                }
//                dictCategories["weight"] = spotlightCategory["weight"] as? Int
//                print(spotlightCategory["weight"])
//                print(dictCategories["weight"])
                dictCategory["id"] = spotlightCategoryId
                dictCategory["homepage"] = spotlightCategory["homepage"]
                dictCategory["menu"] = spotlightCategory["menu"]
                dictCategories[spotlightCategoryId] = dictCategory
            }
        }
        
        self.spotlightCategories.sort { (category1: [String: AnyObject], category2: [String: AnyObject]) -> Bool in
            let iCategory1Weight = category1["weight"] as! Int
            let iCategory2Weight = category2["weight"] as! Int
            if (iCategory1Weight < iCategory2Weight) {
                return true
            }
            return false
        }
        
        for spotlightChannel:[String:AnyObject] in self.spotlightChannels {
            if let categories = spotlightChannel["categories"] as? [[String:AnyObject]] {
                for category in categories {
                    if let categoryId = category["_id"] as? String {
                        if let dictCategory = dictCategories[categoryId] as? NSMutableDictionary {
                            if dictCategory["channels"] == nil {
                                dictCategory["channels"] = NSMutableArray()
                            }
                            if let channelsArray = dictCategory["channels"] as? NSMutableArray {
                                channelsArray.add(spotlightChannel)
                            }
                        }
                    }
                    //
                }
            }
        }
        
        
        let spotlightData = dictCategories.allValues as [Any]
        let spotlightDataMutableArray = spotlightData as! [[String: Any]] //: NSMutableArray = NSMutableArray(array: spotlightData)
        
        
        let sortedSpotlightDataMutableArray_ = spotlightDataMutableArray.sorted { (category1, category2) -> Bool in
            if let iCategory1Weight = (category1 as? [String : Any])?["weight"] as? Int, let iCategory2Weight = (category2 as? [String : Any])?["weight"] as? Int {
                if (iCategory1Weight < iCategory2Weight) {
                    return true
                }
            }
            return false
        }
        let sortedSpotlightDataMutableArray = NSMutableArray(array: sortedSpotlightDataMutableArray_)
        
        // Move Featured Category on Top.
        for spotlightCategory in sortedSpotlightDataMutableArray {
            if let spotlightCategory_ = spotlightCategory as? [String: AnyObject], let spotlightCategoryText = spotlightCategory_["text"] as? String {
                if spotlightCategoryText == "Featured" {
                    sortedSpotlightDataMutableArray.remove(spotlightCategory)
                    sortedSpotlightDataMutableArray.insert(spotlightCategory, at: 0)
                    break;
                }
            }
        }
        
        // Remove Empty Categories.
//        let iTotalCategories: Int = spotlightDataMutableArray.count
//        //        for var i = 0; i < Int(propertiesCount); i++
//        for var i = iTotalCategories-1; i>=0; i-- {
//            let dictCat: NSMutableDictionary = spotlightDataMutableArray.objectAtIndex(i) as! NSMutableDictionary
//            //            if dictCat["text"] as! String == "Culture" {
//            //                println("Culture")
//            //                println(dictCat)
//            //            }
//            var shouldRemove: Bool = true
//            if let channelsArray = dictCat["channels"] as? NSMutableArray {
//                print("channelsArray present")
//                //                for channel in channelsArray {
//                //                    print(channel)
//                //                }
//                shouldRemove = false
//            }
//            if shouldRemove {
//                spotlightDataMutableArray.removeObjectAtIndex(i)
//            }
//        }
        
        //        let spotlightData5: [String:AnyObject] = dictCategories.dictionaryWithValuesForKeys(dictCategories.allKeys) as! [String:AnyObject]
        
        
        
        
        self.delegate?.didLoadSpotlightData(sortedSpotlightDataMutableArray)
        
        
    }
    
    
    
}

extension SPLTHelperAPI: SPLTCategoriesAPIDelegate {
    func didReceiveCategories(_ spotlightCategories_: [[String : AnyObject]]) {
        
//        let spotlightCategoriesWithMenu = spotlightCategories_.filter { (category) -> Bool in
//            if let bMenu = category["menu"] as? Bool {
//                if bMenu == false {
//                    return false
//                }
//            }
//            return true
//        }
//        self.spotlightCategories = spotlightCategoriesWithMenu

        let spotlightCategoriesOfPlatform = spotlightCategories_.filter { (category) -> Bool in
            #if os(tvOS)
                let strPlatformString = "apple_tv"
            #else
                let strPlatformString = "ios"
            #endif
            if let platforms = category["platforms"] as? [[String: AnyObject]] {
                for platform in platforms {
                    if let bPlatformValue = platform[strPlatformString] as? Bool {
                        if bPlatformValue {
                            return true
                        }
                    } else if let strPlatformValue = platform[strPlatformString] as? String {
                        if (strPlatformValue == "true") {
                            return true
                        }
                    }
                }
            }
            return false
        }
        self.spotlightCategories = spotlightCategoriesOfPlatform

        
        self.spotlightChannelsAPI.delegate = self
        self.spotlightChannelsAPI.getChannels()
//        self.mergeSpotlightCategoriesAndChannels()
    }
    func didFailedCategoriesAPICall() {
        
    }
}

extension SPLTHelperAPI: SPLTChannelsAPIDelegate {
    func didReceiveChannels(_ spotlightChannels_: [[String : AnyObject]]) {
        // Remove Youtube channels
        
#if os(tvOS)
        let spotlightChannelsWithoutYoutube = spotlightChannels_.filter { (channel) -> Bool in
            if let bHasYouTube = channel["has_youtube"] as? Bool {
                if bHasYouTube == true {
                    return false
                }
            }
            return true
        }
    self.spotlightChannels = spotlightChannelsWithoutYoutube //spotlightChannels_
#else
    self.spotlightChannels = spotlightChannels_ 
#endif
        self.mergeSpotlightCategoriesAndChannels()
    }
    func didFailedChannelsAPICall() {
        
    }
}




