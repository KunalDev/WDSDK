//
//  WDCardDataManager.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

class WDCardDataManager {
    
    private let queueManager: WDSDKQueueManager
    private let urlRequestFactory: WDCardURLRequestFactory
    
    // MARK: - Init
    
    init(withQueueManager queueManager: WDSDKQueueManager = WDSDKQueueManager.shared) {
        self.queueManager = queueManager
        self.urlRequestFactory = WDCardURLRequestFactory()
    }
    
    // MARK: -
    
    func generateToken(_ detail: WDTokenRequest, completionHandler: @escaping (_ result: Result<WDToken,Error>) -> Void) {
        let operation = WDGenerateTokenOperation(request: urlRequestFactory.requestToGenerateToken(detail))
        operation.completionHandler = completionHandler
        queueManager.enqueue(operation)
    }
}
