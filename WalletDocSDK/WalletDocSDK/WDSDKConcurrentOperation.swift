//
//  WDSDKConcurrentOperation.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 14/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

enum Result<T1,T2> {
    case success(T1)
    case failure(T2)
}

class WDSDKConcurrentOperation<T1,T2>: Operation {

    var isLoginOrLogoutOperation = false
    
    typealias OperationCompletionHandler = (_ result: Result<T1,T2>) -> Void

    var completionHandler: (OperationCompletionHandler)?
    
    var errorAlertController: UIAlertController?
  //  let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var lastShownError: Error?
    var lastShownErrorTime: CFTimeInterval = 0
    
    // MARK: - State
    
    private enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"
    }
    
    private var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.rawValue)
            willChangeValue(forKey: state.rawValue)
        }
        didSet {
            didChangeValue(forKey: oldValue.rawValue)
            didChangeValue(forKey: state.rawValue)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    // MARK: - Start
    
    override func start() {
        guard !isCancelled else {
            finish()
            return
        }
        
        if !isExecuting {
            state = .executing
        }
        
        main()
    }
    
    // MARK: - Finish
    
    func finish() {
        if isExecuting {
            state = .finished
        }
    }
    
    func complete(result: Result<T1,T2>) {
        finish()
        
        if !isCancelled {
            completionHandler?(result)
        }
    }

    func handleError(_ response: URLResponse?, data: Data?, error: Error?) -> Error?{
        
        var statusCode = 0
        
        if let responseStatusCode = response?.getStatusCode(){
            statusCode = responseStatusCode
        }
        
        if statusCode != -1 {

            var errorDictionary: [AnyHashable : Any]? = nil
            
            if data != nil && (data?.count ?? 0) > 0 {
                
                if let data = data{
                    
                    guard let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                        return nil
                    }
                    print(json as! NSDictionary)
                    
                    do {
                        let user = try JSONDecoder().decode(WDError.self, from: data)
                        errorDictionary = [
                            NSLocalizedDescriptionKey: user.message,
                            "code": user.code
                        ]
                    } catch {
                        
                    }
                }
            }

            if errorDictionary == nil {
                if response == nil && error != nil {
                    errorDictionary = [
                        NSLocalizedDescriptionKey: error?.localizedDescription ?? ""
                    ]
                } else {
                    switch statusCode {
                    case 400:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("Bad Request", comment: "")
                        ]
                    case 401:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("Unauthorized Request", comment: "")
                        ]
                    case 403:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("Forbidden Request", comment: "")
                        ]
                    case 404:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("Unable to communicate with the walletdoc server\n\nPlease try again later", comment: "")
                        ]
                    case 500:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("The server encountered an unexpected condition which prevented it from fulfilling the request", comment: "")
                        ]
                    case 504:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("The server is currently unable to handle the request\n\nPlease try again later", comment: "")
                        ]
                    default:
                        errorDictionary = [
                            NSLocalizedDescriptionKey: NSLocalizedString("An unknown error occured - \(statusCode)", comment: "")
                        ]
                    }
                }
            }
            
            print("Response :- \(response)")
            
            let error = NSError(domain: "WalletDoc-API", code: statusCode, userInfo: errorDictionary as? [String : Any])
            return error
        }
        return error
    }
    
    
    //, onFailure failure: WDFailureHandler
    func handleConnectionErrors(_ connectionError: Error?, shouldShowAlert showAlert: Bool = true) -> Bool {
        //    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        //NSLog(@"error: %@", connectionError);
        
        let elapsedTime: CFTimeInterval = CACurrentMediaTime() - lastShownErrorTime
        
        if let lastShownError = lastShownError{
            if (lastShownError as NSError?)?.code == (connectionError as NSError?)?.code && elapsedTime < 1.0 {
                return true
            }
        }
        
        lastShownError = connectionError
        lastShownErrorTime = CACurrentMediaTime()
        
        if (connectionError as NSError?)?.code == 401 {
            handleAuthenticationError()
            if connectionError?.localizedDescription != nil {
                showError(withTitle: nil, andMessage: connectionError?.localizedDescription)
            } else {
                showError(withTitle: nil, andMessage: NSLocalizedString("Your session has expired. Please login again.", comment: ""))
            }
            return true
        }
        
        return false
        
        /*
        if connectionError != nil && showAlert {
            // do nothing if we already showed the same error within the last second
            let elapsedTime: CFTimeInterval = CACurrentMediaTime() - lastShownErrorTime
            
            if let lastShownError = lastShownError{
                if (lastShownError as NSError?)?.code == (connectionError as NSError?)?.code && elapsedTime < 1.0 {
                    return true
                }
            }
            
            lastShownError = connectionError
            lastShownErrorTime = CACurrentMediaTime()
            
            if (connectionError as NSError?)?.code == 401 {
                handleAuthenticationError()
                if connectionError?.localizedDescription != nil {
                    showError(withTitle: nil, andMessage: connectionError?.localizedDescription)
                } else {
                    showError(withTitle: nil, andMessage: NSLocalizedString("Your session has expired. Please login again.", comment: ""))
                }
                return true
            }
            
            //            if failure != nil {
            //                failure(connectionError)
            //            }
            
            let message = connectionError?.localizedDescription
            if message != nil {
                showError(withTitle: nil, andMessage: message)
            }
        }
        return connectionError != nil
    */
    }
    
    func showError(withTitle title: String?, andMessage message: String?) {
        var message = message
        if message == nil || (message?.count ?? 0) == 0 {
            message = NSLocalizedString("Error contacting server. Please try again shortly", comment: "")
        }
        
        if errorAlertController == nil {
            errorAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            errorAlertController?.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                self.errorAlertController = nil
            }))
            
            UIApplication.shared.keyWindow?.rootViewController?.present(errorAlertController!, animated: true, completion: nil)
        }
    }
    
    func handleAuthenticationError(){
        
//        if WDBDataManager.isLoggedIn(){
//            let queue = WDBSDKQueueManager.shared
//            queue.cancelAllOperations()
//
//            appDelegate.loadLoginViewController()
//
//            if UIApplication.shared.isIgnoringInteractionEvents {
//                UIApplication.shared.endIgnoringInteractionEvents()
//            }
//
//            self.appDelegate.profiles.removeAll()
//            self.appDelegate.loadLoginViewController()
//
//            UserDefaults.shared.set("", forKey: "userProfiles")
//            UserDefaults.standard.set(nil, forKey: "selectedProfileID")
//
//            UserDefaults.standard.set(false, forKey: "loggedIn")
//            UserDefaults.standard.synchronize()
//            WDBAppDataManager.revokeAccessTokens()
//        }
    }
    
    
    
    /*
    func handleLogin(_ response: URLResponse?, data: Data, error: Error?){
        
        do {
            let tokenDetails = try JSONDecoder().decode(WDBToken.self, from: data)
            
            let wdAccessToken = WDBSDKAccessToken(tokenString: tokenDetails.accessToken, expirationDate: Date().addingTimeInterval(TimeInterval(Int(tokenDetails.expiresIn))), refreshDate: Date())
            WDBSDKAccessToken.setCurrent(wdAccessToken)
            WDBSDKKeychainWrapper.standard.set(tokenDetails.accessToken, forKey: WALLETDOC_ACCESSTOKEN_KEY,withAccessibility: .always)
            
            
            if let expirationTime = wdAccessToken.expirationDate?.timeIntervalSince1970{
                let expiry = "\(expirationTime)"
                
                if expiry != "" {
                    WDBSDKKeychainWrapper.standard.set(expiry, forKey: WALLETDOC_ACCESSTOKEN_EXPIRY,withAccessibility: .always)
                }
            }
            
            if let refreshTime = wdAccessToken.refreshDate?.timeIntervalSince1970{
                let refresh = "\(refreshTime)"
                
                if refresh != "" {
                    WDBSDKKeychainWrapper.standard.set(refresh, forKey: WALLETDOC_ACCESSTOKEN_CREATION,withAccessibility: .always)
                }
            }
            
            if WDBSDKKeychainWrapper.standard.string(forKey: WALLETDOC_REFRESHTOKEN_KEY) != nil{
                WDBSDKKeychainWrapper.standard.removeObject(forKey: WALLETDOC_REFRESHTOKEN_KEY)
            }
            
            WDBSDKKeychainWrapper.standard.set(tokenDetails.refreshToken, forKey: WALLETDOC_REFRESHTOKEN_KEY,withAccessibility: .always)
            
            
            #if !DEBUG
            var deviceTokenKey = WALLETDOC_DEVICE_TOKEN
            #else
            let deviceTokenKey = "\(WALLETDOC_DEVICE_TOKEN)_debug"
            #endif
            
//            if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
//                print(json as! NSDictionary)
//            }
            
            if (tokenDetails.deviceToken.count) > 30 {
                WDBSDKKeychainWrapper.standard.set(tokenDetails.deviceToken, forKey: deviceTokenKey,withAccessibility: .always)
            }
        } catch let error {
            print(error)
        }
    } */
    
    func getFileName(fromHeaderResponse response: URLResponse?) -> String {
        
        var fileName = ""
        
        let httpResponse = response as? HTTPURLResponse
        if httpResponse?.responds(to: #selector(getter: HTTPURLResponse.allHeaderFields)) ?? false {
            let contentDispositon = httpResponse?.allHeaderFields["Content-Disposition"] as? String
            fileName = String.filename(fromContentDispositionHeader: contentDispositon) ?? ""
        }
       
        // print("filename :- \(fileName)")
        
        return fileName
    }

    

    // MARK: - Cancel

    override func cancel() {
        super.cancel()
        finish()
    }
}
