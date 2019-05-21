//
//  SubscriptionUtility.swift
//  RevryApp-tvOS
//
//  Created by Anwer on 6/26/18.
//  Copyright © 2018 Dotstudioz. All rights reserved.
//

import UIKit

open class SPLTSubscriptionUtility: NSObject {
    static public let shared = SPLTSubscriptionUtility()
    open var subscriptionProducts: [SPLTSubscriptionProduct] = []

    open var isSubscriptionsValid = false
    open var bAdsEnabled = false
    open var strSubscribedMonthlyPlanPrice = ""
    open var strSubscribedYearlyPlanPrice = ""
    open var platform = ""
    
    open func checkSubscriptionStatus(_ channel: SPLTChannel, completion: @escaping (_ bSubscriptionUnlocked :Bool,_ bAdsEnabled: Bool) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        if let strDsProChannelId = channel.dspro_id {
            SPLTSubscriptionAPI().checkSubscriptionStatus(strDsProChannelId, completion: { (bSubscriptionUnlocked, bAdsEnabled) in
                self.bAdsEnabled = bAdsEnabled
                completion(bSubscriptionUnlocked, bAdsEnabled)
            }) { (error) in
                self.bAdsEnabled = true
                completionError(error)
            }
        } else {
            self.bAdsEnabled = true
            completionError(NSError(domain: "SPLTSubscriptionUtility", code: 1, userInfo: nil))
        }
    }
    
    open func getActiveSubscriptions(_ completion: @escaping (_ infoDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTSubscriptionAPI().getActiveSubscriptions({ (responseDict) in
            // successful response
            if let bValue = responseDict["success"] as? Bool, bValue == true {
                if let arraySubscriptions = responseDict["subscriptions"] as? [[String: AnyObject]] , arraySubscriptions.count > 0 {
                    for subScriptionDictionary in arraySubscriptions {
                        if let subscription = subScriptionDictionary["subscription"] as? [String: AnyObject] {
                            if let platform = subscription["platform"] as? String{
                                self.platform = platform
                            }                            
                            if let product = subscription["product"] as? [String: AnyObject] {
                                self.strSubscribedMonthlyPlanPrice = "$"
                                if let strProductPrice = self.getProductPriceFromProductDict(product) {
                                    self.strSubscribedMonthlyPlanPrice += strProductPrice
                                }
                                if let revry_monthly = product["handle"] as? String, revry_monthly == "revry_monthly" {
                                    self.strSubscribedMonthlyPlanPrice += " Monthly"
                                } else {
                                    self.strSubscribedMonthlyPlanPrice += " Yearly"
                                }
                            }
                        }
                    }
                    //Manage Subscriptions
                    self.isSubscriptionsValid = true
                } else {
                    //Subscribe
                    self.isSubscriptionsValid = false
                }
            } else {
                //Subscribe
                self.isSubscriptionsValid = false
            }
            completion(responseDict)
        }) { (error) in
                self.isSubscriptionsValid = false
            completionError(error)
        }
    }
    
    func getProductPriceFromProductDict(_ productDict: [String: Any]) -> String? {
        if let dPriceInCents = productDict["price_in_cents"] as? Double {
            let iPriceInCents = Int(dPriceInCents)
            let iPriceInDollers = iPriceInCents / 100
            let iPriceRemainderCents = iPriceInCents % 100
            let strProductPrice = "\(iPriceInDollers).\(iPriceRemainderCents)"
            //self.strSubscribedMonthlyPlanPrice = "$"+String(strProductPrice)+" Monthly"
            return strProductPrice
        }
        return nil
    }
    
    open func getActiveSubscriptions() {
        self.getActiveSubscriptions({ (infoDict) in
        }) { (error) in
        }
    }
}

//MARK: - extension
extension SPLTSubscriptionUtility {
    open func loadSubscriptionProducts(completion: @escaping (_ subscriptionProducts: [SPLTSubscriptionProduct]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        SPLTSubscriptionAPI().getSubscriptionProducts(completion: { (subscriptionDict) in
            self.subscriptionProducts.removeAll()
            if let dataDictArray = subscriptionDict["data"] as? [[String: Any]] {
                for (_, element) in dataDictArray.enumerated() {
                    let spltSubscriptionProduct = SPLTSubscriptionProduct()
                    spltSubscriptionProduct.mapFromSubscriptionDict(element)
                    self.subscriptionProducts.append(spltSubscriptionProduct)
                }
                completion(self.subscriptionProducts)
            }
        }) { (error) in
            completionError(error)
        }
    }
}
