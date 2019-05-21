//
//  SPLTAnalyticsEvents.swift
//  DotstudioPRO
//
//  Created by ketan on 08/06/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import UIKit

public enum SPLTAnalyticsPageType: String {
    case android = "android"
    case appletv = "appletv"
    case channel = "channel"
    case embed = "embed"
    case facebook = "facebook"
    case iphone = "iphone"
    case roku = "roku"
    case spotlight = "spotlight"
}

public enum SPLTAnalyticsPlayerVersion: String {
    //case android = "android_v1"
    case ios = "ios_v1"
    case tvos = "tvos_v1"
}

open class SPLTAnalyticsEventsAPIObject: NSObject {
    #if os(tvOS)
    public let analyticsPageType: SPLTAnalyticsPageType = SPLTAnalyticsPageType.appletv
    public let player_version: SPLTAnalyticsPlayerVersion = .tvos
    static public let mobileDeviceInfoDict: [String: Any] = [
            "type" : "ott" as AnyObject,//"phone",
            "manufacturer" : "apple" as AnyObject,
            "os_version" : UIDevice.current.systemVersion as AnyObject,
            "model" : "appletv" as AnyObject, //UIDevice.currentDevice().model,
            "app_name" : SPLTConfig.APPNAME!, //"spotlight",
            "app_version" : SPLTConfig.infoDictionaryBundleMain!["CFBundleShortVersionString"] as! String as AnyObject //"1.0.0"
        ]
    #else
    public let analyticsPageType: SPLTAnalyticsPageType = SPLTAnalyticsPageType.iphone
    public let player_version: SPLTAnalyticsPlayerVersion = .ios
    static public let mobileDeviceInfoDict: [String: Any] = [
            "type" : UIDevice.current.userInterfaceIdiom == .phone ? "phone" : "tablet" as AnyObject,//"phone",
            "manufacturer" : "apple",
            "os_version" : UIDevice.current.systemVersion,
            "model" : UIDevice.current.model,
            "app_name" : SPLTConfig.APPNAME!, //"spotlight",
            "app_version" : SPLTConfig.infoDictionaryBundleMain!["CFBundleShortVersionString"] as! String //"1.0.0"
        ]
    //            "mobile_device_info" : {
    //                "type": "phone",
    //                "manufacturer" : "apple",
    //                "os_version": "6.1.0",
    //                "model" : "iphone",
    //                "app_name": "spotlight",
    //                "app_version": "1.1"
    //            },
    #endif

    let date: Date = Date()
    open var first_event: Date?
    open var last_update: Date?
    open var last_sent: Date?
    open var session_id: String?
    
    
    open var pageChannelId: String?
    open var pageVideoId: String?
    open var pageVideoCompanyId: String?
    open var pagePlaylistId: String?
    open var pageCompanyId: String?
//    var analyticsPageType: SPLTAnalyticsPageType?
    
    
    open var analyticsUser: SPLTUser?
    open var analyticsEvents: [SPLTAnalyticsEvent] = []
    
    init(session_id: String?, last_sent: Date?, pageChannelId: String?, pageVideoId: String, pageVideoCompanyId: String, pagePlaylistId: String?, pageCompanyId: String) {
        super.init()
        self.session_id = session_id
        self.last_sent = last_sent
        self.pageChannelId = pageChannelId
        self.pageVideoId = pageVideoId
        self.pageVideoCompanyId = pageVideoCompanyId
        self.pagePlaylistId = pagePlaylistId
        self.pageCompanyId = pageCompanyId
    }
    init(analyticsEventsAPIObject: SPLTAnalyticsEventsAPIObject) {
        super.init()
        self.pageChannelId = analyticsEventsAPIObject.pageChannelId
        self.pageVideoId = analyticsEventsAPIObject.pageVideoId
        self.pageVideoCompanyId = analyticsEventsAPIObject.pageVideoCompanyId
        self.pagePlaylistId = analyticsEventsAPIObject.pagePlaylistId
        self.pageCompanyId = analyticsEventsAPIObject.pageCompanyId
    }
    
    
    open func toJsonDict() -> [String: AnyObject] {
        var jsonDict: [String: AnyObject] = [
            "date" : K10Utility.toAnalyticsJsonDateString(self.date) as AnyObject
        ]
        if let first_event = self.first_event {
            jsonDict["first_event"] = K10Utility.toAnalyticsJsonDateString(first_event) as AnyObject?
        }
        if let last_update = self.last_update {
            jsonDict["last_update"] = K10Utility.toAnalyticsJsonDateString(last_update) as AnyObject?
        }
        if let last_sent = self.last_sent {
            jsonDict["last_sent"] = K10Utility.toAnalyticsJsonDateString(last_sent) as AnyObject?
        }

        if let session_id = self.session_id {
            jsonDict["session_id"] = session_id as AnyObject?
        }
            var pageDict: [String: AnyObject] = [:]
                if let pageChannelId = self.pageChannelId {
                    pageDict["channel_id"] = pageChannelId as AnyObject?
                } else {
                    pageDict["channel_id"] = "" as AnyObject
                }
                var pageVideoDict: [String: AnyObject] = [:]
                if let pageVideoId = self.pageVideoId {
                    pageVideoDict["id"] = pageVideoId as AnyObject?
                }
                if let pageVideoCompanyId = self.pageVideoCompanyId {
                    pageVideoDict["company_id"] = pageVideoCompanyId as AnyObject?
                }
            pageDict["video"] = pageVideoDict as AnyObject?
            if let pagePlaylistId = self.pagePlaylistId {
                pageDict["playlist_id"] = pagePlaylistId as AnyObject?
            }
            if let pageCompanyId = self.pageCompanyId {
                pageDict["company_id"] = pageCompanyId as AnyObject?
            }
            pageDict["page_type"] = self.analyticsPageType.rawValue as AnyObject?
            pageDict["player_version"] = self.player_version.rawValue as AnyObject?
            pageDict["mobile_device_info"] = SPLTAnalyticsEventsAPIObject.mobileDeviceInfoDict as AnyObject?
        jsonDict["page"] = pageDict as AnyObject?
        
        // add User Dictionary
        jsonDict["user"] = SPLTUser.sharedInstance.toJsonDict() as AnyObject?
        // add all event objects
        
        var eventsDict: [[String: Any]] = []
        for analyticsEvent in self.analyticsEvents {
            eventsDict.append(analyticsEvent.toJsonDict())
        }
        if eventsDict.count > 0 {
            jsonDict["events"] = eventsDict as AnyObject?
        }
        
        
        return jsonDict
    }
    
    open func addEvent(_ analyticsEvent: SPLTAnalyticsEvent) {
        if (self.first_event == nil) {
            self.first_event = analyticsEvent.date as Date
        }
        self.last_update = analyticsEvent.date as Date
        self.analyticsEvents.append(analyticsEvent)
    }
}



//{
//    "date": "2016-01-01T00:00:00-00:00",
//    "first_event" : "2016-01-01T00:00:11-00:00",
//    "last_update": "2016-01-01T00:00:10-00:00",
//    "session_id": "46cd6c1e-2cd4-11e6-b67b-9e71128cae77",
//    "page": {
//        "channel_id": "123456789",
//        "video" : {
//            "id" : "123456789",
//            "company_id" : "123456789"
//        },
//        "playlist_id": "123456789",
//        "company_id": "123456789",
//        "page_type": "channel",
//        "url": "https://example.dotstudiopro.com/channel/example",
//        "player_version": "JW7"
//    },
//    "user": {
//        "id": "123456789",
//        "ua": "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36",
//        "location": {
//            "isocode": "CA",
//            "country": "Canada",
//            "state": "BC",
//            "city": "Vancouver",
//            "postal": "V5V0A0",
//            "geometry": {
//                "coordinates": [49.2827, 123.1207]
//            }
//        }
//    },



