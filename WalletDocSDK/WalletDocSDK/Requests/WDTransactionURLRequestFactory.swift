//
//  WDTransactionURLRequestFactory.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 19/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

class WDTransactionURLRequestFactory: URLRequestFactory {
    
    func requestToCreateTransaction(_ transaction: WDCreateTransactionRequest) -> URLRequest{
        
        var components = URLComponents()
        
        components.path = self.getVersionedPath("/transactions") ?? ""
        components.host = config.APIHost
        components.scheme = "https"
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPRequestMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try? JSONSerialization.data(withJSONObject: transaction.toDict())
        request.httpBody = jsonData
        
        request.addValue(UUID().uuidString, forHTTPHeaderField: "Idempotency-Key")
        
        return request
        
    }
    
    
    func requestToProcessTransaction(_ transaction: WDProcessTransactionRequest) -> URLRequest{
        
        var components = URLComponents()
        
        components.path = self.getVersionedPath("/transactions/\(transaction.id)/process") ?? ""
        components.host = config.APIHost
        components.scheme = "https"

        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPRequestMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try? JSONSerialization.data(withJSONObject: transaction.toDict())
        request.httpBody = jsonData


        request.addValue(UUID().uuidString, forHTTPHeaderField: "Idempotency-Key")
        
        return request
        
    }
    
    
    func requestToProcessTransactionWithSession(_ transaction: WDProcessTransactionWithSessionRequest) -> URLRequest{
        
        var components = URLComponents()
        
        components.path = self.getVersionedPath("/transactions/\(transaction.id)/process") ?? ""
        components.host = config.APIHost
        components.scheme = "https"

        var request = URLRequest(url: components.url!)
        request.httpMethod = HTTPRequestMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let jsonData = try? JSONSerialization.data(withJSONObject: transaction.toDict())
        request.httpBody = jsonData


        request.addValue(UUID().uuidString, forHTTPHeaderField: "Idempotency-Key")
        
        return request
        
    }
    
    
}

/*
 {
 "amount" : 340000,
 "currency" : "ZAR",
 "capture" : true,
 "customer_id" : "ccffcbdbd4fe43cda80e53d9b660ef46",
 "payment_method_id" : "ct_063ee248aaee4994bd9ef79e308b1cd9"
 }
 
 var components = URLComponents()
 components.path = self.getVersionedPath("/merchants/transactions") ?? ""
 components.host = config.APIHost
 components.scheme = "https"
 
 let from = URLQueryItem(name: "since", value: paymentRequest.fromDateString)
 let to = URLQueryItem(name: "until", value: paymentRequest.toDateString)
 let offset = URLQueryItem(name: "offset", value: paymentRequest.offset)
 let limit = URLQueryItem(name: "limit", value: paymentRequest.limit)
 
 let type = URLQueryItem(name: "type", value: paymentRequest.type)
 
 components.queryItems = [from,to,offset,limit,type]
 
 var request = URLRequest(url: components.url!)
 request.httpMethod = HTTPRequestMethod.get.rawValue
 request.addValue("application/json", forHTTPHeaderField: "Content-Type")
 
 if let selectedProfileID = UserDefaults.standard.object(forKey: "selectedProfileID"){
 let profileID = selectedProfileID as? String ?? ""
 request.addValue(profileID, forHTTPHeaderField: "Profile")
 }
 
 return request
 
 
 */
