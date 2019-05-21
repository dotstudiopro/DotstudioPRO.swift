//
//  SPLTResumptionAPI.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 13/04/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire


open class SPLTResumptionAPI {
    
    open func getResumptionVideos(_ completion: @escaping (_ responseDictArray: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
//        SPLTBaseAPI.sessionManager.request(SPLTRouter.getResumptionVideos, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
        SPLTBaseAPI.sessionManager.request(SPLTRouter.getResumptionVideos, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            //                debugPrint(response)
            if (response.result.value != nil) {
                if let infoDict = response.result.value as? [String: AnyObject],
                    let bSuccess = infoDict["success"] as? Bool, bSuccess == true,
                    let dataDict = infoDict["data"] as? [String: AnyObject] {
                    completion(dataDict)
                    return
                }
            }
            completionError(NSError(domain: "SPLTResumptionAPI", code: 1, userInfo: nil))
        }
    }
}






