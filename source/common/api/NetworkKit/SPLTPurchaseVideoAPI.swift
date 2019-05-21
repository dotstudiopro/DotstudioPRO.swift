//
//  SPLTPurchaseVideoAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 04/03/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//com.dotstudioz.dotstudiopro.tier_1

import Foundation
import Alamofire

open class SPLTPurchaseVideoAPI {
    
    //    public var delegate: SPLTCategoriesAPIDelegate?
    static let BASE_PURCHASE_TIER = "\(SPLTRouter.BUNDLE_IDENTIFIER).tier_"
//    static let BASE_PURCHASE_TIER = "com.dotstudioz.dotstudiopro.tier_"

    public init() {
        
    }
    
    open func regenerateAccessTokenAndPurchaseVideo(_ strVideoId: String, strBase64Receipt: String, completion: @escaping (_ orderHistory: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.purchaseVideo(strVideoId, strBase64Receipt: strBase64Receipt, completion: completion, completionError: completionError)
        }
        
    }
    
    open func purchaseVideo(_ strVideoId: String, strBase64Receipt: String, completion: @escaping (_ orderHistory: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
        let parameters = [
            "video_id": strVideoId,
            "receipt": strBase64Receipt
        ]

        SPLTBaseAPI.sessionManager.request(SPLTRouter.purchaseVideo, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
          //  print(response.error!)
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            completion(infoDict)
                            return
                        }
                    }
                }
//                if let infoDict = response.result.value as? [String: AnyObject] {
//                    completion(orderHistory: infoDict)
//                    return
//                }
            }
            completionError(NSError(domain: "SPLTPurchaseVideoAPI", code: 100, userInfo: nil))
        }
    }
    
    open func checkVideoPurchaseStatus(_ strVideoId: String, completion: @escaping (_ responseObject: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        let parameters = [
            "video": strVideoId,
        ]
        SPLTBaseAPI.sessionManager.request(SPLTRouter.videoPurchaseStatus, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject] {
                   // if let bSuccess = infoDict["success"] as? Bool {
                     //   if (bSuccess == true) {
                            completion(infoDict)
                            return
                       // }
                    //}
                }
            }
            completionError(NSError(domain: "SPLTVideoPurchaseStatusAPI", code: 100, userInfo: nil))
        }
    }
}



