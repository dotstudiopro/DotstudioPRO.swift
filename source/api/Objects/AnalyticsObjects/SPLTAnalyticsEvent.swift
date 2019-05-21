//
//  SPLTAnalyticsEvent.swift
//  DotstudioPRO
//
//  Created by ketan on 08/06/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation

public enum SPLTAnalyticsEventCategory: String {
    case advertising = "advertising"
    case closed_captioning = "closed_captioning"
    case playback = "playback"
    case player_setup = "player_setup"
    case quality = "quality"
}

public enum SPLTAnalyticsEventType: String {
    
    case player_setup_ready = "ready"
    case player_setup_error = "setup_error"
    case player_setup_resize = "resize"
    
    
    case first_frame = "first_frame"
    case play = "play"
    case pause = "pause"
    case complete = "complete"
    case media_error = "media_error"
    case seek = "seek"
    case resume_after_seek = "resume_after_seek"
    case end_playback = "end_playback"
    case first_quartile = "first_quartile"
    case second_quartile = "second_quartile"
    case third_quartile = "third_quartile"
    
    case ad_click = "ad_click"
    case ad_skip = "ad_skip"
    case ad_complete = "ad_complete"
    case ad_request = "ad_request"
    case ad_loaded = "ad_loaded"
    case ad_impression = "ad_impression"
    case ad_error = "ad_error"

}

open class SPLTAnalyticsEventTime: NSObject {
    open var duration: Int = 0
    open var position: Int = 0
    open var position_end: Int?
    public init(duration: Int, position: Int, position_end: Int?) {
        super.init()
        self.duration = duration
        if (position > duration) {
            self.position = duration
        } else {
            self.position = position
        }
        self.position_end = position_end
    }
    open func toJsonDict() -> [String: Any] {
        var jsonDict = [
            "duration" : self.duration,
            "position" : self.position
        ]
        if let position_end = self.position_end {
            jsonDict["position_end"] = position_end
        }
        return jsonDict as [String : AnyObject]
    }
}

open class SPLTAnalyticsEvent: NSObject {

//    {
//        "date": "2016-01-01T00:00:15-00:00",
//        "category": "playback",
//        "type": "pause",
//        "message" : "",
//        "time": {
//            "duration": 500,
//            "position": 200
//        },
//        "event": {
//            "e" : {
//                "oldstate" : "playing"
//            }
//        }
//    }
    
    public let date: Date = Date()
    open var analyticsEventCategory: SPLTAnalyticsEventCategory?
    open var analyticsEventType: SPLTAnalyticsEventType?
    open var message: String?
    open var analyticsEventTime: SPLTAnalyticsEventTime?
    
    
    public init(analyticsEventCategory: SPLTAnalyticsEventCategory, analyticsEventType: SPLTAnalyticsEventType, duration: Int, position: Int, position_end: Int?, message: String?) {
        super.init()
        self.analyticsEventCategory = analyticsEventCategory
        self.analyticsEventType = analyticsEventType
        self.message = message
        self.analyticsEventTime = SPLTAnalyticsEventTime(duration: duration, position: position, position_end: position_end)
    }
    
    open func toJsonDict() -> [String: Any] {
        var jsonDict: [String: Any] = [
            "date" : K10Utility.toAnalyticsJsonDateString(self.date)
        ]
        if let analyticsEventCategory = self.analyticsEventCategory {
            jsonDict["category"] = analyticsEventCategory.rawValue
        }
        if let analyticsEventType = self.analyticsEventType {
            jsonDict["type"] = analyticsEventType.rawValue
        }
        if let analyticsEventTime = self.analyticsEventTime {
            jsonDict["time"] = analyticsEventTime.toJsonDict()
        }
//            let eDict = ["oldstate" : "unknown"]
//            let eventDict = ["e" : eDict]
        jsonDict["event"] = [:] //eventDict
//        "event": {
//            "e" : {
//                "oldstate" : "playing"
//            }
//        }
        if let message = self.message {
            jsonDict["message"] = message
        }
        //print(jsonDict)
        return jsonDict
    }

}







