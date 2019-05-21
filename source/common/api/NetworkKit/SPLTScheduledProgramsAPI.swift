//
//  SPLTScheduledProgramsAPI.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 21/03/18.
//  Copyright © 2018 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

open class SPLTScheduledProgramsAPI {
    
    open func getScheduledProgramDicts(completion: @escaping (_ scheduledProgramDataDict: [String: Any]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.scheduledPrograms, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { (response) in
            if (response.result.value != nil) {
                if let responseDict = response.result.value as? [String: Any] {
                    if let bValue = responseDict["success"] as? Bool, bValue == true {
                        
                        completion(responseDict)
//                        if let scheduledProgramDicts = responseDict["program"] as? [[String: Any]] {
//                            completion(scheduledProgramDicts)
//                            return
//                        }
                        
                        
                    }
                }
            }
            completionError(NSError(domain: "SPLTScheduledProgramsAPI", code: 1, userInfo: nil))
        }
    }
    
    
}






