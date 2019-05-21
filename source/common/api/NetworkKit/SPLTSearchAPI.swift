//
//  SPLTSearchAPI.swift
//  DotstudioPRO
//
//  Created by ketan on 07/04/16.
//  Copyright © 2016 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

open class SPLTSearchAPI {
    
    //    public var delegate: SPLTCategoriesAPIDelegate?
    
    public init() {
        
    }
    
    //MARK: - Search Suggesion
//    open func regenerateAccessTokenAndGetSearchSuggesion(_ strSearchTerm: String, completion: @escaping (_ searchSuggesionResult: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//
//        SPLTTokenAPI().getToken { (strToken) -> Void in
//            self.getSearchSuggesion(strSearchTerm, completion: completion, completionError: completionError)
//        }
//
//    }
    
    open func getSearchSuggesion(_ strSearchTerm: String, completion: @escaping (_ searchSuggesionResult: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
        //let strUrl: URLStringConvertible = SPLTRouter.SearchSuggesion(strSearchTerm).URLString
        var headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
        ]
        #if os(tvOS)
            headers["x-device"] = "apple-tv"
        #endif
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.searchSuggesion(strSearchTerm), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
//            if let httpURLResponse = response.response {
//                if (httpURLResponse.statusCode == 403) {
//                    // regenerate accesstoken
//                    self.regenerateAccessTokenAndGetSearchSuggesion(strSearchTerm, completion: completion, completionError: completionError)
//                    return
//                }
//            }
//
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let dataDict = infoDict["data"] as? [String: AnyObject] {
                                completion(dataDict)
                                return
                            }
                        }
                    }
                }

            }
            completionError(NSError(domain: "SPLTSearchAPI", code: 1, userInfo: nil))
        }
        
    }

    
    //MARK: - Search Term
//    open func regenerateAccessTokenAndGetSearchResults(_ strSearchTerm: String, completion: @escaping (_ searchResult: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//
//        SPLTTokenAPI().getToken { (strToken) -> Void in
//            self.getSearchResults(strSearchTerm, completion: completion, completionError: completionError)
//        }
//
//    }
//
    open func getSearchResults(_ strSearchTerm: String, completion: @escaping (_ searchResult: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
//        if (SPLTRouter.strAccessToken == nil) {
//            self.regenerateAccessTokenAndGetSearchResults(strSearchTerm, completion: completion, completionError: completionError)
//            return
//        }
        var headers = [
            "x-access-token": SPLTRouter.strAccessToken!,
            ]
        #if os(tvOS)
            headers["x-device"] = "apple-tv"
        #endif
        
        SPLTBaseAPI.sessionManager.request(SPLTRouter.searchTerm(strSearchTerm), method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
            
//            if let httpURLResponse = response.response {
//                if (httpURLResponse.statusCode == 403) {
//                    // regenerate accesstoken
//                    self.regenerateAccessTokenAndGetSearchResults(strSearchTerm, completion: completion, completionError: completionError)
//                    return
//                }
//            }
//
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let dataDict = infoDict["data"] as? [String: AnyObject] {
                                completion(dataDict)
                                return
                            }
                        }
                    }
                }
                
            }
            completionError(NSError(domain: "SPLTSearchAPI", code: 1, userInfo: nil))
        }
        
    }

    
    //MARK: - Search Video Term
//    open func regenerateAccessTokenAndSearchVideoResults(_ strSearchTerm: String, completion: @escaping (_ searchVideoResults: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
//
//        SPLTTokenAPI().getToken { (strToken) -> Void in
//            self.searchVideoResults(strSearchTerm, completion: completion, completionError: completionError)
//        }
//
//    }
    open func searchVideoResults(_ strSearchTerm: String, completion: @escaping (_ searchVideoResults: [String: AnyObject]) -> Void, completionError: @escaping (_ error: NSError) -> Void) {
        
        // MARK: URLStringConvertible
        let strUrl = SPLTRouter.searchVideoTerm(strSearchTerm).URLString
        var headers: [String: String] = [:]
        if let strAccessToken = SPLTRouter.strAccessToken {
            headers["x-access-token"] = strAccessToken
        } else {
            return
        }
        #if os(tvOS)
            headers["x-device"] = "apple-tv"
        #endif
        
        let url = URL(string: strUrl)!
        
        SPLTBaseAPI.sessionManager.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers).validate().responseJSON { (response) in
//            if let httpURLResponse = response.response {
//                if (httpURLResponse.statusCode == 403) {
//                    // regenerate accesstoken
//                    self.regenerateAccessTokenAndSearchVideoResults(strSearchTerm, completion: completion, completionError: completionError)
////                    self.regenerateAccessTokenAndGetSearchResults(strSearchTerm, completion: completion, completionError: completionError)
//                    return
//                }
//            }
            
            
            if (response.result.value != nil) {
                //print(response.statusCode)
                if let infoDict = response.result.value as? [String: AnyObject] {
                    if let bSuccess = infoDict["success"] as? Bool {
                        if (bSuccess == true) {
                            if let dataDict = infoDict["data"] as? [String: AnyObject] {
                                completion(dataDict)
                                return
                            }
                        }
                    }
                }
                
            }
            completionError(NSError(domain: "SPLTSearchAPI", code: 1, userInfo: nil))
        }
        
    }

    
}



