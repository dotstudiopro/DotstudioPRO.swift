//
//  DTSZVideo.swift
//  DotstudioPRO
//
//  Created by ketan on 09/02/15.
//  Copyright (c) 2015 ___DotStudioz___. All rights reserved.
//

import Foundation

public enum AdType {
    case none
    case pre
    case mid
    case post
    case over
}

public protocol DTSZVideoDelegate {
    func didUpdateVideoData(_ videoDict: [String: AnyObject])
    func didUpdateVideoProgress()
    func didUpdatePaywallStatus()
}

class DTSZVideo: NSObject {
    
    internal var delegate: DTSZVideoDelegate?
    var strCategorySlug: String?
    var strChannelSlug: String?

    let countryCode: String = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String

    var adType_mid: Bool = true
    var adType_pre: Bool = true
    var adType_post: Bool = true
    var adType_over: Bool = true
    var midRollAdTimeDict: NSMutableDictionary = NSMutableDictionary()
    
    var hasPlayedAdType_Pre: Bool = false
    var hasPlayedAdType_Mid: Bool = false
    var hasPlayedAdType_Post: Bool = false
    
    var isYoutubeVideo: Bool = false
    var isLiveVideo: Bool = false
    var strVideoUrl: String? {
        didSet {
            if self.strVideoUrl != nil {
                #if APP_NOSEY
//                    if let range = self.strVideoUrl?.range(of: "e4z6v2z8.ssl.hwcdn.net") {
//                        self.strVideoUrlForCast = self.strVideoUrl?.replacingOccurrences(of: "e4z6v2z8.ssl.hwcdn.net", with: "k7q5a5e5.ssl.hwcdn.net")
//                    }
                    if let range = self.strVideoUrl?.range(of: "e4z6v2z8.ssl.hwcdn.net") {
                        self.strVideoUrlForCast = self.strVideoUrl?.replacingOccurrences(of: "e4z6v2z8.ssl.hwcdn.net", with: "e7g8u6d9.ssl.hwcdn.net")
                    }
                #else
                    self.strVideoUrlForCast = self.strVideoUrl
                #endif
            }
        }
    }
    var strVideoUrlForCast: String?
    var strTeaserUrl: String?
    var strCloseCaptionUrl: String?

    var strAdUrl: String = ""
    var strYoutubeVideoId: String = ""
    var strVideoTitle: String = ""
    var strVideoDescription: String = ""
    var rating: Float = -1.0
    var strThumbUrl: String?
    var strThumbUrls: [String] = []
    
    var isAccessAllowed: Bool = false
    var apple_price_tier: Int?
    var rental_price: String?
    var isTrailer: Bool = false
    var geoblock: String = "" {
        didSet {
//            if (geoblock == "ALL") {
//                self.isGeoBlocked = false
//            } else {
//                let geoblockArray: [String] = geoblock.components(separatedBy: ",")
//                var shouldGeoBloack: Bool = true
//                for strCountryId: String in geoblockArray {
//                    if (strCountryId == self.countryCode) {
//                        shouldGeoBloack = false
//                        break;
//                    }
//                    
//                }
//                self.isGeoBlocked = shouldGeoBloack
//            }
        }

    }
    var isGeoBlocked: Bool = false
    var isVideoWaterMarkingEnabled: Bool = false
    var strVideoWaterMarkId: String?
    var fWaterMarkOpacity: Float?
    
    var strCategory: String = ""
    var strYear: String = ""
    var strLanguage: String = ""
    var strCountry: String = ""
    var strCompanyName: String = ""
    
    var ios_ad_zone: String? = nil
    var iosads_breaksDict: [String: AnyObject]?
    
    var adsTagsDict: [String: AnyObject]?
//    var frameRate = 0.0
//    var name: String?
    var videoDict: [String: AnyObject]!
    var videoId: String! {
        didSet {
//            let videoDetailAPI: DTSZVideoAPI = DTSZVideoAPI()
//            videoDetailAPI.delegate = self
//            videoDetailAPI.getVideoDetail(self.videoId)
        }
    }
    var companyId: String = ""
    var iDuration: Int = 0
//    var strDuration: String = ""
    var progressPoint: Int? {
        didSet {
            if progressPoint == nil {
                self.strProgressDuration = ""
            } else {
                let dateComponentsFormatter: DateComponentsFormatter = DateComponentsFormatter()
                //                dateComponentsFormatter.zeroFormattingBehavior = NSDateComponentsFormatterZeroFormattingBehaviorPad;
                //                dateComponentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond);
                self.strProgressDuration = dateComponentsFormatter.string(from: TimeInterval(progressPoint!))!
            }
        }
    }
    var strProgressDuration: String = ""


    override init() {
        super.init()
    }
    init(strVideoId: String) {
        self.videoId = strVideoId
    }
    init(videoDict: [String: AnyObject]) {
        super.init()
        self.videoDict = videoDict
        self.mapFromVideoDictionary(videoDict)
    }
    init(videoDict: [String: AnyObject], strCategorySlug: String?, strChannelSlug: String?, delegate_: DTSZVideoDelegate?) {
        super.init()
        self.strCategorySlug = strCategorySlug
        self.strChannelSlug = strChannelSlug
        self.videoDict = videoDict
        self.delegate = delegate_
        if let strVideoId = self.videoDict["_id"] as? String {
            self.videoId = strVideoId
        }
        self.mapFromCategoryChannelDictionary(videoDict)
//        if let dataDict = self.videoDict["data"] as? NSDictionary {
//            if let strVideoM3U8Url = self.videoDict["video_m3u8"] as? String {
//                self.strVideoUrl = strVideoM3U8Url
//            }
//        }
    }

    
    func mapFromCategoryChannelDictionary(_ dataDict: [String: AnyObject]) {
        self.mapFromDictionary(dataDict)
        if let strThumbUrl = dataDict["thumb"] as? String {
            let strThumbUrlFinal: String = SPLTFullPathRouter.imageFullPath(strThumbUrl).URLString
            self.strThumbUrl = strThumbUrlFinal
        }
        
        // request full video detail
        //self.requestVideoInfo()
    }
    
    func mapFromVideoDictionary(_ dataDict: [String: AnyObject]) {
        self.mapFromDictionary(dataDict)
        // Override thumb url path
        if let strThumbUrl = dataDict["thumb"] as? String {
            let strThumbUrlFinal: String = strThumbUrl
            self.strThumbUrl = strThumbUrlFinal
        }
        if let bGeoCheck = videoDict["geoCheck"] as? Bool, bGeoCheck == false {
            self.isGeoBlocked = true
        }
        if let isVideoWaterMarkingEnabled = videoDict["videowatermarking"] as? Bool {
            self.isVideoWaterMarkingEnabled = isVideoWaterMarkingEnabled
        }
        if let dictComapny = videoDict["company"] as? [String: AnyObject] {
            if let dictWatermark = dictComapny["watermark"] as? [String: AnyObject] {
                if let strVideoWaterMarkId = dictWatermark["logo"] as? String {
                    self.strVideoWaterMarkId = strVideoWaterMarkId
                }
                if let fWaterMarkOpacity = dictWatermark["opacity"] as? Float {
                    self.fWaterMarkOpacity = fWaterMarkOpacity
                } else if let strWaterMarkOpacity = dictWatermark["opacity"] as? String {
                    if let fWaterMarkOpacity = Float(strWaterMarkOpacity) {
                        self.fWaterMarkOpacity = Float(fWaterMarkOpacity)
                    }
                }
            }
        }

    }
    
    func mapFromDictionary(_ dataDict: [String: AnyObject]) {

        if let strId = dataDict["_id"] as? String {
            self.videoId = strId
        }
        if let strComapnyId = dataDict["company_id"] as? String {
            self.companyId = strComapnyId
        }
        
        if let category = dataDict["category"] as? String {
            self.strCategory = category
        }
        if let year = dataDict["year"] as? String {
            self.strYear = year
        }
        if let language = dataDict["language"] as? String {
            self.strLanguage = language
        }
        if let country = dataDict["country"] as? String {
            self.strCountry = country
        }
        if let strDuration = dataDict["duration"] as? String {
            if let fDuration = Float(strDuration) {
                if !fDuration.isNaN {
                    self.iDuration = Int(fDuration)
                }
            }
//            if let iDuration = Int(strDuration) {
//                self.iDuration = iDuration
//            }
        } else if let fDuration = dataDict["duration"] as? Float {
            if !fDuration.isNaN {
                self.iDuration = Int(fDuration)
            }
//            if let iDuration = Int(fDuration) {
//                self.iDuration = iDuration
//            }
        }
        
        
        if let companyDict = dataDict["company"] as? [String: AnyObject] {
            if let adserverDict = companyDict["adserver"] as? [String: AnyObject] {
                if let str_iOSAdServer = adserverDict["ios"] as? String {
                    self.ios_ad_zone = str_iOSAdServer
                }
            }
            if let companyName = companyDict["name"] as? String {
                self.strCompanyName = companyName
            }
        } else if let company = dataDict["company"] as? String {
            self.strCompanyName = company
        }
        
        
        
        if let access = dataDict["access"] as? String {
            if (access == "public") {
                self.isTrailer = false
                self.isAccessAllowed = true
            } else if (access == "paywall") {
                self.isAccessAllowed = false
                if let paywallDict = dataDict["paywall"] as? [String: AnyObject] {
                    if let apple_price_tier = paywallDict["apple_price_tier"] as? Int {
                        self.apple_price_tier = apple_price_tier
                        print(apple_price_tier)
                    }
                    if let rental_price = paywallDict["rental_price"] as? String {
                        self.rental_price = rental_price
                    }
                }
//                // check for paywall status...
//                #if os(iOS)
//                    self.getPaywallStatus()
//                #endif

            }
        }
        
            if let geoblock = dataDict["geoblock"] as? String {
                self.geoblock = geoblock
            }
            if let strTitle = dataDict["title"] as? String {
                self.strVideoTitle = strTitle
            }
            if let strDescription = dataDict["description"] as? String {
                self.strVideoDescription = strDescription
            }
//            if let strThumbUrl = dataDict["thumb"] as? String {
//                let strThumbUrlFinal: String = SPLTRouter.ImageFullPath(strThumbUrl).URLString
//                //Router.ImageFullPathReplacingToMySpotlight(strThumbUrl).URLString
//                self.strThumbUrl = strThumbUrlFinal
//            }
            if let strThumbUrls = dataDict["thumbs"] as? [String] {
                for strThumbUrl in strThumbUrls {
                    let strThumbUrlFinal: String = SPLTFullPathRouter.imageFullPath(strThumbUrl).URLString
                    self.strThumbUrls.append(strThumbUrlFinal)
                }
            }
        if let adsDict = dataDict["ads"] as? [String: AnyObject] {
            if let iosads_breaksDict = dataDict["ad_tag"] as? [String: AnyObject] {
                self.iosads_breaksDict = iosads_breaksDict
            }
            self.setUpAdsFromAdDictionary(adsDict)
        }
        
        if let source = dataDict["source"] as? String {
            if source == "YouTube" {
                self.isYoutubeVideo = true
                if let youtubeDict = dataDict["youtube"] as? [String: AnyObject] {
                    if let youtubeId = youtubeDict["id"] as? String {
                        self.strYoutubeVideoId = youtubeId
                    }
                }
            } else if source == "Live" {
                self.isYoutubeVideo = false
                self.isLiveVideo = true
                if let liveDict = dataDict["live"] as? [String: AnyObject] {
                    if let liveUrl = liveDict["url"] as? String {
                        self.strVideoUrl = liveUrl
                    }
                }
            } else {
                self.isYoutubeVideo = false
                if let video_m3u8 = dataDict["video_m3u8"] as? String {
                    if video_m3u8.hasPrefix("http") {
                        self.strVideoUrl = video_m3u8
                    } else {
                        self.strVideoUrl = "https://".appending(video_m3u8)
                    }
//                    self.strVideoUrl = videoUrl
                } else {
                    if let pathsDict = dataDict["paths"] as? [String: AnyObject] {
                        if let strVodDir = pathsDict["vodDir"] as? String {
                            self.strVideoUrl = "http://cdn.dotstudiopro.com/\(strVodDir)/\(self.videoId).m3u8"
                        }
                    } else {
                    }
//                    // k10 added for testing
//                    self.strVideoUrl = "https://k7q5a5e5.ssl.hwcdn.net/files/company/53fd1266d66da833047b23c6/assets/videos/540f28fdd66da89e1ed70281/vod/540f28fdd66da89e1ed70281.m3u8"
                }
//                //Testing video for HLS encryption
//                self.strVideoUrl = "https://s3-us-west-1.amazonaws.com/media-aws-dotstudiopro-com/files/company/5417965bd66da8804f794507/assets/videos/5862771c15d79ccc0e004ae1/vod/test1/6d35ed694257d6f64588db3ec312e0eb_501720_329789865.m3u8"
            }
        }
        if let arrayCloseCaption = videoDict["closeCaption"] as? [[String: AnyObject]] {
            for dictCloseCpation in arrayCloseCaption {
                if let srtExt = dictCloseCpation["srtExt"] as? String, srtExt == "srt" {
                    if let srtPath = dictCloseCpation["srtPath"] as? String {
                        if srtPath.hasPrefix("http") {
                            self.strCloseCaptionUrl = srtPath
                        } else {
                            self.strCloseCaptionUrl = "https://".appending(srtPath)
                        }
                        break
                    }
                }
            }
        }

        
        // Test HLS encryption url
//        self.strVideoUrl = "https://p5f2c4d3.ssl.hwcdn.net/files/company/57bdf792d66da8b744a33855/assets/videos/57be8615d66da81809a33855/vod/57be8615d66da81809a33855.m3u8?hwauth=exp=1486066474435~acl=*~hmac=bcc8277042f47cf0c6bf7c8236eb07f02f1120a78546c94df353d7bd8b88f238"
        
        
        if let teaserDict = dataDict["teaser"] as? [String: AnyObject] {
            if let teaserPath = teaserDict["paths"] as? String {
                self.strTeaserUrl = "http://cdn.dotstudiopro.com/\(teaserPath)"
            }
        }
        
        
        
        
            if let strRating = dataDict["rating"] as? String {
                if strRating != "N/A" {
                    let stringRating: NSString = NSString(string: strRating)
//                    if let floatRating: Float = stringRating.floatValue as? Float {
//                        
//                    }
                    let f: Float = stringRating.floatValue
                    self.rating = f
                }
                
            }
            
//        }
    }
    
    //MARK: -
    //MARK: - Ads Configuration methods

    fileprivate func setUpAdsFromAdDictionary(_ adsDict: [String: AnyObject]) {
        if let overAd = adsDict["over"] as? String {
            if overAd == "no" {
                self.adType_over = false
            } else if overAd == "yes" {
                self.adType_over = true
            }
        }
        if let preAd = adsDict["pre"] as? String {
            if preAd == "no" {
                self.adType_pre = false
            } else if preAd == "yes" {
                self.adType_pre = true
            }
        }
        if let postAd = adsDict["post"] as? String {
            if postAd == "no" {
                self.adType_post = false
            } else if postAd == "yes" {
                self.adType_post = true
            }
        }
        if let midAd = adsDict["mid"] as? String {
            if midAd == "no" {
                self.adType_mid = false
            } else if midAd == "yes" {
                self.adType_mid = true
                self.setUpMidAdsDictionary(adsDict as NSDictionary)
            }
        }
    }
    
    
    func getAdTagForPreRoll(_ strOffsetToCompare: String) -> String? {
        if let adsTagsDict = self.adsTagsDict {
            if let strPreAdTag = adsTagsDict["adTagPre"] as? String {
                let strCompleteAdTagUrl = K10Utility.completeUrlFor(strPreAdTag)
                return strCompleteAdTagUrl
            }
        }
        return nil
    }

    func getAdTagForMidRoll(_ strOffsetToCompare: String) -> String? {
        if let adsTagsDict = self.adsTagsDict {
            if let strMidAdTag = adsTagsDict["adTagMid"] as? String {
                let strCompleteAdTagUrl = K10Utility.completeUrlFor(strMidAdTag)
                return strCompleteAdTagUrl
            }
        }
        return nil
    }
    func getAdTagForPostRoll(_ strOffsetToCompare: String) -> String? {
        if let adsTagsDict = self.adsTagsDict {
            if let strPostAdTag = adsTagsDict["adTagPost"] as? String {
                let strCompleteAdTagUrl = K10Utility.completeUrlFor(strPostAdTag)
                return strCompleteAdTagUrl
            }
        }
        return nil
    }
    
    fileprivate func setUpMidAdsDictionary(_ adsDict: NSDictionary) {
        if let midAdOffsets = adsDict["offsets"] as? NSDictionary {
            if let midAdsLinearArray = midAdOffsets["linear"] as? [String] {
                for strLinearValue: String in midAdsLinearArray {
                    if let iLinearValue = Int(strLinearValue) {
                        // Time : status   -- yes for ad shown, no for ad not yet shown.
                        self.midRollAdTimeDict["Time_\(iLinearValue)"] = "no"
                    }
                    
                }
            }
        }
    }
    
    func mapFromVideoChannel(_ videoChannel: [String: AnyObject]) {
        if let strVideoTitle = videoChannel["title"] as? String {
            self.strVideoTitle = strVideoTitle
        }
        if let strVideoDescription = videoChannel["description"] as? String {
            self.strVideoDescription = strVideoDescription
        }
    }
    
    
    
    
//    //MARK: - DTSZVideoAPIDelegate methods
//    func didReceiveVideoData(infoDict: NSDictionary) {
//        self.mapFromDictionary(infoDict)
//    }
//    func didFailedAPICall() {
//        //        self.failedToReceiveData()
//    }
    
//    func getPaywallStatus() {
//        let paywallAPI: DTSZPaywallAPI = DTSZPaywallAPI()
//        paywallAPI.delegate = self
//        paywallAPI.getVideoPaywallStatus(self.videoId)
//    }
    
    
    //MARK: - request channel data
    func requestVideoInfo(_ completion: ((_ videoDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
//        if let strCategorySlug = self.strCategorySlug, let strChannelSlug = self.strChannelSlug, strCategorySlug != "" && strChannelSlug != "" {
////        if (self.slug != nil) {
//            let videoAPI: SPLTVideoAPI = SPLTVideoAPI()
//            videoAPI.delegate = self
//            videoAPI.getCategoryChannelVideo(strCategorySlug, strChannelSlug: strChannelSlug, strVideoId: self.videoId)
////        }
//        } else
        if let strVideoId = self.videoId {
            SPLTVideoAPI().getVideo(strVideoId, completion: { (videoDict) in
                    // Video dict
                    self.videoDict = videoDict
                    self.mapFromVideoDictionary(videoDict)
                    self.delegate?.didUpdateVideoData(videoDict)
                    completion?(videoDict)
                }, completionError: { (error) in
                    // Error
                    completionError?(NSError(domain: "DTSZVideo", code: 1, userInfo: nil))
            })
        }
    }

    
    func loadFullVideo(_ completion: ((_ videoDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        if let strVideoId = self.videoId {
            SPLTVideoAPI().getVideo(strVideoId, completion: { (videoDict) in
                // Video dict
                self.videoDict = videoDict
                self.mapFromVideoDictionary(videoDict)
                self.delegate?.didUpdateVideoData(videoDict)
                //completion?(videoDict)
                SPLTVideoProgressAPI().getVideoProgress(strVideoId, completion: { (responseDict) in
                    if let point = responseDict["point"] as? Int {
                        self.progressPoint = point
                    }
                    #if os(tvOS)
                        self.loadVideoAdTag(videoDict, completion: completion, completionError: completionError)
                    #else
                        completion?(videoDict)
                    #endif
                }, completionError: { (error) in
                    // error while updating video progress, but success to video data call.
                    #if os(tvOS)
                        self.loadVideoAdTag(videoDict, completion: completion, completionError: completionError)
                    #else
                        completion?(videoDict)
                    #endif
                })
            }, completionError: { (error) in
                // Error
                completionError?(NSError(domain: "DTSZVideo", code: 1, userInfo: nil))
            })
        } else {
            completionError?(NSError(domain: "DTSZVideo", code: 1, userInfo: nil))
        }
    }
    
    func loadVideoAdTag(_ videoDict: [String: AnyObject], completion: ((_ videoDict: [String: AnyObject]) -> Void)?, completionError: ((_ error: NSError) -> Void)?) {
        #if os(tvOS)
            if let strVideoId = self.videoId {
                SPLTAdsAPI().getAdTagForVideo(strVideoId, width: 1920, height: 1080, completion: { (adTagsDict) in
                    // success
                    self.mapFromVideoAdTagDict(adTagsDict)
                    completion?(videoDict)
                }, completionError: { (error) in
                    // error.
                    completion?(videoDict)
                })
            }
        #endif
    }
    

    //MARK: -
    //MARK: - extension SPLTVideoAPIDelegate
    func didReceiveVideoData(_ infoDict: [String: AnyObject]) {
        self.mapFromVideoDictionary(infoDict)
        self.delegate?.didUpdateVideoData(infoDict)
    }
    func didFailedVideoAPICall() {
        //        self.delegate?.didFailedChannelAPICall()
    }

    //MARK: -
    //MARK: - extension Video Ad tag mapping
    func mapFromVideoAdTagDict(_ adTagsDict: [String: AnyObject]) {
        self.adsTagsDict = adTagsDict
    }
    
    func updateVideoProgress() {
        if let strId = self.videoId {
            SPLTVideoProgressAPI().getVideoProgress(strId, completion: { (responseDict) in
                if let point = responseDict["point"] as? Int {
                    self.progressPoint = point
                    self.delegate?.didUpdateVideoProgress()
                }
            }, completionError: { (error) in
                //print(error)
            })
        }
    }
}




