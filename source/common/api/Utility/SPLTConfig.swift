//
//  SPLTConfig.swift
//  DotstudioAPI
//
//  Created by Ketan Sakariya on 15/05/18.
//

import Foundation
import UIKit

public enum SPLTConfigError: Error {
    case noWindowDefined
}

open class SPLTConfig {
    
    static public var auth0FBconnectionName:String = ""
    static public var bundleIdentifierBundleMain: String?
    static public var strIAPPrefix: String?
    static public var infoDictionaryBundleMain: [String : Any]?
    static public var APPNAME: String?
    static public var strHeaderApplicationName: String?
    
    static public var APP_ID: String?
    static public var APP_URL: String?
    
    static public var iCustomCategoryContinueWatchingIndex: Int = 1 //0
    static public var iCustomCategoryWatchAgainIndex: Int = -1
    
    
    //For Recommandation rail
    static public var iRecommandationSize: Int = 20
    static public let iRecommandationStartFrom: Int = 0
    static public var shouldByPassSubscriptionCheck = false
    
    static public var shouldAutoLoadCategoryChannels = false
    static public var window: UIWindow? = nil
    
   open class func setup() {
       //SPLTDebugConfig.setup()
    }
    
    open class func setDebugMode(_ on: Bool) {
        if on {
            SPLTRouter.BASE_URL = "http://api.myspotlight.tv"
            SPLTFullPathRouter.BASE_IMAGE_URL = "http://images.dotstudiopro.com"
            SPLTFullPathRouter.BASE_URL_COLLECTOR_DOTSTUDIOPRO = "http://collector.dotstudiopro.com"
            SPLTFullPathRouter.BASE_URL_COLLECTOR_MYSPOTLIGHTTV = "http://collector.myspotlight.tv"
            //SPLTFullPathRouter.BASE_IMAGE_URL =""
        }
    }
    
    open class func setBaseUrl(_ strBaseUrl: String) {
        SPLTRouter.BASE_URL = strBaseUrl
    }
}





