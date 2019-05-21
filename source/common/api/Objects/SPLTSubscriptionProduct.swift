//
//  SPLTSubscriptionProduct.swift
//  DotstudioAPI
//
//  Created by Anwer on 1/31/19.
//

import UIKit

open class SPLTSubscriptionProduct: NSObject {

    open var strId: String?
    open var strName: String?
    open var strPrice: String?
    open var durationDict: [String: Any]?
    open var strIntervalUnit: String?
    open var isEntireCatalogue:Bool = false
    open var isAdsEnabled:Bool = true
    open var strAppleProductId: String?
    open var strStatus: String?
    open var trialDict: [String: Any]?
    open var strDescription: String?
    open var isMostPopular:Bool = false
    open var strPriceDisplay: String?
    
    
    open var subscriptionDataDict: [String: Any] = [:]
    
    open func mapFromSubscriptionDict(_ subscriptionDataDict: [String: Any]) {
        if let strId = subscriptionDataDict["_id"] as? String {
            self.strId = strId
        }
        if let strName = subscriptionDataDict["name"] as? String {
            self.strName = strName
        }
        if let strPrice = subscriptionDataDict["price"] as? String {
            self.strPrice = strPrice
        }
        if let durationDict = subscriptionDataDict["duration"] as? [String: Any] {
            self.durationDict = durationDict
        }
        if let isEntireCatalogue = subscriptionDataDict["entire_catalogue"] as? Bool {
            self.isEntireCatalogue = isEntireCatalogue
        }
        if let isAdsEnabled = subscriptionDataDict["ads_enabled"] as? Bool {
            self.isAdsEnabled = isAdsEnabled
        }
        if let strAppleProductId = subscriptionDataDict["apple_product_id"] as? String {
            self.strAppleProductId = strAppleProductId
        }
        if let strStatus = subscriptionDataDict["status"] as? String {
            self.strStatus = strStatus
        }
        if let trialDict = subscriptionDataDict["trial"] as? [String: Any] {
            self.trialDict = trialDict
        }
        if let strDescription = subscriptionDataDict["description"] as? String {
            self.strDescription = strDescription
        }
        if let strPriceDisplay = subscriptionDataDict["price_display"] as? String {
            self.strPriceDisplay = strPriceDisplay
        }
        if let isMostPopular = subscriptionDataDict["is_most_popular"] as? Bool {
            self.isMostPopular = isMostPopular
        }
    }
}
