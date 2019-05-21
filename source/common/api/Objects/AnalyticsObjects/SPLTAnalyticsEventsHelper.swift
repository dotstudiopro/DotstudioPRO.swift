//
//  SPLTAnalyticsEventsHelper.swift
//  DotstudioPRO
//
//  Created by ketan on 09/06/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import UIKit


open class SPLTAnalyticsEventsHelper: NSObject {
    
    public static let sharedInstance = SPLTAnalyticsEventsHelper()
    
    // Create a new private queue
    var myBackgroundQueue: DispatchQueue = DispatchQueue( label: "\(SPLTConfig.bundleIdentifierBundleMain!).myBackgroundQueue", attributes: [] )
//    myBackgroundQueue = dispatch_queue_create("com.company.subsystem.task", NULL);

    var session_id: String?
    var last_sent: Date?
    var analyticsEventsAPIObjects: [SPLTAnalyticsEventsAPIObject] = []
    var timer: Timer?
    
    
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(SPLTAnalyticsEventsHelper.handleDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SPLTAnalyticsEventsHelper.handleWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)

    }
    deinit {
         NotificationCenter.default.removeObserver(self)
    }
    
    open func initializeWith(_ pageChannelId: String?, pageVideoId: String, pageVideoCompanyId: String, pagePlaylistId: String?, pageCompanyId: String) {
        
//        if (self.myBackgroundQueue == nil) {
//            let bundleIdentifier = SPLTConfig.bundleIdentifierBundleMain
//            self.myBackgroundQueue = dispatch_queue_create( "\(bundleIdentifier).myBackgroundQueue", DISPATCH_QUEUE_SERIAL )
//        }

        if (self.timer == nil) {
            self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(SPLTAnalyticsEventsHelper.sendAnalyticsIfNeeded), userInfo: nil, repeats: true)
        }
        self.myBackgroundQueue.async { () -> Void in
            if self.analyticsEventsAPIObjects.count != 0 {
                self.analyticsEventsAPIObjects.removeAll()
            }
            
            self.last_sent = nil
            self.session_id = nil // set session id nil in start of each video.
            
            let analyticsEventsAPIObject: SPLTAnalyticsEventsAPIObject = SPLTAnalyticsEventsAPIObject(session_id: self.session_id, last_sent: self.last_sent, pageChannelId: pageChannelId, pageVideoId: pageVideoId, pageVideoCompanyId: pageVideoCompanyId, pagePlaylistId: pagePlaylistId, pageCompanyId: pageCompanyId)
            self.analyticsEventsAPIObjects.append(analyticsEventsAPIObject)
        }
//        print(analyticsEventsAPIObject.toJsonDict())
    }
    
    open var analyticsEventType: SPLTAnalyticsEventType?
    open func addEvent(_ analyticsEvent: SPLTAnalyticsEvent) {
        
        #if os(tvOS)
            if (analyticsEvent.analyticsEventType == self.analyticsEventType) {
                return
            }
            self.analyticsEventType = analyticsEvent.analyticsEventType
        #endif
        // Dispatch a private queue
        self.myBackgroundQueue.async { () -> Void in
            if let analyticsEventsAPIObject = self.analyticsEventsAPIObjects.last {
                analyticsEventsAPIObject.addEvent(analyticsEvent)
            }
            if analyticsEvent.analyticsEventType == SPLTAnalyticsEventType.complete || analyticsEvent.analyticsEventType == SPLTAnalyticsEventType.end_playback {
                self.flushEvents()
            }
        }
    }
    
    open func flushEvents() {
        if let analyticsEventsAPIObject = self.analyticsEventsAPIObjects.first {
            self.analyticsEventsAPIObjects.removeFirst()
            let newAnalyticsEventsAPIObject: SPLTAnalyticsEventsAPIObject = SPLTAnalyticsEventsAPIObject(analyticsEventsAPIObject: analyticsEventsAPIObject)
            newAnalyticsEventsAPIObject.session_id = self.session_id
            self.analyticsEventsAPIObjects.append(newAnalyticsEventsAPIObject)
            SPLTAnalyticsAPI().sendAnalytics(analyticsEventsAPIObject, completion: { (completionDict) in
                    // Success
                    self.myBackgroundQueue.async { () -> Void in
                        self.last_sent = Date()
                        newAnalyticsEventsAPIObject.last_sent = self.last_sent
                        if  !self.isAppInBackground {
                            if let session_id = completionDict["session_id"] as? String {
                                self.session_id = session_id
                                if let firstAnalyticsEventsAPIObject = self.analyticsEventsAPIObjects.first {
                                    firstAnalyticsEventsAPIObject.session_id = session_id
                                }
                            }
                        }
                        #if os(iOS)
                            DispatchQueue.main.async {
                                SPLTBackgroundTaskUtility.sharedInstance.completeBackgroundTask()
                            }
                        #endif
                    }
                }, completionError: { (error) in
                    #if os(iOS)
                        DispatchQueue.main.async {
                            SPLTBackgroundTaskUtility.sharedInstance.completeBackgroundTask()
                        }
                    #endif
                    print(error)
            })
        }
    }
    
    //MARK: - Timer 10 seconds interval method
    @objc open func sendAnalyticsIfNeeded() {
        self.myBackgroundQueue.async { () -> Void in
            if let analyticsEventsAPIObject = self.analyticsEventsAPIObjects.first, analyticsEventsAPIObject.analyticsEvents.count > 0 {
                self.flushEvents()
            }
        }
    }
    
    //MARK: - Handle Notifications
    var isAppInBackground: Bool = false
    @objc open func handleDidEnterBackground() {
        self.isAppInBackground = true
        self.last_sent = nil
        #if os(iOS)
        SPLTBackgroundTaskUtility.sharedInstance.beginBackgroundUpdateTask()
        #endif
        self.myBackgroundQueue.async { () -> Void in
            self.session_id = nil
            if let analyticsEventsAPIObject = self.analyticsEventsAPIObjects.first {
                if analyticsEventsAPIObject.analyticsEvents.count > 0 {
                    self.flushEvents()
                } else {
                    analyticsEventsAPIObject.session_id = nil
                }
            }
        }
    }
    @objc open func handleWillEnterForeground() {
        #if os(iOS)
        SPLTBackgroundTaskUtility.sharedInstance.completeBackgroundTask()
        #endif
        self.isAppInBackground = false
    }
    
}

