//
//  WDSDKRequestConfig.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

enum HTTPRequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class RequestConfig {
    
    let APIHost: String
    
    // MARK: - Init
    
    init() {
        #if DEBUG
            self.APIHost = "www.walletdoc.tech"
        #else
            //[Fabric with:@[[Crashlytics class]]];
            self.APIHost = "www.walletdoc.com"
        #endif
    }
}

