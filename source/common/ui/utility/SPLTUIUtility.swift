//
//  SPLTUIUtility.swift
//  DotstudioUI
//
//  Created by Anwer on 1/9/19.
//SPLTUIUtility

import Foundation


open class SPLTUIUtility: NSObject {
    static public let shared = SPLTUIUtility()
    
    open func getFlatfromNameFromTechnicalName(tName:String) -> String
    {
        var mName = tName
        switch tName {
            case "xumo_mrss":
                mName = "xumo mrss"
            case "android_TV":
                mName = "Android TV"
            case "amazon_fire":
                mName = "Amazon Fire TV"
            case "andriod":
                mName = "Android"
            case "ios":
                mName = "iOS"
            case "roku":
                mName = "Roku TV"
            case "apple_tv":
                mName = "Apple TV"
            case "website":
                mName = "Website"
            
        default:
            mName = tName
        }
        return mName
    }
    
    open func getStringPlatformWithChannel(channel:SPLTChannel) -> String{
        var strPlatforms = ""
        for (index, availablePlatform) in channel.availablePlatforms.enumerated() {
            if index == 0 {
                strPlatforms += "\(self.getFlatfromNameFromTechnicalName(tName: availablePlatform))"
            } else if (index == (channel.availablePlatforms.count - 1)) {
                strPlatforms += " and \(self.getFlatfromNameFromTechnicalName(tName: availablePlatform))"
            } else {
                strPlatforms += ", \(self.getFlatfromNameFromTechnicalName(tName: availablePlatform))"
            }
        }
        return strPlatforms
    }
}
