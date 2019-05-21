//
//  SPLTTokenHandler.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 06/02/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire


class SPLTTokenHandler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ clientToken: String?) -> Void
    
    public let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.timeoutIntervalForRequest = 60
        return SessionManager(configuration: configuration)
    }()
    
    private let lock = NSLock()
    
    private var API_KEY: String
    private var baseURLString: String
    private var accessToken: String
    private var clientToken: String?
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(API_KEY: String, baseURLString: String, accessToken: String, clientToken: String?) {
        self.API_KEY = API_KEY
        self.baseURLString = baseURLString
        self.accessToken = accessToken
        self.clientToken = clientToken
    }
    
//    // MARK: - RequestAdapter
//    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURLString) {
            var urlRequest = urlRequest
            urlRequest.setValue(self.accessToken, forHTTPHeaderField: "x-access-token")
            if let clientToken = self.clientToken {
                urlRequest.setValue(clientToken, forHTTPHeaderField: "x-client-token")
            }
            #if os(iOS)
                urlRequest.setValue("ios", forHTTPHeaderField: "x-os-type")
            #elseif os(tvOS)
                urlRequest.setValue("tvos", forHTTPHeaderField: "x-os-type")
            #endif
            if let strHeaderApplicationName = SPLTConfig.strHeaderApplicationName {
                urlRequest.setValue(strHeaderApplicationName, forHTTPHeaderField: "x-application-name")
            }
            //x-application-name: “celebrity-page-tv”
            //x-os-type: “ios” or “android” or “tvos” or “roku”
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 403 {
            requestsToRetry.append(completion)
            
            if !isRefreshing {
                refreshTokens { [weak self] succeeded, accessToken, clientToken in
                    if succeeded == false {
                        completion(false, 0.0)
                        return
                    }
                    
                    guard let strongSelf = self else { return }
                    
                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }
                    
                    if let accessToken = accessToken, let clientToken = clientToken {
                        strongSelf.accessToken = accessToken
                        strongSelf.clientToken = clientToken
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
    
    // MARK: - Private - Refresh Tokens
    
    private func refreshTokens(completion: @escaping RefreshCompletion) {
        guard !isRefreshing else { return }
        
        isRefreshing = true
        
        if let strAccessToken = SPLTRouter.strAccessToken {
            if let strClientToken = SPLTRouter.strClientToken {
                // both tokens are available.
                let headers = [
                    "x-access-token": strAccessToken,
                    "x-client-token": strClientToken
                ]
                sessionManager.request(SPLTRouter.refreshToken, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: headers).responseJSON { [weak self] response in
                    guard let strongSelf = self else {return}
                    if (response.result.value != nil) {
                        if let infoDict = response.result.value as? [String: AnyObject] {
                            if let bSuccess = infoDict["success"] as? Bool {
                                if (bSuccess == true) {
                                    if let strClientToken = infoDict["client_token"] as? String {
                                        SPLTRouter.strClientToken = strClientToken
                                        UserDefaults.standard.setValue(strClientToken, forKey: "strClientToken")
                                        UserDefaults.standard.synchronize()
                                        completion(true, strAccessToken, strClientToken)
                                        strongSelf.isRefreshing = false
                                        return
                                    }
                                }
                            }
                        }
                    }
                    completion(false, nil, nil)
                    strongSelf.isRefreshing = false
                }
            } else {
                completion(false, nil, nil)
//                // no client token only access token is available
//                SPLTTokenAPI().getToken({ (strAccessToken) in
//                    // access token generated again.
//                })
            }
        } else {
            // no tokens available
            completion(false, nil, nil)
        }
    }
}








