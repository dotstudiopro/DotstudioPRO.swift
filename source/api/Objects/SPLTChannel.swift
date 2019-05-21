//
//  SPLTChannel.swift
//  DotstudioPRO
//
//  Created by ketan on 07/04/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation

open class SPLTChannel: NSObject {
    
    open var channelDict: [String: Any] = [:] {
        didSet {

        }
    }
    open var searchResultChannelDict: [String: Any] = [:]
    
    open var strCategorySlug: String?
    open var strId: String?
    open var dspro_id: String?
    open var strDescription: String?
    var company: String?
    open var spotlight_company_id: String?
    open var strTitle: String?
    open var strPath: String?
    open var strSlug: String?
    @objc open var poster: String?
    open var spotlight_poster: String?
    open var channel_logo: String?
    open var videos_thumb: String?
    open var channel_url: String?
    
    open var strChannelInfo: String?
    
    open var isLeanChannelLoaded: Bool = false
    open var isPartialChannelLoaded: Bool = false
    open var isFullChannelLoaded: Bool = false
    open var hasPlatformAccess: Bool = false
    open var availablePlatforms = Set<String>()
    
    @objc dynamic open var isInWatchlist: Bool = false
    
    open var is_product: Bool = false

    open var isUnlocked = true
    open var bAdsEnabled = true

    
    #if os(iOS)
        open var mutableAttributedStringChannelInfo: NSMutableAttributedString?
    #endif

    public override init() {
        super.init()
    }
    public init(channelDict: [String: Any]) {
        super.init()
        
        self.channelDict = channelDict
        self.mapFromChannelDict(channelDict)
    }
    public init(searchResultChannelDict: [String: Any]) {
        super.init()
        self.searchResultChannelDict = searchResultChannelDict
        self.mapFromSearchResultChannelDict(searchResultChannelDict)
    }
    open func mapFromChannelDict(_ channelDict: [String: Any]) {
        if let strId = channelDict["_id"] as? String {
            self.strId = strId
        }
        if let dspro_id = channelDict["dspro_id"] as? String {
            self.dspro_id = dspro_id
        }
        if let strDescription = channelDict["description"] as? String {
            self.strDescription = strDescription
        }
        if let strCompany = channelDict["company"] as? String {
            self.company = strCompany
        }
        if let spotlight_company_id = channelDict["spotlight_company_id"] as? String {
            self.spotlight_company_id = spotlight_company_id
        }
        if let strTitle = channelDict["title"] as? String {
            self.strTitle = strTitle
        }
        if let strPath = channelDict["path"] as? String {
            self.strPath = strPath
        }
        if let strSlug = channelDict["slug"] as? String {
            self.strSlug = strSlug
        }
        if let poster = channelDict["poster"] as? String {
            self.poster = poster
        }
        if let spotlight_poster = channelDict["spotlight_poster"] as? String {
            self.spotlight_poster = spotlight_poster
        }
        if let channel_logo = channelDict["channel_logo"] as? String {
            self.channel_logo = channel_logo
        }
        if let videos_thumb = channelDict["videos_thumb"] as? String {
            self.videos_thumb = videos_thumb
        }
        if let channel_url = channelDict["channel_url"] as? String {
            self.channel_url = channel_url
        }
        if let is_product = channelDict["is_product"] as? Bool {
            self.is_product = is_product
        }
        
        self.updateChannelInfo()
        
        if let categories = channelDict["categories"] as? [[String: Any]] {
            for category in categories {
                if let platforms = category["platforms"] as? [[String: Any]] {
                    if let platform = platforms.first {
                        for key in platform.keys {
                            if let bPlatformValue = platform[key] as? Bool , bPlatformValue == true {
                                self.availablePlatforms.insert(key)
                            } else if let bPlatformValue = platform[key] as? String , bPlatformValue == "true" {
                                self.availablePlatforms.insert(key)
                            }
                        }
                        
                        var strPlatformKey = "ios"
                        #if os(tvOS)
                            strPlatformKey = "apple_tv"
                        #endif
                        if let bPlatformValue = platform[strPlatformKey] as? Bool , bPlatformValue == true {
                           self.hasPlatformAccess = true
                        } else if let bPlatformValue = platform[strPlatformKey] as? String , bPlatformValue == "true" {
                            self.hasPlatformAccess = true
                        }
                    }
                }
            }            
        }
    }
    
    open func mapFromSearchResultChannelDict(_ searchResultChannelDict: [String: Any]) {
        if let strId = searchResultChannelDict["_id"] as? String {
            self.strId = strId
        }
        if let strSlug = searchResultChannelDict["slug"] as? String {
            self.strSlug = strSlug
        }
        if let _sourceDict = searchResultChannelDict["_source"] as? [String: Any] {
            if let strTitle = _sourceDict["title"] as? String {
                self.strTitle = strTitle
            }
            if let is_product = _sourceDict["is_product"] as? Bool {
                self.is_product = is_product
            }
        }
        if let poster = searchResultChannelDict["poster"] as? String {
            self.poster = poster
        }
        if let spotlight_poster = searchResultChannelDict["spotlight_poster"] as? String {
            self.spotlight_poster = spotlight_poster
        }
        
    }
    
    open func updateChannelInfo() {
        var strChannelInfo = ""
        if let strCategory = self.channelDict["category"] as? String {
            strChannelInfo = "\(strCategory) | "
        }
        if let strYear = self.channelDict["year"] as? String {
            strChannelInfo += "\(strYear) | "
        }
        if let strRating = self.channelDict["rating"] as? String {
            strChannelInfo += "\(strRating) | "
        }
        if let strLanguage = self.channelDict["language"] as? String {
            strChannelInfo += "\(strLanguage) | "
        }
        if let strCountry = self.channelDict["country"] as? String {
            strChannelInfo += "\(strCountry) | "
        }
        
        //strChannelInfo.characters.count
        let iStringLengthBeforeCompanyName: Int = strChannelInfo.count
        var strCompanyName: String?
        if let strCompany = self.company {
            strChannelInfo += "\(strCompany.uppercased())"
            strCompanyName = strCompany
        }
        self.strChannelInfo = strChannelInfo

//        #if os(iOS)
//            let spotlightFont: UIFont = UIFont(name: "Montserrat-Regular", size: 18.0)!
//            let myMutableString: NSMutableAttributedString = NSMutableAttributedString(string: strChannelInfo, attributes: [NSAttributedStringKey.font:spotlightFont])
//            if let fontColor = K10Theme.fontColor {
//                myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: fontColor, range: NSMakeRange(0, strChannelInfo.characters.count))
//            }
//
//            if (strCompanyName != nil) {
//                let iStringLengthAfterCompanyName: Int = strChannelInfo.characters.count
//                let range: NSRange = NSMakeRange(iStringLengthBeforeCompanyName, (iStringLengthAfterCompanyName - iStringLengthBeforeCompanyName))
//    //            let spotlightGreenColor = UIColor(red: 47.0/255.0, green: 137.0/255.0, blue: 80.0/255.0, alpha: 1.0)
//                if let corporateColor = K10Theme.corporateColor {
//                    myMutableString.addAttribute(NSAttributedStringKey.foregroundColor, value: corporateColor, range: range)
//                }
//            } else {
//                //                    featuredCellView?.labelChannelInfo.text = strChannelInfo
//            }
//            self.mutableAttributedStringChannelInfo = myMutableString
//        #endif
    }
    
    open func isChannelVideosUpdated() -> Bool {
        return false
    }
    open func loadChannelVideos(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
    }
    open func getVideoProgressForChannelVideos(_ completion: @escaping (_ responseDictArray: [[String: Any]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
    }

    ////MARK: -
    ////MARK: - SPLTChannel Methods
    open func loadFullChannel(_ completion: ((_ channelDict: [String: Any]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        if let strSlug = self.strSlug {
            if let strCategorySlug = self.strCategorySlug {
                let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
//                channelAPI.delegate = self
//                channelAPI.getCategoryChannel(strCategorySlug, strChannelSlug: strSlug, completion: completion, completionError: completionError)
                channelAPI.getCategoryChannel(strCategorySlug, strChannelSlug: strSlug, completion: { (channelDict) in
                    self.channelDict = channelDict
                    self.mapFromChannelDict(channelDict)
                    self.loadChannelVideoProgress({ (responseDictVideoProgress) in
                        // success
                        completion?(channelDict)
                    }, completionError: { (error) in
                        // error
                        completion?(channelDict)
                    })
                    self.isFullChannelLoaded = true
//                    completion?(channelDict)
                }, completionError: { (error) in
                    completionError?(error)
                })
            } else {
                let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
//                channelAPI.delegate = self
//                channelAPI.getChannel(strSlug, completion: completion, completionError: completionError)
                channelAPI.getChannel(strSlug, completion: { (channelDict) in
                    self.channelDict = channelDict
                    self.mapFromChannelDict(channelDict)
                    self.loadChannelVideoProgress({ (responseDictVideoProgress) in
                        self.loadSubscriptionStatus(channelDict, loadChannelCompletion: completion, loadChannelCompletionError: completionError)
                        // success
//                        completion?(channelDict)
                    }, completionError: { (error) in
                        // error
                        self.loadSubscriptionStatus(channelDict, loadChannelCompletion: completion, loadChannelCompletionError: completionError)
                        //completion?(channelDict)
                    })
                    self.isFullChannelLoaded = true
                    //completion?(channelDict)
                }, completionError: { (error) in
                    completionError?(error)
                })
            }
        } else {
            completionError?(NSError(domain: "SPLTChannel", code: 1, userInfo: ["message":"slug not found"]))
        }
    }
    
    open func resetSubscriptionStatus(_ completion: @escaping (_ bSuccess: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        let channelDict:[String: Any] = [:]
        self.loadSubscriptionStatus(channelDict, loadChannelCompletion: { (channelDict) in
            completion(true)
        }) { (error) in
            completion(false)
        }
    }
    
    open func loadSubscriptionStatus(_ channelDict: [String: Any], loadChannelCompletion: ((_ channelDict: [String: Any]) -> Void)?, loadChannelCompletionError: ((_ error: NSError) -> Void)?) {

        if !self.is_product {
            self.isUnlocked = true
            loadChannelCompletion?(channelDict)
            return;
        }
        
        if SPLTConfig.shouldByPassSubscriptionCheck {
            loadChannelCompletion?(channelDict)
            return;
        }
        if let strDsProChannelId = self.dspro_id {
            SPLTSubscriptionAPI().checkSubscriptionStatus(strDsProChannelId, completion: { (bSubscriptionUnlocked, bAdsEnabled) in
                    self.isUnlocked = bSubscriptionUnlocked
                    self.bAdsEnabled = bAdsEnabled
                loadChannelCompletion?(channelDict)
            }) { (error) in
                loadChannelCompletion?(channelDict)
            }
        } else {
            loadChannelCompletion?(channelDict)
        }
    }
    
    open func loadPartialChannel(_ completionChannel: ((_ channelDict: [String: Any]) -> Void)?, completionErrorChannel: ((_ error: NSError) -> Void)?) {
        if let strSlug = self.strSlug {
            
            let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
//            channelAPI.delegate = self
            channelAPI.getPartialChannel(strSlug, completion: { (channelDict) in
                //comple
                self.isPartialChannelLoaded = true
                self.loadSubscriptionStatus(channelDict, loadChannelCompletion: completionChannel, loadChannelCompletionError: completionErrorChannel)
                //completionChannel?(channelDict)
            }, completionError: { (error) in
                // error while getting partial channel.
                completionErrorChannel?(error)
            })
            
//            let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
//            channelAPI.getChannel(strSlug, completion: completion, completionError: completionError)
        } else {
            completionErrorChannel?(NSError(domain: "SPLTChannel", code: 1, userInfo: ["message":"slug not found"]))
        }
    }
    open func loadLeanChannel(_ completionChannel: ((_ channelDict: [String: Any]) -> Void)?, completionErrorChannel: ((_ error: NSError) -> Void)?) {
        if let strSlug = self.strSlug {
            
            let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
            //            channelAPI.delegate = self
            channelAPI.getLeanChannel(strSlug, completion: { (channelDict) in
                //comple
                self.isLeanChannelLoaded = true
                completionChannel?(channelDict)
            }, completionError: { (error) in
                // error while getting lean channel.
                completionErrorChannel?(error)
            })
            
            //            let channelAPI: SPLTChannelAPI = SPLTChannelAPI()
            //            channelAPI.getChannel(strSlug, completion: completion, completionError: completionError)
        } else {
            completionErrorChannel?(NSError(domain: "SPLTChannel", code: 1, userInfo: ["message":"slug not found"]))
        }
    }
    open func loadChannelVideoProgress(_ completion: ((_ channelDict: [[String: Any]]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        // load Video Progress
            completion?([])
    }

    ////MARK: -
    ////MARK: - SPLTChannel Methods
    open func didReceiveChannel(_ spotlightChannels_: [String : Any]) {
        self.channelDict = spotlightChannels_
        self.mapFromChannelDict(channelDict)
    }
    open func didFailedChannelAPICall() {
        
    }

    ////MARK: -
    ////MARK: - static open Methods
    open class func getChannelFromChannelDict(_ channelDict: [String: Any]) -> SPLTChannel? {
        var spltChannel: SPLTChannel?
        if let childChannels = channelDict["childchannels"] as? [Any], childChannels.count > 0 {
            // Create SPLTMultiLevelChannel
            spltChannel = SPLTMultiLevelChannel(channelDict: channelDict)
        } else if let strPlaylistId = channelDict["playlist_id"] as? String, strPlaylistId != "" {
            spltChannel = SPLTPlaylistChannel(channelDict: channelDict)
        } else if let strVideoId = channelDict["video_id"] as? String, strVideoId != ""  {
            // Create single video channel
            spltChannel = SPLTVideoChannel(channelDict: channelDict)
        } else if let playlist = channelDict["playlist"] as? [[String: Any]], playlist.count > 0 {
            // Create SPLTPlaylistChannel
            spltChannel = SPLTPlaylistChannel(channelDict: channelDict)
        } else if (channelDict["video"] as? [String: Any]) != nil {
            // Create single video channel
            spltChannel = SPLTVideoChannel(channelDict: channelDict)
        } else if let strVideoId = channelDict["video"] as? String, strVideoId != ""  {
            spltChannel = SPLTVideoChannel(channelDict: channelDict)
        } else {
            // error. // could be Multilevel channel
            spltChannel = SPLTMultiLevelChannel(channelDict: channelDict)
        }
        return spltChannel

    }
}





