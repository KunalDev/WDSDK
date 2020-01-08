//
//  WDSDKURLRequest+HTTPBody.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

extension URLRequest {
    
    // MARK: - JSON
    
    mutating func setJSONParameters(_ parameters: [String: Any]?) {
        guard let parameters = parameters else {
            httpBody = nil
            return
        }
        
        httpBody = try! JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions(rawValue: 0))
    }
    
    mutating func addPublicRequestAuthorization() {

        let authorizationBearer = "Basic \(WDSDK.publicKey)"
        self.addValue(authorizationBearer, forHTTPHeaderField: "Authorization")
        
//        if let accessToken = WDBSDKAccessToken.current(){
//            let authorizationBearer = "Basic \(accessToken.tokenString)"
//            self.addValue(authorizationBearer, forHTTPHeaderField: "Authorization")
//        }
    }
    
    mutating func addPrivateRequestAuthorization() {

            let authorizationBearer = "Basic \(WDSDK.secretKey)"
            self.addValue(authorizationBearer, forHTTPHeaderField: "Authorization")
            
    //        if let accessToken = WDBSDKAccessToken.current(){
    //            let authorizationBearer = "Basic \(accessToken.tokenString)"
    //            self.addValue(authorizationBearer, forHTTPHeaderField: "Authorization")
    //        }
        }
    
    
}
