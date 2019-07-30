//
//  DSChromeCastUtility.swift
//  SampleCastApp
//
//  Created by Anwar Hussain  on 23/04/19.
//  Copyright © 2019 Anwar Hussain . All rights reserved.
//

import Foundation
import GoogleCast

/*
 This class will initialize Chromecast library, keep scanning chrome cast devices & maintain list of chromecast devices. When new devices gets connected or disconnected, it will delegate response to Main Cast Utility. While delegating It will use generic Device Model.
 */
class DSChromeCastUtility: NSObject {
    
    static let shared = DSChromeCastUtility()
    
    var castButton: GCKUICastButton!
    var mediaInformation: GCKMediaInformation?
    var sessionManager: GCKSessionManager!
    var discoveryManager:GCKDiscoveryManager?
    var isChromeCastConnected:Bool?
    var chromeCastDeviceList = [DSCastDeviceModel]()
    var castDeviceModel: DSCastDeviceModel?
    
    let kReceiverAppID = "4F8B3483"
    let kDebugLoggingEnabled = true
    
    var delegate: DSBaseCastUtilityDelegate?
    var video: SPLTVideo?
    
    override init() {
        super.init()
    }
    
    func initSessionAndDiscoverManager() {
        self.isChromeCastConnected = false
        
        
        let criteria = GCKDiscoveryCriteria(applicationID: kReceiverAppID)
        let options = GCKCastOptions(discoveryCriteria: criteria)
        options.physicalVolumeButtonsWillControlDeviceVolume = true
        GCKCastContext.setSharedInstanceWith(options)
        GCKCastContext.sharedInstance().useDefaultExpandedMediaControls = false
    
        sessionManager = GCKCastContext.sharedInstance().sessionManager
        sessionManager.add(self)
        
        discoveryManager = GCKCastContext.sharedInstance().discoveryManager
        self.discoveryManager?.add(self)
        self.discoveryManager?.passiveScan = true
        self.discoveryManager?.startDiscovery()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(castDeviceDidChange(notification:)),
                                               name: NSNotification.Name.gckCastStateDidChange,
                                               object: GCKCastContext.sharedInstance())
    }
    
    
    @objc func castDeviceDidChange(notification: Notification) {
        if GCKCastContext.sharedInstance().castState != GCKCastState.noDevicesAvailable {
            print("gckCaste stateDidChange:",notification.userInfo as Any)
            // Display the instructions for how to use Google Cast on the first app use.
            //GCKCastContext.sharedInstance().presentCastInstructionsViewControllerOnce(with: castButton)
        }
    }
    
    
    // MARK: Cast Actions
    
//    func playVideoRemotely() {
//        if sessionManager.currentSession == nil {
//            print("Cast device not connected")
//            return
//        }
//
//        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
//        // Define media metadata.
//        let metadata = GCKMediaMetadata()
//        metadata.setString("Big Buck Bunny (2008)", forKey: kGCKMetadataKeyTitle)
//        metadata.setString("Big Buck Bunny tells the story of a giant rabbit with a heart bigger than " +
//            "himself. When one sunny day three rodents rudely harass him, something " +
//            "snaps... and the rabbit ain't no bunny anymore! In the typical cartoon " +
//            "tradition he prepares the nasty rodents a comical revenge.",
//                           forKey: kGCKMetadataKeySubtitle)
//        metadata.addImage(GCKImage(url: URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg")!,
//                                   width: 480,
//                                   height: 360))
//
//        // Define information about the media item.
//        let url = URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")
//        guard let mediaURL = url else {
//            print("invalid mediaURL")
//            return
//        }
//
//        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: mediaURL)
//        // TODO: Remove contentID when sample receiver supports using contentURL
//        mediaInfoBuilder.contentID = "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
//        mediaInfoBuilder.streamType = GCKMediaStreamType.none
//        mediaInfoBuilder.contentType = "video/mp4"
//        mediaInfoBuilder.metadata = metadata
//        mediaInformation = mediaInfoBuilder.build()
//
//        // Send a load request to the remote media client.
//        if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation!) {
//            request.delegate = self
//        }
//    }
    
    func playConnectedCastVideo(video: SPLTVideo, onDevice castDeviceModel: DSCastDeviceModel) {
        self.video = video
        self.castDeviceModel = castDeviceModel
        if DSChromeCastUtility.shared.sessionManager.connectionState == .connected {
            self.playVideoWithSelectedVideo()
        } else {
            if let gckObj = castDeviceModel.deviceObject as? GCKDevice {
                DSChromeCastUtility.shared.sessionManager.startSession(with: gckObj)
            }
        }
    }
    func playVideoWithSelectedVideo() {
        
        if sessionManager.currentSession == nil {
            print("Cast device not connected")
            return
        }
        
//        GCKCastContext.sharedInstance().presentDefaultExpandedMediaControls()
        
        // Define media metadata.
        guard let video = self.video else {
            print("invalid Video")
            return
        }
        let metadata = GCKMediaMetadata()
        if let strVideoTitle = video.strTitle {
            metadata.setString(strVideoTitle, forKey: kGCKMetadataKeyTitle)
        }
        if let strVideoDescription = video.strDescription {
            metadata.setString(strVideoDescription, forKey: kGCKMetadataKeySubtitle)
        }
        
        if let strVideoPoster = video.poster, let url = URL(string: strVideoPoster) {
            metadata.addImage(GCKImage(url: url, width: 480, height: 360))
        }
//        metadata.addImage(GCKImage(url: URL(string: video.poster!)!,
//                                   width: 480,
//                                   height: 360))
        
        // Define information about the media item.
//        guard let strVideoId = video.strId else {
//            print("invalid Video Id")
//            return
//        }
        guard let strVideoUrl = video.strVideoUrl, let mediaURL = URL(string: strVideoUrl) else {
            print("invalid Video Url")
            return
        }
//        guard let mediaURL = URL(string: video.strVideoUrl) else {
//            print("invalid mediaURL")
//            return
//        }
        
        let mediaInfoBuilder = GCKMediaInformationBuilder(contentURL: mediaURL)
        
        // TODO: Remove contentID when sample receiver supports using contentURL
        mediaInfoBuilder.contentID = strVideoUrl
//        mediaInfoBuilder.streamType = GCKMediaStreamType.none
        mediaInfoBuilder.contentType = "video/mp4"
        mediaInfoBuilder.metadata = metadata
        let mediaInformation = mediaInfoBuilder.build()
        self.mediaInformation = mediaInformation
        // Send a load request to the remote media client.
        if let request = sessionManager.currentSession?.remoteMediaClient?.loadMedia(mediaInformation) {
            request.delegate = self
        }
        self.delegate?.didRequestMediaPause()
        self.delegate?.didStartPlayingCastVideo(castDeviceModel: self.castDeviceModel)
    }
    

}


extension DSChromeCastUtility:GCKSessionManagerListener{
    
    func sessionManager(_: GCKSessionManager,
                        didStart session: GCKSession) {
        print("sessionManager didStartSession: \(session)")
        
        // Add GCKRemoteMediaClientListener.
        session.remoteMediaClient?.add(self)
       self.delegate?.didConnectedToCastDevice(baseCastUtility: self)
        self.playVideoWithSelectedVideo()
    }
    
    func sessionManager(_: GCKSessionManager,
                        didResumeSession session: GCKSession) {
        print("sessionManager didResumeSession: \(session)")
        
        // Add GCKRemoteMediaClientListener.
        session.remoteMediaClient?.add(self)
        //self.playVideoRemotely()
        self.playVideoWithSelectedVideo()
        self.delegate?.didConnectedToCastDevice(baseCastUtility: self)
    }
    
    func sessionManager(_: GCKSessionManager,
                        didEnd session: GCKSession,
                        withError error: Error?) {
        print("sessionManager didEndSession: \(session)")
        
        // Remove GCKRemoteMediaClientListener.
        session.remoteMediaClient?.remove(self)
        self.delegate?.didDisconnectedFromCastDevice(baseCastUtility: self)
        if let error = error {
            //showError(error)
            print("error:", error)
        }
    }
    
    func sessionManager(_: GCKSessionManager,
                        didFailToStart session: GCKSession,
                        withError error: Error) {
        print("sessionManager didFailToStartSessionWithError: \(session) error: \(error)")
        
        // Remove GCKRemoteMediaClientListener.
        session.remoteMediaClient?.remove(self)
        self.delegate?.didDisconnectedFromCastDevice(baseCastUtility: self)
        //self.showError(error)
        print("error:", error)
    }
}

extension DSChromeCastUtility: GCKDiscoveryManagerListener{
    func didStartDiscoveryForDeviceCategory(deviceCategory: String) {
        print("GCKDiscoveryManagerListener: \(deviceCategory)")
        print("FOUND: \(self.discoveryManager!.hasDiscoveredDevices)")
    }
    func didUpdateDeviceList() {
        print("did update")
    }
    func willUpdateDeviceList() {
        print("will udate")
        
    }
    func didUpdate(_ device: GCKDevice, at index: UInt, andMoveTo newIndex: UInt) {
        print("device move to new index \(newIndex)")
    }
    
    func didUpdate(_ device: GCKDevice, at index: UInt) {
        print("udate device \(device.friendlyName!) and index:\(index)")
        //DSCastUtility.shared.addDevicesToChromeCastList(device: device, index: Int(index))
        self.addDevicesToChromeCastList(device: device, index: Int(index))
    }
    
    func didInsert(_ device: GCKDevice, at index: UInt) {
        print("insert device \(device) - index: \(index)")
        //DSCastUtility.shared.addDevicesToChromeCastList(device: device, index: Int(index))
        self.addDevicesToChromeCastList(device: device, index: Int(index))
        //NotificationCenter.default.post(name:.deviceListUpdated, object: nil)
    }
    
    func addDevicesToChromeCastList(device:GCKDevice, index:Int) {
        let filtered = self.chromeCastDeviceList.filter { ($0.deviceObject as! GCKDevice).deviceID ==  device.deviceID}
        if filtered.count <= 0{
            let deviceModelObj = DSCastDeviceModel(castDevicePlatform: .chromeCast, castDeviceFriendlyName: device.friendlyName, deviceObject: device, castImageName: "chrome_logo")
            self.chromeCastDeviceList.insert(deviceModelObj, at: index)
            self.delegate?.didDiscoverCastDevice(baseCastUtility: self, scannedDeviceList: self.chromeCastDeviceList)
        }
    }
}

extension DSChromeCastUtility: GCKRemoteMediaClientListener, GCKRequestDelegate{
    
    // MARK: GCKRemoteMediaClientListener
    
    func remoteMediaClient(_: GCKRemoteMediaClient,
                           didUpdate mediaStatus: GCKMediaStatus?) {
        if let mediaStatus = mediaStatus {
            mediaInformation = mediaStatus.mediaInformation
        }
    }
    
    // MARK: - GCKRequestDelegate
    
    func requestDidComplete(_ request: GCKRequest) {
        print("request \(Int(request.requestID)) completed")
    }
    
    func request(_ request: GCKRequest,
                 didFailWithError error: GCKError) {
        print("request \(Int(request.requestID)) didFailWithError \(error)")
    }
    
    func request(_ request: GCKRequest,
                 didAbortWith abortReason: GCKRequestAbortReason) {
        print("request \(Int(request.requestID)) didAbortWith reason \(abortReason)")
    }
}

extension DSChromeCastUtility : DSBaseCastUtility {
    func playCastVideo() {
        print("Cast Video")
    }
    
    func initialize() {
        self.initSessionAndDiscoverManager()
    }
    
    func initializeWithDelegate(delegate: DSCastUtility) {
        self.initSessionAndDiscoverManager()
        self.delegate = delegate
    }
    func stopCasting(video: SPLTVideo?, fromViewController viewController: UIViewController?) {
        self.sessionManager.endSessionAndStopCasting(true)
        self.delegate?.didStopPlayingCastVideo()
        self.delegate?.didRequestMediaPlay()
    }
}


