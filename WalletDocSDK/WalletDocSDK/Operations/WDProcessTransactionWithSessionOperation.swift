//
//  WDProcessTransactionWithSessionOperation.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 24/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

class WDProcessTransactionWithSessionOperation: WDSDKConcurrentOperation<WDProcessTransactionWithSessionResponse,Error> {
    
    private let session: URLSession
    private let urlRequestFactory: WDCardURLRequestFactory
    private var task: URLSessionTask?
    private var urlRequest: URLRequest
    
    // MARK: - Init
    
    init(request: URLRequest, session: URLSession = URLSession.shared, urlRequestFactory: WDCardURLRequestFactory = WDCardURLRequestFactory()) {
        self.session = session
        self.urlRequestFactory = urlRequestFactory
        self.urlRequest = request
    }
    
    // MARK: - Main
    
    override func main() {
        
        urlRequest.addPublicRequestAuthorization()
        
        task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            var statusCode = 0
            
            if let responseStatusCode = response?.getStatusCode(){
                statusCode = responseStatusCode
            }
            
            guard let responseData = data, (statusCode == 200 || statusCode == 201) else {
                
                let error = self.handleError(response, data: data, error: error)
                DispatchQueue.main.async {
                    if !self.handleConnectionErrors(error){
                        if let error = error {
                            self.complete(result: .failure(error))
                        } else {
                            self.complete(result: .failure(APIError.missingData))
                        }
                    }
                }
                return
            }
            
            do {
                
                 guard let json = try? JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) else {
                    return
                }
                print(json as! NSDictionary)
                
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let processTransactionResponse = try decoder.decode(WDProcessTransactionWithSessionResponse.self, from: responseData)
                
                DispatchQueue.main.async {
                    self.complete(result: .success(processTransactionResponse))
                }
            } catch let error {
                DispatchQueue.main.async {
                    print(error)
                    self.complete(result: .failure(APIError.serialization))
                }
            }
        }
        task?.resume()
    }
    
    // MARK: - Cancel
    
    override func cancel() {
        task?.cancel()
        super.cancel()
    }
}
