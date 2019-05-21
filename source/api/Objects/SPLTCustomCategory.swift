//
//  SPLTCustomCategory.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 13/04/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation



public enum SPLTCustomCategoryType {
    case none
    case continueWatching
    case watchAgain
}

open class SPLTCustomCategory: SPLTCategory { 
    open var enumSPLTCustomCategoryType: SPLTCustomCategoryType = .none
    
    open var customChannelVideosArray: [[String: AnyObject]] = []
    init(_ enumSPLTCustomCategoryType: SPLTCustomCategoryType, customChannelVideosArray: [[String: AnyObject]]) {
        super.init()
        self.enumSPLTCustomCategoryType = enumSPLTCustomCategoryType
        switch enumSPLTCustomCategoryType {
            case .continueWatching:
                self.strName = "Continue Watching"
                break
            case .watchAgain:
                self.strName = "Watch Again"
                break
            default:
                break
        }
        self.customChannelVideosArray = customChannelVideosArray
        self.mapFromCustomChannelVideosArray(customChannelVideosArray)
    }
    
    open func mapFromCustomChannelVideosArray(_ customChannelVideosArray: [[String: AnyObject]]) {
        self.channels.removeAll()
        switch self.enumSPLTCustomCategoryType {
            case .continueWatching:
                let continueWatchingPlaylistChannel = SPLTCustomPlaylistChannel(.continueWatching, customChannelVideosArray: customChannelVideosArray)
                self.channels.append(continueWatchingPlaylistChannel)
                break
            case .watchAgain:
                    let continueWatchingPlaylistChannel = SPLTCustomPlaylistChannel(.watchAgain, customChannelVideosArray: customChannelVideosArray)
                    self.channels.append(continueWatchingPlaylistChannel)
                break
            default:
                break
        }
    }

}



