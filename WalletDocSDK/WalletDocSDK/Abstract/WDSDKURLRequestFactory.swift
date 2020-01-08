//
//  WDSDKURLRequestFactory.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

enum APIError: Error {
    case unknown
    case missingData
    case serialization
    case invalidData
}

class URLRequestFactory {
    
    //private let config: RequestConfig
    
    let config: RequestConfig
    
    // MARK: - Init
    
    init(config: RequestConfig = RequestConfig()) {
        self.config = config
    }
    
    // MARK: - Factory
    
    func baseRequest(endPoint: String) -> URLRequest {
        let stringURL = "\(config.APIHost)/\(endPoint)"
        let encodedStringURL = stringURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = URL(string: encodedStringURL!)!
        
        return  URLRequest(url: url)
    }
    
    func jsonRequest(endPoint: String) -> URLRequest {
        var request = baseRequest(endPoint: endPoint)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func getVersionedPath(_ path: String?) -> String? {
        return "/v1\(path ?? "")"
    }
    
    func getDeviceToken() -> String? {
        #if !DEBUG
            let deviceTokenKey = WALLETDOC_DEVICE_TOKEN
        #else
            let deviceTokenKey = "\(WALLETDOC_DEVICE_TOKEN)_debug"
        #endif
        
        return WDSDKKeychainWrapper.standard.string(forKey: deviceTokenKey)
        
        //return deviceToken
    }
}
