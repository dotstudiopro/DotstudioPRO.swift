//
//  SPLTBaseAPI.swift
//  DotstudioPRO
//
//  Created by Ketan Sakariya on 15/02/17.
//  Copyright © 2017 ___DotStudioz___. All rights reserved.
//

import Foundation
import Alamofire

open class SPLTSessionManager: SessionManager {
    open override func request(_ url: URLConvertible, method: HTTPMethod, parameters: Parameters?, encoding: ParameterEncoding, headers: HTTPHeaders?) -> DataRequest {
        return super.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
    }
    open override func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return super.request(urlRequest)
    }
}


open class SPLTBaseAPI: NSObject {

//    static open let sessionManager = SessionManager()
    
    static public let sessionManager: SPLTSessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SPLTSessionManager.defaultHTTPHeaders
        configuration.httpMaximumConnectionsPerHost = 1
        configuration.timeoutIntervalForRequest = 60
        return SPLTSessionManager(configuration: configuration)
    }()
    
    var request: Alamofire.Request?
    static var spltTokenHandler: SPLTTokenHandler? {
        didSet {
            if let spltTokenHandler_ = spltTokenHandler {
                SPLTBaseAPI.sessionManager.adapter = spltTokenHandler_
                SPLTBaseAPI.sessionManager.retrier = spltTokenHandler_
            }
        }
    }

    func cancelRequest() {
        print("1: alamofire request cancelled.")
        self.request?.suspend()
        self.request?.cancel()
    }
}


