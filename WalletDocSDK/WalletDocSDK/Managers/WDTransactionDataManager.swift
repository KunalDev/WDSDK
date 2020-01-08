//
//  WDTransactionDataManager.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 19/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

class WDTransactionDataManager {
    
    private let queueManager: WDSDKQueueManager
    private let urlRequestFactory: WDTransactionURLRequestFactory
    
    // MARK: - Init
    
    init(withQueueManager queueManager: WDSDKQueueManager = WDSDKQueueManager.shared) {
        self.queueManager = queueManager
        self.urlRequestFactory = WDTransactionURLRequestFactory()
    }
    
    // MARK: -
    
    func createTransaction(_ createTransactionRequest: WDCreateTransactionRequest, completionHandler: @escaping (_ result: Result<WDCreateTransactionResponse,Error>) -> Void) {
        let operation = WDCreateTransactionOperation(request: urlRequestFactory.requestToCreateTransaction(createTransactionRequest))
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
    
    func processTransaction(_ processTransactionRequest: WDProcessTransactionRequest, completionHandler: @escaping (_ result: Result<WDProcessTransactionResponse,Error>) -> Void) {
        let operation = WDProcessTransactionOperation(request: urlRequestFactory.requestToProcessTransaction(processTransactionRequest))
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
    
    func processTransactionWithSessionID(_ processTransactionWithSessionRequest: WDProcessTransactionWithSessionRequest, completionHandler: @escaping (_ result: Result<WDProcessTransactionWithSessionResponse,Error>) -> Void) {
        let operation = WDProcessTransactionWithSessionOperation(request: urlRequestFactory.requestToProcessTransactionWithSession(processTransactionWithSessionRequest))
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
    
}




