//
//  DSCastDeviceModel.swift
//  DotstudioIMAPlayer
//
//  Created by Ketan Sakariya on 14/05/19.
//

import Foundation


//struct Constants {
//    static let kChromeCast = "ChromeCast"
//    static let kApple = "Apple"
//}

extension Notification.Name {
    static let deviceListUpdated = Notification.Name("deviceListUpdated")
    static let ChromeSessionConnected = Notification.Name("ChromeSessionConnected")
    static let ChromeSessionDidEnd = Notification.Name("ChromeSessionDidEnd")
}

class DSCastDeviceModel {
    var castDevicePlatform: DSPConnectedCastDeviceType
    var castDeviceFriendlyName: String?
    var deviceObject: Any?
    var castImageName: String?
    
    init(castDevicePlatform: DSPConnectedCastDeviceType, castDeviceFriendlyName: String?, deviceObject: Any?, castImageName: String?) {
        self.castDevicePlatform = castDevicePlatform
        self.castDeviceFriendlyName = castDeviceFriendlyName
        self.deviceObject = deviceObject
        self.castImageName = castImageName
    }
}




