//
//  WDCardURLRequestFactory.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//


import Foundation
import UIKit

class WDCardURLRequestFactory: URLRequestFactory {
    
    func requestToGenerateToken(_ detail: WDTokenRequest) -> URLRequest{
        
        var components = URLComponents()
        
        components.path = self.getVersionedPath("/tokens") ?? ""
        components.host = config.APIHost
        components.scheme = "https"
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPRequestMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: detail.toDict())
            request.httpBody = jsonData
        
//        if let selectedProfileID = UserDefaults.standard.object(forKey: "selectedProfileID"){
//            let profileID = selectedProfileID as? String ?? ""
//            request.addValue(profileID, forHTTPHeaderField: "Profile")
//        }
        
        request.addValue(UUID().uuidString, forHTTPHeaderField: "Idempotency-Key")
        
        return request
           
    }
}
