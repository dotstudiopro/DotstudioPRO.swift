//
//  DTSZAnalyticsAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 16/09/15.
//  Copyright (c) 2015 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

enum EnumPlayAnalytics : String {
    case    ON_PLAY = "onPlay",
            ON_PAUSE = "onPause",
            ON_SEEK = "onSeek",
            ON_STOP = "onStop",
            ON_COMPLETE = "onComplete"
    
//            ON_RESUME = "onResume",
//            LEAVE_PAGE = "leavePage",
//            ON_COMPLETE = "onComplete",
//            ON_FULL_SCREEN = "onFullScreen",
//            ON_AD_START = "onAdStart",
//            ON_AD_COMPLETE = "onAdComplete"
    
}

enum EnumPlayerAnalytics : String {
    case    ON_PAGE_LOAD = "pageLoad",
            ON_DISPLAY_CLICK = "onDisplayClick",
//            ON_BEFORE_PLAY = "onBeforePlay",
//            ON_BUFFER = "onBuffer",
            ON_VIEW = "onView",
            ON_PLAY = "onPlay",
            ON_PAUSE = "onPause",
            ON_SEEK = "onSeek",
            ON_COMPLETE = "onComplete"
    
//    ON_PAUSE = "OnPause",
//    ON_RESUME = "OnResume",
//    ON_STOP = "OnStop",
//    ON_SEEK = "OnSeek",
//    LEAVE_PAGE = "leavePage",
//    ON_COMPLETE = "onComplete",
//    ON_FULL_SCREEN = "OnFullScreen",
//    ON_AD_START = "onAdStart",
//    ON_AD_COMPLETE = "onAdComplete"
    
}



//let DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE_APP_NAME = "spotlight_tvos"
#if APP_BTVR
    let DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE_APP_NAME = "btvr"
#elseif APP_FUBU
    let DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE_APP_NAME = "fubu"
#else
    let DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE_APP_NAME = "spotlight"
#endif



#if os(tvOS)
    let DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE = "\(DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE_APP_NAME)_tvos"
#else
    let DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE = "\(DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE_APP_NAME)_ios"
#endif












public class DTSZAnalyticsAPI {
    
//    public var delegate: DTSZAnalyticsAPIDelegate?
    static let sharedInstance = DTSZAnalyticsAPI()
    
    public init() {
    }
    
    static var customer_id: String?
    static var email: String?
    public func setCustomerId() -> String? {
//        var customer_id: String?
        
//        if let loginData: [String: AnyObject] = NSUserDefaults.standardUserDefaults().valueForKey("LoginData") as? [String: AnyObject] {
//            if let strCustomerId: String = loginData["_id"] as? String {
//                DTSZAnalyticsAPI.customer_id = strCustomerId
//            }
//            if let strEmail: String = loginData["email"] as? String {
//                DTSZAnalyticsAPI.email = strEmail
//            }
//        }
        
        if let strClientToken = SPLTRouter.strClientToken {
            do {
                let segments = strClientToken.components(separatedBy: ".")
                if segments.count == 3 {
//                    let headerSegment = segments[0]
                    if let payloadData = base64decode(segments[1]) {
//                        var datastring = String(data: payloadData, encoding: NSUTF8StringEncoding)
//                        print(datastring)
                        if let jsonDict = try JSONSerialization.jsonObject(with: payloadData, options: .mutableContainers) as? [String: AnyObject] {
                            if let contextDict = jsonDict["context"] as? [String: AnyObject] {
                                if let strCustomerId = contextDict["id"] as? String {
                                    DTSZAnalyticsAPI.customer_id = strCustomerId
                                    return strCustomerId
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Failed to decode JWT: \(error)")
            }
        }
        
        return nil
        
    }
    
    
//    event=onPlay&start=0&end=0&page=roku&pageId=4124C7093683&videoId=55b72c3097f815fd215d6cdf
    public func sendPlaysAnalyticsEvent(eventName: String, companyId: String, channelId: String, videoId: String, startTime: String, endTime: String) {
        
        // MARK: URLStringConvertible
        
//        if (DTSZAnalyticsAPI.customer_id == nil) {
//            self.setCustomerId()
//        }
//        print(DTSZAnalyticsAPI.customer_id)
//        if (DTSZAnalyticsAPI.customer_id == nil) {
//            return
//        }
        
        let parameters: [String:AnyObject]? = [
            "event": eventName as AnyObject, //"onReady",
            "page": DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE as AnyObject, //"spotlight_ios",
            "videoId": videoId as AnyObject,
            "start": startTime as AnyObject,
            "end": endTime as AnyObject
        ]
        
//        let URLString: URLStringConvertible = SPLTRouter.PLAY_TIME_API
        
        SPLTBaseAPI.sessionManager.request(SPLTFullPathRouter.play_TIME_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            if (response.error != nil) {
                print("error")
            } else {
                //print("inserted successfully")
            }
        })
        
        
        
    }
    
//    =>Event=pageLoad&PageType=Roku&VideoId=55b72c3097f815fd215d6cdf&CompanyId=54987ed197f8156178fdbc2d&product=&UserId=&customer=&State=PLAYING&userAgent=&geolocation[ip]=192.168.0.104
    public func sendPlayerAnalyticsEvent(eventName: String, companyId: String, channelId: String, videoId: String) {
        
//        var parameters: [String:AnyObject] = [:]
        // MARK: URLStringConvertible
//        if let customer_id = DTSZAnalyticsAPI.customer_id {
//            parameters["UserId"] = customer_id
//            parameters["customer"] = customer_id
//        } else {
//            if let strCustomerId = self.setCustomerId() {
//                parameters["UserId"] = strCustomerId
//                parameters["customer"] = strCustomerId
//            } else {
//                return
//            }
//        }
//        if (DTSZAnalyticsAPI.customer_id == nil) {
//            self.setCustomerId()
//        }
//        if (DTSZAnalyticsAPI.customer_id == nil) {
//            return
//        }
        
        
        
        
        var parameters: [String:AnyObject] = [
            "Event": eventName as AnyObject, //"onReady",
            "PageType": DTSZ_ANALYTICS_APP_PLATFORM_PAGETYPE as AnyObject, //"spotlight_ios",
            "VideoId": videoId as AnyObject,
            "ChannelId": channelId as AnyObject,
            "CompanyId": companyId as AnyObject,
//            "UserId": DTSZAnalyticsAPI.customer_id!,
//            "customer": DTSZAnalyticsAPI.customer_id!,
//            "email": DTSZAnalyticsAPI.email!,
            "Manufacturer": "Apple" as AnyObject
        ]
        
        if (UIDevice.current.userInterfaceIdiom == .pad) {
            parameters["Device"] = "iPad" as AnyObject?
        } else {
            parameters["Device"] = "iPhone" as AnyObject?
        }
        
        if let customer_id = DTSZAnalyticsAPI.customer_id {
            parameters["UserId"] = customer_id as AnyObject?
            parameters["customer"] = customer_id as AnyObject?
        } else {
            if let strCustomerId = self.setCustomerId() {
                parameters["UserId"] = strCustomerId as AnyObject?
                parameters["customer"] = strCustomerId as AnyObject?
            } else {
                return
            }
        }
        
        
        
//        let URLString: URLStringConvertible = SPLTRouter.PLAYER_API
        
        SPLTBaseAPI.sessionManager.request(SPLTFullPathRouter.player_API, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).response(completionHandler: { (response) in
            print("Request: \(response.request)")
            print("Response: \(response.response)")
            print("Error: \(response.error)")
            if (response.error != nil) {
                print("error")
            } else {
                //print("inserted successfully")
            }
        })
        
    }
    
    
    
}
