//
//  WDSDK.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

let WALLETDOC_REFRESHTOKEN_KEY = "walletdocRefreshToken"
let WALLETDOC_ACCESSTOKEN_KEY = "walletdocAccessToken"
let WALLETDOC_ACCESSTOKEN_EXPIRY = "walletdocAccessExpiry"
let WALLETDOC_ACCESSTOKEN_CREATION = "walletdocAccessCreationDate"
let WALLETDOC_DEVICE_TOKEN = "walletdocDeviceToken"

//import Crashlytics
//import Fabric

    public class WDSDK: NSObject {

    static let sharedInstance = WDSDK()
    
    static var publicKey = ""
    static var secretKey = ""
    
    // Check this later.
    
    //fileprivate let appDataManager = WDBAppDataManager()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        if Bundle.main.object(forInfoDictionaryKey: "WalletDocAppID") == nil {
            print("WalletDocAppID not found in Application's Info.plist. Please provide a valid Application Key.")
            return false
        }
        
        //        loginLogOutOperation = nil
        
        // Check this later.
        
//        guard WDBSDKKeychainWrapper.standard.string(forKey: WALLETDOC_REFRESHTOKEN_KEY) != nil else{
//            return true
//        }
        
        // Check this later.

//       appDataManager.refreshCurrentAccessToken()
        
        
//        refreshCurrentAccessToken(nil)
        
        //Refresh the Access Token.
  //      let refreshToken = WalletDoc_SDK_KeychainWrapper.keychainStringFrom(matchingIdentifier: WALLETDOC_REFRESHTOKEN_KEY)
    //    if refreshToken != nil {
            
      //  }
        return true
    }
    
    public class func initialize(publickey: String, secretkey: String){
        self.publicKey = publickey
        self.secretKey = secretkey
    }
    
    public class func getCardViewController() -> WDAddCardViewController?{
        let myBundle = Bundle(for: self)
        let storyboard = UIStoryboard(name: "Main", bundle: myBundle)
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addCardViewController = storyboard.instantiateViewController(withIdentifier: "addCardViewController") as? WDAddCardViewController
        return addCardViewController
    }
    
    /*

    private var OperationsChangedContext = "OperationsChangedContext"
    let LOGIN_REQUEST = "Login"
    let LOGOUT_REQUEST = "Logout"
    var loginLogOutOperation: WalletDoc_SDK_URLInvocation? = nil
    var dateFormatter: DateFormatter? = nil
    var enUSPOSIXLocale: NSLocale? = nil
    
    
 //   class WalletDoc_SDK {
    
        private var host = ""
        
        static let sharedInstanceSharedSDKInstance: WalletDoc_SDK? = {
            var sharedSDKInstance = self.init()
            return sharedSDKInstance
        }()
        
        class func sharedInstance() -> Any? {
            // `dispatch_once()` call was converted to a static variable initializer
            return sharedInstanceSharedSDKInstance
        }
        
        init() {
            //if super.init()
            
            #if DEBUG
            host = "www.walletdoc.tech"
            #else
            Fabric.with([Crashlytics.self])
            host = "www.walletdoc.com"
            #endif
            
            queue = OperationQueue()
            //[_queue setMaxConcurrentOperationCount:1];
            queue.addObserver(self as NSObject, forKeyPath: "operations", options: [], context: &OperationsChangedContext)
            
            dateFormatter = DateFormatter()
            enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
            if let enUSPOSIXLocale = enUSPOSIXLocale {
                dateFormatter?.locale = enUSPOSIXLocale as Locale
            }
            dateFormatter?.dateFormat = "yyyy-MM-dd"
            
            loadAccessToken()
            
        }
        
        func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if context == OperationsChangedContext {
                //NSLog(@"Queue size: %lu", (unsigned long)[[_queue operations] count]);
            } else {
                super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            }
        }

    
        
        func add(_ request: WDRequest?, completionHandler handler: WDSDK_RequestHandler) {
            request?.urlComponents.host = host
            request?.urlComponents.scheme = "https"
            
            //Check for expiry of token if token is expired we place a refresh token invocation in the queue...
            let SDKAccessToken = WalletDoc_SDK_AccessToken.currentAccessToken()
            if SDKAccessToken != nil && WalletDoc_SDK_AccessToken.isTokenExpired() {
                refreshCurrentAccessToken(nil)
                print("Refreshing token due to it being expired")
            }
            
            let invocation = WalletDoc_SDK_URLInvocation(request: request, operationQueue: queue, handlerCallback: handler)
            
            if request?.userData == LOGIN_REQUEST || request?.userData == LOGOUT_REQUEST {
                //invocation.queuePriority = NSOperationQueuePriorityVeryHigh;
                //Set the login/logout operation as dependent operation for any other operations that are fired after this operation
                if loginLogOutOperation != nil {
                    //If login operation is not finished then this operation is dependent on login operation.
                    if let loginLogOutOperation = loginLogOutOperation {
                        invocation.addDependency(loginLogOutOperation)
                    }
                } else {
                    loginLogOutOperation = invocation
                }
            } else {
                //If operation is not /login and /logout operation is not finished.
                if loginLogOutOperation != nil {
                    //If login operation is not finished then this operation is dependent on login operation.
                    if let loginLogOutOperation = loginLogOutOperation {
                        invocation.addDependency(loginLogOutOperation)
                    }
                }
            }
            
            queue.add(invocation)
        }
        
        func addFileRequest(_ request: WDRequest?, completionHandler handler: WDSDK_FileRequestHandler) {
            request?.urlComponents.host = host
            request?.urlComponents.scheme = "https"
            
            //Check for expiry of token if token is expired we place a refresh token invocation in the queue...
            let SDKAccessToken = WalletDoc_SDK_AccessToken.currentAccessToken()
            if SDKAccessToken != nil && WalletDoc_SDK_AccessToken.isTokenExpired() {
                refreshCurrentAccessToken(nil)
            }
            
            let invocation = WalletDoc_SDK_FileURLInvocation(request: request, operationQueue: queue, handlerCallback: handler)
            
            if loginLogOutOperation != nil {
                //If login operation is not finished then this operation is dependent on login operation.
                if let loginLogOutOperation = loginLogOutOperation {
                    invocation.addDependency(loginLogOutOperation)
                }
            }
            
            queue.add(invocation)
        }
        
        */

    ///}
    
}
