//
//  Constants.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 22/08/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation


public struct SPLTConstants {
   public static let SPLTCompanyData_DidUpdateCategories = "SPLTCompanyData_DidUpdateCategories_"
   public static let SPLTCategory_DidUpdateCategoryChannels = "SPLTCategory_DidUpdateCategoryChannels_"
//    static let SPLTCompanyData_DidUpdateCategories = "SPLTCompanyData_DidUpdateCategories"
}

public extension Notification.Name {
    public static let SPLT_LOGIN_COMPLETED = NSNotification.Name("SPLT_LOGIN_COMPLETED")
    public static let SPLT_LOGOUT_COMPLETED = NSNotification.Name("SPLT_LOGOUT_COMPLETED")
//    public static let SPLT_LOGIN = NSNotification.Name("SPLT_LOGIN")
//    public static let SPLT_LOGOUT = NSNotification.Name("SPLT_LOGOUT")
}


public enum SearchType {
    case video
    case channel
}



