//
//  WDTransactionViewController.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 19/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit

public class WDTransactionViewController: UIViewController,WD3DSecureViewControllerDelegate {
    
    var clientSecret = ""
    var cvv = ""
    var paymentMethodID = ""
    var transactionID = ""
    
    @IBOutlet weak var paymentMethodIDLabel: UILabel!
    @IBOutlet weak var cvvLabel: UILabel!
    @IBOutlet weak var secretLabel: UILabel!
    
    @IBOutlet weak var createPaymentButton: UIButton!
    @IBOutlet weak var processPaymentButton: UIButton!
    
    fileprivate let transactionDataManager = WDTransactionDataManager()
    
    
    // MARK: - viewDidLoad
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        processPaymentButton.isEnabled = false
        
        cvvLabel.text = cvv
        paymentMethodIDLabel.text = paymentMethodID
    }
    
    // MARK: - Create Payment
    
    @IBAction func createPaymentClicked(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.showModalProgressView()
        }
        
        var createTransactionRequest = WDCreateTransactionRequest()
        
        createTransactionRequest.amount = 100.0
        // Check this
        createTransactionRequest.capture = true
        createTransactionRequest.currency = "ZAR"
        createTransactionRequest.customerId = ""
        createTransactionRequest.paymentMethodId = paymentMethodID
        
        transactionDataManager.createTransaction(createTransactionRequest) { (result) in
            
            self.hideModalProgressView()
            
            switch result{
            case .failure(let error):
                Utility.showAlert(on: self, forErrorMessage: error.localizedDescription)
            case .success(let createTransactionResponse):
                self.secretLabel.text = createTransactionResponse.clientSecret
                self.clientSecret = createTransactionResponse.clientSecret
                self.transactionID = createTransactionResponse.id
                self.processPaymentButton.isEnabled = true
            }
        }
    }
    
    // MARK: - Process Payment
    
    @IBAction func processPaymentClicked(_ sender: Any) {
        
        DispatchQueue.main.async {
            self.showModalProgressView()
        }
        
        var processTransactionRequest = WDProcessTransactionRequest()
        processTransactionRequest.id = transactionID
        processTransactionRequest.clientSecret = clientSecret
        processTransactionRequest.cvv = "123"
        
        transactionDataManager.processTransaction(processTransactionRequest) { (result) in
            self.hideModalProgressView()
            
            switch result{
            case .failure(let error):
                self.completionAlert(title:"Error" , message: error.localizedDescription, completion: {
                    self.popCurrentView()
                })
            case .success(let processTransactionResponse):
                
                if processTransactionResponse.status == "awaiting_authentication"{
                    self.performSegue(withIdentifier: "3DSecureSegue", sender: processTransactionResponse.redirect)
                }else{
                    if processTransactionResponse.status == "awaiting_capture"{
                        self.completionAlert(title:"Success" , message: "Awaiting capture", completion: {
                            self.popCurrentView()
                        })
                    } else if processTransactionResponse.status == "successful"{
                        self.completionAlert(title:"Success" , message: "Payment successful", completion: {
                            self.popCurrentView()
                        })
                    } else if processTransactionResponse.status == "failed"{
                        self.completionAlert(title:"Error" , message: "Payment failed", completion: {
                            self.popCurrentView()
                        })
                    }
                }
                print("\(processTransactionResponse)")
            }
        }
    }
    
    func popCurrentView(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -  wd3DSecureViewControllerDelegate
    
    func wd3DSecureViewController(_ vc: WD3DSecureViewController?, completed3DSecureRedirectWithPayload payload: String?, andMD md: String?, cvv: String?){
        
        DispatchQueue.main.async {
            self.showModalProgressView()
        }
        
        var processTransactionWithSessionRequest = WDProcessTransactionWithSessionRequest()
        
        processTransactionWithSessionRequest.id = transactionID
        // Check this
        processTransactionWithSessionRequest.clientSecret = clientSecret
        processTransactionWithSessionRequest.payload = payload ?? ""
        processTransactionWithSessionRequest.cvv = cvv ?? ""
        processTransactionWithSessionRequest.sessionID = md ?? ""
        
        transactionDataManager.processTransactionWithSessionID(processTransactionWithSessionRequest) { (result) in
            self.hideModalProgressView()
            switch result{
            case .failure(let error):
                self.completionAlert(title:"Error" , message: error.localizedDescription, completion: {
                    self.popCurrentView()
                })
            case .success(let processTransactionResponse):
                
                if processTransactionResponse.status == "awaiting_capture"{
                    self.completionAlert(title:"Success" , message: "Awaiting capture", completion: {
                        self.popCurrentView()
                    })
                } else if processTransactionResponse.status == "successful"{
                    self.completionAlert(title:"Success" , message: "Payment successful", completion: {
                        self.popCurrentView()
                    })
                } else if processTransactionResponse.status == "failed"{
                    self.completionAlert(title:"Error" , message: "Payment failed", completion: {
                        self.popCurrentView()
                    })
                }
            }
        }
        
        
        
        /*
         
         if(self.isViewLoaded && self.view.window) {
         [self showModalProgressView];
         }
         
         [[ServerManager sharedManager] makePaymentWithSessionID:md payload:payload cvv:cvv success:^(id response) {
         // log to analytics
         /*   [Answers logCustomEventWithName:@"Payment Success"
         customAttributes:@{}]; */
         
         [Answers logPurchaseWithPrice:nil
         currency:@"ZAR"
         success:@YES
         itemName:nil
         itemType:nil
         itemId:nil
         customAttributes:@{}];
         
         
         [self postNotificationOnBillPaymentStatus:YES];
         self.processing3DSecurePayment = NO;
         [self hideModalProgressView];
         [self showPaymentResult:response];
         } failure:^(NSError *error) {
         [self postNotificationOnBillPaymentStatus:NO];
         [self.payButton setEnabled:YES];
         [self hideModalProgressView];
         self.processing3DSecurePayment = NO;
         }];
         */
        
    }
    
    func wd3DSecureViewController(_ vc: WD3DSecureViewController?, failedWithError error: Error?){
        self.completionAlert(title:"Error" , message: error?.localizedDescription ?? "Payment failed", completion: {
                self.popCurrentView()
        })
    }
    
    func wd3DSecureViewControllerCancelled(_ vc: WD3DSecureViewController?){
    }
    
    func wd3DSecureViewController(_ vc: WD3DSecureViewController?, cvvSet cvv: String?){
        self.cvv = cvv ?? ""
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "3DSecureSegue") {
            let vc = segue.destination as? WD3DSecureViewController
            vc?.delegate = self
            vc?.securePaymentRedirect = sender as? WDSecurePaymentRedirect
          //  vc?.securePaymentRedirect?.cvvRequired = true
        }
    }
}
