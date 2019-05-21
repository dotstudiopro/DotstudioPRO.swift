//
//  SPLTOrderDetailsAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 29/02/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

//public protocol SPLTCategoriesAPIDelegate: NSObjectProtocol {
//    func didReceiveCategories(spotlightCategories_: [[String: AnyObject]])
//    func didFailedCategoriesAPICall()
//}

open class SPLTOrderDetailsAPI {
    
    //    public var delegate: SPLTCategoriesAPIDelegate?
    
    public init() {
        
    }
    
    open func regenerateAccessTokenAndGetOrderDetails(_ completion: @escaping (_ orderHistory: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        
        SPLTTokenAPI().refreshAllTokens { (strToken) -> Void in
            self.getOrderDetails(completion, completionError: completionError)
        }
        
    }
    
    open func getOrderDetails(_ completion: @escaping (_ orderHistory: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        if (SPLTRouter.strAccessToken == nil || SPLTRouter.strClientToken == nil) {
            if (SPLTRouter.strClientToken == nil) {
                return
            }
            self.regenerateAccessTokenAndGetOrderDetails(completion, completionError: completionError)
            return
        }
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.orderDetail, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [[String: AnyObject]] {
                    completion(infoDict)
                    return
                }
            }
            completionError(NSError(domain: "SPLTOrderDetailsAPI", code: 1, userInfo: nil))
        }
        
    }
    
    
}



