//
//  SPLTRecommandationAPI.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 18/01/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

open class SPLTRecommandationAPI {
    public init() {
        
    }
    open func getRecommandationForVideo(_ strVideoId: String, completion: @escaping (_ recommandationDictArray: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        let urlConvertible = SPLTRouter.recommandationVideo(strVideoId, SPLTConfig.iRecommandationSize, SPLTConfig.iRecommandationStartFrom) //strChannelId)
            SPLTBaseAPI.sessionManager.request(urlConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    print("5")
                    if let bValue = infoDict["success"] as? Bool, bValue == true,
                        let dataDict = infoDict["data"] as? [String: AnyObject] {
                        print("6")
                        if let hitsDictArray = dataDict["hits"] as? [[String: AnyObject]] {
                            print("7")
                            completion(hitsDictArray)
                        }
                    }
                }
            }
            completionError(NSError(domain: "SPLTRecommandationAPI", code: 1, userInfo: nil))
        }
        
    }
    
    open func getRecommandationForChannel(_ strChannelId: String, completion: @escaping (_ recommandationDictArray: [[String: AnyObject]]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        let urlConvertible = SPLTRouter.recommandationChannel(strChannelId, SPLTConfig.iRecommandationSize, SPLTConfig.iRecommandationStartFrom) //strChannelId)
          SPLTBaseAPI.sessionManager.request(urlConvertible, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bValue = infoDict["success"] as? Bool, bValue == true,
                        let dataDict = infoDict["data"] as? [String: AnyObject] {
                        if let hitsDictArray = dataDict["hits"] as? [[String: AnyObject]] {
                            completion(hitsDictArray)
                        }
                    }
                }
            }
            completionError(NSError(domain: "SPLTRecommandationAPI", code: 1, userInfo: nil))
        }
        
    }

}







