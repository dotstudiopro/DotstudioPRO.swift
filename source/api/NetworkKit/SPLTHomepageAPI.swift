//
//  SPLTHomepageAPI.swift
//  DotstudioAPI
//
//  Created by Ketan Sakariya on 04/04/19.
//

import Foundation
import Alamofire

public protocol SPLTHomepageAPIDelegate: NSObjectProtocol {
    func didReceiveHomepageData(_ homepageData: [[String: Any]])
    func didFailedToreceiveHomepageData()
}

open class SPLTHomepageAPI {
    
    open var delegate: SPLTHomepageAPIDelegate?
    
    public init() {
        
    }
    
    open func loadHomepagedata(_ completion: @escaping (_ homepageData: [[String: Any]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
//        if (SPLTRouter.strAccessToken == nil) {
//            self.regenerateAccessTokenAndGetCategories(completion, completionError: completionError)
//            return
//        }
        
        #if os(iOS)
            let strHomepageAPI = SPLTRouter.homepageapi("ios")
        #else
            let strHomepageAPI = SPLTRouter.homepageapi("appletv")
        #endif
        
        SPLTBaseAPI.sessionManager.request(strHomepageAPI, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: Any] {
                    if let homepageData = infoDict["homepage"] as? [[String: Any]] {
                        self.delegate?.didReceiveHomepageData(homepageData)
                        completion(homepageData)
                        return
                    }
                }
            }
            self.delegate?.didFailedToreceiveHomepageData()
            completionError(NSError(domain: "SPLTHomepageAPI", code: 1, userInfo: nil))
        }
        
    }
}
