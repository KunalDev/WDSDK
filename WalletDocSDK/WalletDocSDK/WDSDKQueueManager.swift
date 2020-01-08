//
//  WDSDKQueueManager.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 14/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

class WDSDKQueueManager {
    
    lazy var queue: OperationQueue = {
        let queue = OperationQueue()
        
        return queue;
    }()
    
    var loginOrLogoutOperation: Operation!
    
    // MARK: - Singleton
    
    static let shared = WDSDKQueueManager()
    
    // MARK: - Addition
    
    func enqueue(_ operation: Operation, isLoginOrLogoutOperation: Bool = false) {
        
        if isLoginOrLogoutOperation
        {
            if let loginOperation = loginOrLogoutOperation{
                if loginOperation.isReady || loginOperation.isExecuting {
                    operation.addDependency(loginOperation)
                }
            }else{
                loginOrLogoutOperation = operation
            }
        } else {
             if let loginOperation = loginOrLogoutOperation{
                if loginOperation.isReady || loginOperation.isExecuting {
                    operation.addDependency(loginOperation)
                }
            }
        }
        queue.addOperation(operation)
    }
    
    func cancelAllOperations() {
        queue.cancelAllOperations()
    }
}
