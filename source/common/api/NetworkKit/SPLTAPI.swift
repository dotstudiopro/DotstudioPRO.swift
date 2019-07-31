//
//  SPLTAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 17/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

public enum SPLTRouter: URLConvertible {
    
    static let BUNDLE_IDENTIFIER = SPLTConfig.infoDictionaryBundleMain!["CFBundleIdentifier"] as! String
    static var BASE_URL = "https://api.myspotlight.tv" //"http://dev.api.myspotlight.tv"
    static let COUNTRY_CODE: String = (Locale.current as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String
    
//    static let baseUniversalURLString = "https://api.dotstudiopro.com/v2/\(universalKey)/json/videos"

    public static var API_KEY = ""

   public static var strAccessToken: String? {
        didSet {
            if let strAccessToken = SPLTRouter.strAccessToken {
                
                do {
                    let jwt = try decode(strAccessToken)
                    if let strCompanyId = jwt.body["iss"] as? String {
                        self.str_company_id = strCompanyId
                    }
                } catch {
                    print("Something went wrong while retrieving company id from access token!")
                }
                
                SPLTBaseAPI.spltTokenHandler = SPLTTokenHandler(
                    API_KEY: SPLTRouter.API_KEY, //"12345678",
                    baseURLString: SPLTRouter.BASE_URL, //baseURLString,
                    accessToken: strAccessToken, //"abcd1234",
                    clientToken: SPLTRouter.strClientToken //"ef56789a"
                )
            }
        }
    }
    public static var strClientToken: String? {
        didSet {
            SPLTUser.sharedInstance.updateUserId()
//            if (strClientToken == nil) {
//                SPLTUser.sharedInstance.userId = nil
//            } 
            if let strAccessToken = SPLTRouter.strAccessToken {
                SPLTBaseAPI.spltTokenHandler = SPLTTokenHandler(
                    API_KEY: SPLTRouter.API_KEY, //"12345678",
                    baseURLString: SPLTRouter.BASE_URL, //baseURLString,
                    accessToken: strAccessToken, //"abcd1234",
                    clientToken: SPLTRouter.strClientToken //"ef56789a"
                )
            }
        }
    }
    
    static var str_company_id: String?
    
    case root
    case token
    case refreshToken
    case homepageapi(String)
    case categories
    case channels
    case channels_Lean
    case channel(String)
    case channel_Lean(String)
    case channel_Partial(String)
    case categoryChannels(String)
    case categoryChannelsLean(String)
    case purchasedCategoryChannel(String)
    case categoryChannel(String, String)
    case categoryChannelVideo(String, String, String)
    case catChannelVideo(String, String)
    
//    case register
//    case login
    case userDetail
    case purchaseVideo
    case videoPurchaseStatus
    case searchSuggesion(String)
    case searchTerm(String)
    case searchVideoTerm(String)
    case orderDetail
//    case forgotPassword
    case changePassword
    case getProfile
    case updateProfile
    case updateAvatar
    case getAvatarImage(String)
    case getChannelInfo(String)
//    case videoDetail(String)
    case videoPlay2(String)
    case videoPlay2FromVideoSlug(String)
    case setVideoProgress(String, Int)
    case getVideoProgress(String)
    case getVideoProgressForVideos
    case getResumptionVideos
    case getAdTags(String, Int, Int)
    case searchChannels
    case companyChannels(String)
    case playlistDetail(String)
    case spotlightAPICategories
    case spotlightAPIChannels
    case play_TIME_API
    case player_API
    case recommandationVideo(String, Int, Int)
    case recommandationChannel(String, Int, Int)
//    case dtsz_PLAYER_ANALYTICS
//    case dtsz_SHARE_ANALYTICS
    case testingAnalytics
    case latestAppVersion
    case latestAppVersionByPackage(String)
    case subscriptionAppleReceiptPost
    case checkSubscriptionStatus(String)
    case getSubscriptionPlans
    case getActiveSubscriptions
    case addChannelToWatchlist
    case getWatchlistChannels
    case deleteWatchlistChannel
    case getNewDeviceCode
    case verifyDeviceCode(String)
    case scheduledPrograms
    
    // MARK: URLStringConvertible
    var URLString: String {
        let path: String = {
            switch self {
            case .root:
                return "/"
            case .token:
                return SPLTRouter.BASE_URL + "/token"
            case .refreshToken:
                return SPLTRouter.BASE_URL + "/users/token/refresh"
            case .homepageapi(let strPlatform):
                return SPLTRouter.BASE_URL + "/homepage/" + SPLTRouter.COUNTRY_CODE + "/\(strPlatform)"
            case .categories:
                return SPLTRouter.BASE_URL + "/categories/" + SPLTRouter.COUNTRY_CODE
            case .channels:
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE
            case .channels_Lean:
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "?detail=lean"
            case .channel(let strChannelSlug):
                return SPLTRouter.BASE_URL + "/channel/" + SPLTRouter.COUNTRY_CODE + "/\(strChannelSlug)"
            case .channel_Lean(let strChannelSlug):
                return SPLTRouter.BASE_URL + "/channel/" + SPLTRouter.COUNTRY_CODE + "/\(strChannelSlug)?detail=lean"
            case .channel_Partial(let strChannelSlug):
                return SPLTRouter.BASE_URL + "/channel/" + SPLTRouter.COUNTRY_CODE + "/\(strChannelSlug)?detail=partial"
            case .categoryChannels(let strCategorySlug):
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "/\(strCategorySlug)"
            case .categoryChannelsLean(let strCategorySlug):
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "/\(strCategorySlug)?detail=lean"
            case .purchasedCategoryChannel(let strPurchasedCategoryChannelSlug):
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "/" + strPurchasedCategoryChannelSlug
            case .categoryChannel(let strCategorySlug, let strChannelSlug):
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "/" + strCategorySlug + "/" + strChannelSlug
            case .categoryChannelVideo(let strCategorySlug, let strChannelSlug, let strVideoId):
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "/" + strCategorySlug + "/" + strChannelSlug + "/play/" + strVideoId
            case .catChannelVideo(let strCategoryChannelSlug, let strVideoId):
                return SPLTRouter.BASE_URL + "/channels/" + SPLTRouter.COUNTRY_CODE + "/" + strCategoryChannelSlug + "/play/" + strVideoId
//            case .register:
//                return "https://api.dotstudiopro.com/v2/universalapi/customer_register"
//            case .login:
//                return SPLTRouter.BASE_URL + "/users/login"
            case .userDetail:
                return SPLTRouter.BASE_URL + "/users/details"
            case .purchaseVideo:
                return SPLTRouter.BASE_URL + "/users/payment/apple"
            case .videoPurchaseStatus:
                return SPLTRouter.BASE_URL + "/users/payment/status"
            case .searchSuggesion(let strSearchTerm):
                let searchSuggesionUrl:String = SPLTRouter.BASE_URL + "/search/s/?q=\(strSearchTerm)"
                return searchSuggesionUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            case .searchTerm(let strSearchTerm):
                let searchTermUrl:String = SPLTRouter.BASE_URL + "/search/?q=\(strSearchTerm)"
                return searchTermUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            case .searchVideoTerm(let strSearchTerm):
                let searchVideoTermUrl = SPLTRouter.BASE_URL + "/search/videos/?q=\(strSearchTerm)"
                return searchVideoTermUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            case .orderDetail:
                return SPLTRouter.BASE_URL + "/users/orders/history"
//            case .forgotPassword:
//                return "https://api.dotstudiopro.com/v2/universalapi/forgotpassword"
            case .changePassword:
                return SPLTRouter.BASE_URL + "/users/password"
            case .getProfile:
                return "https://api.dotstudiopro.com/v2/universalapi/customer_details"
            case .updateProfile:
                return "https://api.dotstudiopro.com/v2/universalapi/customer_details/edit"
            case .updateAvatar:
                return SPLTRouter.BASE_URL + "/users/avatar/"
            case .getAvatarImage(let strUserId):
                return "http://myspotlight.tv/user/avatar/\(strUserId)"
            case .getChannelInfo(let channelSlug):
                return "http://myspotlight.tv/json/channels/\(channelSlug)"
//            case .videoDetail(let videoId):
//                return SPLTRouter.BASE_URL + "/video/play/\(videoId)"
            case .videoPlay2(let videoId):
                return SPLTRouter.BASE_URL + "/video/play2/\(videoId)"
            case .videoPlay2FromVideoSlug(let strVideoSlug):
                return SPLTRouter.BASE_URL + "/video/play2-by-slug/\(strVideoSlug)"
            case .setVideoProgress(let videoId, let videoDuration):
                return SPLTRouter.BASE_URL + "/users/videos/point/" + videoId + "/\(videoDuration)"
            case .getVideoProgress(let videoId):
                return SPLTRouter.BASE_URL + "/users/videos/point/" + videoId
            case .getVideoProgressForVideos:
                return SPLTRouter.BASE_URL + "/users/videos/points"
            case .getResumptionVideos:
                return SPLTRouter.BASE_URL + "/users/resumption/videos"
            case .getAdTags(let videoId, let width, let height):
                var strAdTagUrl = "/vmap/adtag/\(videoId)/\(width)/\(height)"
//                #if os(iOS)
//                    strAdTagUrl += "?device_type=ios"
//                #elseif os(tvOS)
//                    strAdTagUrl += "?device_type=apple_tv"
//                #endif
                return SPLTRouter.BASE_URL + strAdTagUrl
            case .searchChannels:
                return "http://myspotlight.tv/m/search"
            case .companyChannels(let companyName):
                return "http://myspotlight.tv/company/\(companyName)/json"
            case .playlistDetail(let playlistId):
                return "https://api.dotstudiopro.com/v2/cc89512b/json/playlists/\(playlistId)"
            case .spotlightAPICategories:
                return "http://myspotlight.tv/categories/list"
            case .spotlightAPIChannels:
                return "http://myspotlight.tv/json/channels"
            case .play_TIME_API:
                return "https://collector.dotstudiopro.com/plays"
            case .player_API:
                return "https://collector.dotstudiopro.com/players"
                
            case .recommandationVideo(let videoId, let size, let from):
                return SPLTRouter.BASE_URL + "/search/recommendation?q=\(videoId)&size=\(size)&from=\(from)"
            case .recommandationChannel(let channelId, let size, let from):
                return SPLTRouter.BASE_URL + "/search/recommendation/channel?q=\(channelId)&size=\(size)&from=\(from)"
            case .testingAnalytics:
                return SPLTRouter.BASE_URL + "/testing/analytics"
            case .latestAppVersion:
                #if os(iOS)
                    return SPLTRouter.BASE_URL + "/latestAppVersion/ios"
                #else
                    return SPLTRouter.BASE_URL + "/latestAppVersion/apple_tv"
                #endif
            case .latestAppVersionByPackage(let strPackageId):
                #if os(iOS)
                return SPLTRouter.BASE_URL + "/latestAppVersion/package/ios/\(strPackageId)"
                #else
                return SPLTRouter.BASE_URL + "/latestAppVersion/package/apple_tv/\(strPackageId)"
                #endif
            case .subscriptionAppleReceiptPost:
                return SPLTRouter.BASE_URL + "/subscriptions/apple/customer/parse"
            case .checkSubscriptionStatus(let channelId):
                return SPLTRouter.BASE_URL + "/subscriptions/check/\(channelId)"
            case .getSubscriptionPlans:
                return SPLTRouter.BASE_URL + "/subscriptions/summary"
            case .getActiveSubscriptions:
                return SPLTRouter.BASE_URL + "/subscriptions/users/active_subscriptions"
            case .addChannelToWatchlist:
                return SPLTRouter.BASE_URL + "/watchlist/channels/add"
            case .getWatchlistChannels:
                return SPLTRouter.BASE_URL + "/watchlist/channels"
            case .deleteWatchlistChannel:
                return SPLTRouter.BASE_URL + "/watchlist/channels/delete"
            case .getNewDeviceCode:
                return SPLTRouter.BASE_URL + "/device/codes/new"
            case .verifyDeviceCode(let verificationCode):
                return SPLTRouter.BASE_URL + "/device/codes?code=\(verificationCode)"
            case .scheduledPrograms:
                return SPLTRouter.BASE_URL + "/live/programming/US/live?limit=200"

            }
        }()
        return path
    }
    
    public func asURL() throws -> URL {
        let result: (path: String, parameters: Parameters) = {
            switch self {
                case .root:
                    return ("/", [:]) //, ["q": query, "offset": SPLTRouter.perPage * page])
                case .token:
                    return ("/token", [:]) //, ["q": query, "offset": SPLTRouter.perPage * page])
                case .refreshToken:
                    return ("/users/token/refresh", [:])
                case .homepageapi(let strPlatform):
                    return ("/homepage/" + SPLTRouter.COUNTRY_CODE + "/\(strPlatform)", [:])
                case .categories:
                    return ("/categories/\(SPLTRouter.COUNTRY_CODE)", [:])
                case .channels:
                    return ("/channels/\(SPLTRouter.COUNTRY_CODE)", [:])
                case .channels_Lean:
                    let finalUrl = "/channels/\(SPLTRouter.COUNTRY_CODE)?detail=lean"
                    return (finalUrl, [:])
                case .channel(let strChannelSlug):
                    return ("/channel/\(SPLTRouter.COUNTRY_CODE)/\(strChannelSlug)", [:])
                case .channel_Lean(let strChannelSlug):
                    return ("/channel/\(SPLTRouter.COUNTRY_CODE)/\(strChannelSlug)?detail=lean", [:])
                case .channel_Partial(let strChannelSlug):
                    return ("/channel/\(SPLTRouter.COUNTRY_CODE)/\(strChannelSlug)?detail=partial", [:])
                case .categoryChannels(let strCategorySlug):
                    return ("/channels/\(SPLTRouter.COUNTRY_CODE)/\(strCategorySlug)", [:])
                case .categoryChannelsLean(let strCategorySlug):
                    let finalUrl = "/channels/\(SPLTRouter.COUNTRY_CODE)/\(strCategorySlug)?detail=lean" //?detail=lean"
                    return (finalUrl, [:])
                case .purchasedCategoryChannel(let strPurchasedCategoryChannelSlug):
                    return ("/channels/\(SPLTRouter.COUNTRY_CODE)/\(strPurchasedCategoryChannelSlug)", [:])
                case .categoryChannel(let strCategorySlug, let strChannelSlug):
                    return ("/channels/\(SPLTRouter.COUNTRY_CODE)/\(strCategorySlug)/\(strChannelSlug)", [:])
                case .categoryChannelVideo(let strCategorySlug, let strChannelSlug, let strVideoId):
                    return ("/channels/\(SPLTRouter.COUNTRY_CODE)/\(strCategorySlug)/\(strChannelSlug)/play/\(strVideoId)", [:])
                case .catChannelVideo(let strCategoryChannelSlug, let strVideoId):
                    return ("/channels/\(SPLTRouter.COUNTRY_CODE)/\(strCategoryChannelSlug)/play/\(strVideoId)", [:])
//                case .register:
//                    return "https://api.dotstudiopro.com/v2/universalapi/customer_register"
//                case .login:
//                    return SPLTRouter.BASE_URL + "/users/login"
                case .userDetail:
                    return ("/users/details", [:])
                case .purchaseVideo:
                    return ("/users/payment/apple", [:])
                case .videoPurchaseStatus:
                    return ("/users/payment/status", [:])
                case .searchSuggesion(let strSearchTerm):
                    let searchSuggesionTermUrl = "/search/s/?q=\(strSearchTerm)"
                    let finalUrl = searchSuggesionTermUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    return (finalUrl, [:])
                case .searchTerm(let strSearchTerm):
                    let searchTermUrl = "/search/?q=\(strSearchTerm)"
                    let finalUrl = searchTermUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    return (finalUrl, [:])
                case .searchVideoTerm(let strSearchTerm):
                    let searchVideoTermUrl = "/search/videos?q=\(strSearchTerm)"
                    let finalUrl = searchVideoTermUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                    return (finalUrl, [:])
                case .orderDetail:
                    return ("/users/orders/history", [:])
                case .getProfile:
                    return ("/customer_details", [:])
                case .updateProfile:
                    return ("/customer_details/edit", [:])
                case .updateAvatar:
                    return ("/users/avatar", [:])
                case .getAvatarImage(let strUserId):
                    return ("/user/avatar/\(strUserId)", [:])
//                    return "http://myspotlight.tv/user/avatar/\(strUserId)"
//                case .getChannelInfo(let channelSlug):
//                    return "http://myspotlight.tv/json/channels/\(channelSlug)"
                case .videoPlay2(let videoId):
                    return ("/video/play2/\(videoId)", [:])
                case .videoPlay2FromVideoSlug(let strVideoSlug):
                    return ("/video/play2-by-slug/\(strVideoSlug)", [:])
                case .setVideoProgress(let videoId, let videoDuration):
                    return ("/users/videos/point/\(videoId)/\(videoDuration)", [:])
                case .getVideoProgress(let videoId):
                    return ("/users/videos/point/\(videoId)", [:])
            case .getVideoProgressForVideos:
                    return ("/users/videos/points", [:])
                case .getResumptionVideos:
                    return ("/users/resumption/videos", [:])
                case .getAdTags(let videoId, let width, let height):
                    var strAdTagUrl = "/vmap/adtag/\(videoId)/\(width)/\(height)"
//                    #if os(iOS)
//                        strAdTagUrl += "?device_type=ios"
//                    #elseif os(tvOS)
//                        strAdTagUrl += "?device_type=apple_tv"
//                    #endif
                    return (strAdTagUrl, [:])
                case .recommandationVideo(let videoId, let size, let from):
                    return ("/search/recommendation?q=\(videoId)&size=\(size)&from=\(from)", [:])
                case .recommandationChannel(let channelId, let size, let from):
                    return ("/search/recommendation/channel?q=\(channelId)&size=\(size)&from=\(from)", [:])
                case .testingAnalytics:
                    return ("/testing/analytics", [:])
                case .latestAppVersion:
                    #if os(iOS)
                        return ("/latestAppVersion/ios", [:])
                    #else
                        return ("/latestAppVersion/apple_tv", [:])
                    #endif
                case .latestAppVersionByPackage(let strPackageId):
                    #if os(iOS)
                        return ("/latestAppVersion/package/ios/\(strPackageId)", [:])
                    #else
                        return ("/latestAppVersion/package/apple_tv/\(strPackageId)", [:])
                    #endif
                case .subscriptionAppleReceiptPost:
                    return ("/subscriptions/apple/customer/parse", [:])
                case .checkSubscriptionStatus(let channelId):
                    return ("/subscriptions/check/\(channelId)", [:])
                case .getSubscriptionPlans:
                    return ("/subscriptions/summary", [:])
                case .getActiveSubscriptions:
                    return ("/subscriptions/users/active_subscriptions", [:])
                case .addChannelToWatchlist:
                    return ("/watchlist/channels/add", [:])
                case .getWatchlistChannels:
                    return ("/watchlist/channels", [:])
                case .deleteWatchlistChannel:
                    return ("/watchlist/channels/delete", [:])
                case .getNewDeviceCode:
                    return ("/device/codes/new", [:])
                 case .verifyDeviceCode(let verificationCode):
                    return ("/device/codes?code=\(verificationCode)", [:])
                case .scheduledPrograms:
                    return ("/live/programming/US/live?limit=200", [:])
                default:
                    return ("", [:])
            }
        }()

        let strBaseUrl = SPLTRouter.BASE_URL
        let strUrl = strBaseUrl.appending(result.path)
        let strFinalUrl = strUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = try strFinalUrl.asURL()
        return url
        
//        return searchSuggesionUrl.addingPercentEscapes(using: String.Encoding.utf8)!

//        let url = try SPLTRouter.BASE_URL.asURL()
//        let finalUrl = url.appendingPathComponent(result.path)
//        return try finalUrl
    }


}


open class SPLTAPI {
    
    // With Block methods
//    open func regenerateAccessTokenAndGetJSONResponse(_ strUrl: String, completion: @escaping (_ dictionary: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//        SPLTTokenAPI().getToken { (strToken) -> Void in
//            self.getJSONResponse(strUrl, completion: completion, completionError: completionError)
//        }
//    }
    
//    open func getJSONResponse(_ strUrl: String, completion: @escaping (_ dictionary: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//
//        if (SPLTRouter.strAccessToken == nil) {
//            self.regenerateAccessTokenAndGetJSONResponse(strUrl, completion: completion, completionError: completionError)
//            return
//        }
//
//        //let strUrl: URLConvertible = SPLTRouter.categories.URLString
//        let headers = [
//            "x-access-token": SPLTRouter.strAccessToken!,
//            ]
//
//            SPLTBaseAPI.sessionManager.request(SPLTRouter.categories, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
//                        if let httpURLResponse = response.response {
//                            if (httpURLResponse.statusCode == 403) {
//                                // regenerate accesstoken
//                                self.regenerateAccessTokenAndGetJSONResponse(strUrl, completion: completion, completionError: completionError)
//                                return
//                            }
//                        }
//                        if (response.result.value != nil) {
//                            if let infoDict = response.result.value as? [String: AnyObject] {
//                                completion(infoDict)
//                            }
//                        }
//                        completionError(NSError(domain: "SPLTAPI", code: 1, userInfo: nil))
//            }
//    }
}






