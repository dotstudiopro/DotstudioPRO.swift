//
//  SPLTCategory.swift
//  DotstudioPRO
//
//  Created by ketan on 07/04/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation

@objc public protocol SPLTCategoryDelegate {
    @objc optional func didUpdateCategoryChannels()
    @objc optional func didUpdateCategoryChannelsForCategory(_ category: SPLTCategory)
}

open class SPLTCategory: NSObject { //, DTSZChannelAPIDelegate {

    open var delegate: SPLTCategoryDelegate?
//    var genericTableViewCellObjectDelegate: TVOSGenericTableViewCellObjectDelegate?
//    {
//        get {
//            return self.genericFeaturedTableViewCellObjectDelegate
//        }
//        set {
//            //self.genericFeaturedTableViewCellObjectDelegate = genericFeaturedTableViewCellObjectDelegate
//        }
//    }
    open var categoryDict: [String: Any] = [:] {
        didSet {
        }
    }
    open var channelsDict: [[String: Any]] = [[:]] {
        didSet {
            self.channels.removeAll()
            for channelDict in channelsDict {
                
                if let spltChannel = SPLTChannel.getChannelFromChannelDict(channelDict) {
                    spltChannel.strCategorySlug = self.strSlug
                    spltChannel.isLeanChannelLoaded = true
                    self.channels.append(spltChannel)
                }
                
            }
            self.delegate?.didUpdateCategoryChannels?()
            self.delegate?.didUpdateCategoryChannelsForCategory?(self)
            if let strSlug = self.strSlug {
                let strUniqueCategoryNotification = SPLTConstants.SPLTCategory_DidUpdateCategoryChannels + strSlug
                NotificationCenter.default.post(name: Notification.Name(rawValue: strUniqueCategoryNotification), object: nil)
            }
        }
    }
    open var isCategoryChannelsLeanDataLoaded: Bool = false
    open var channels: [SPLTChannel] = []

    open var bHomePage: Bool = false
    open var bMenu: Bool = false
    open var strId: String?
    open var strName: String?
    open var strCategoryChannelPath: String?
    open var strSlug: String?
    open var weight: Int = 0
    open var poster: String?
    open var wallpaper: String?
    open var custom_fields: [[String: Any]] = []

    public override init() {
        super.init()
    }
    init(categoryDict: [String: Any]) {
        super.init()
        self.categoryDict = categoryDict
        self.mapFromCategoryDict(categoryDict)
    }
    
    open func mapFromCategoryDict(_ categoryDict: [String: Any]) {
        if let bHomePage = categoryDict["homepage"] as? Bool {
            self.bHomePage = bHomePage
        }
        if let bMenu = categoryDict["menu"] as? Bool {
            self.bMenu = bMenu
        }
        if let strId = categoryDict["_id"] as? String {
            self.strId = strId
        }
        if let strName = categoryDict["name"] as? String {
            self.strName = strName
        }
        if let strCategoryChannelPath = categoryDict["channels"] as? String {
            self.strCategoryChannelPath = strCategoryChannelPath
        }
        if let strSlug = categoryDict["slug"] as? String {
            self.strSlug = strSlug
        }
        if let weight = categoryDict["weight"] as? Int {
            self.weight = weight
        }
        if let poster = categoryDict["poster"] as? String, poster != "" {
            self.poster = poster
        }
        if let wallpaper = categoryDict["wallpaper"] as? String, wallpaper != "" {
            self.wallpaper = wallpaper
        }
        if let dictCustomFields = categoryDict["custom_fields"] as? [[String: Any]] {
            self.custom_fields = dictCustomFields
        }
        
    }
    
    class open func getFirstCategoryWithMatchingSlug(_ categories: [SPLTCategory], strSlug: String) -> SPLTCategory? {
        let filteredCategories = categories.filter { (category) -> Bool in
            if category.strSlug == strSlug {
                return true
            }
            return false
        }
        if let filteredCategory = filteredCategories.first {
            return filteredCategory
        }
        return nil
    }
}


////MARK: -
////MARK: - Category Methods
extension SPLTCategory {
    open func loadCategory(completion: @escaping (_ categoryDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if let strSlug = self.strSlug {
            
            SPLTCategoriesAPI().loadCategory(strSlug, completion: { (categoryDict) in
                // success
                if let mainCategoryDicts = categoryDict["category"] as? [[String: Any]],
                    mainCategoryDicts.count > 0 {
                    let mainCategoryDict = mainCategoryDicts[0]
                    self.mapFromCategoryDict(mainCategoryDict)
                }
                if let channelsDict = categoryDict["channels"] as? [[String: Any]] {
                    self.channelsDict = channelsDict
                }
                completion(categoryDict)
            }, completionError: { (error) in
                // error
                print("error while fetching  category.")
                completionError(error)
            })
            
        }
    }
    open func loadCategoryChannels(completion: @escaping (_ categoryChannels: [[String: Any]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if self.isCategoryChannelsLeanDataLoaded {
            completion(self.channelsDict)
            return
        }
        if let strSlug = self.strSlug {
            
            let bLeanData: Bool = true
            
            SPLTChannelsAPI().getChannelsOfCategory(bLeanData, strCategorySlug: strSlug, completion: { (categoryChannels) in
                    self.channelsDict = categoryChannels
                    self.isCategoryChannelsLeanDataLoaded = true
                    completion(categoryChannels)
                }, completionError: { (error) in
                    print("error while fetching channels of category.")
                    self.isCategoryChannelsLeanDataLoaded = true
                    completionError(error)
            })
        }
        
//        if let strCategoryChannelPath = self.strCategoryChannelPath {
//            SPLTAPI().getJSONResponse(strCategoryChannelPath, completion: { (dictionary) in
//                // Success
//                if let bValue = dictionary["success"] as? Bool {
//                    if bValue == true {
//                        if let channelsDict = dictionary["channels"] as? [[String: Any]] {
//                            self.channelsDict = channelsDict
//                        }
//                    }
//                }
//            }) { (error) in
//                // Error
//            }
//        }
    }
}



