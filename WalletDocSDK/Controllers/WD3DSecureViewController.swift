//
//  WD3DSecureViewController.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 23/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit

@objc protocol WD3DSecureViewControllerDelegate: NSObjectProtocol {
    func wd3DSecureViewController(_ vc: WD3DSecureViewController?, completed3DSecureRedirectWithPayload payload: String?, andMD md: String?, cvv: String?)
    
    @objc optional func wd3DSecureViewController(_ vc: WD3DSecureViewController?, failedWithError error: Error?)
    @objc optional func wd3DSecureViewControllerCancelled(_ vc: WD3DSecureViewController?)
    @objc optional func wd3DSecureViewController(_ vc: WD3DSecureViewController?, cvvSet cvv: String?)
}

public class WD3DSecureViewController: UIViewController,UIWebViewDelegate,UIScrollViewDelegate, UITextFieldDelegate {
    
    weak var delegate: WD3DSecureViewControllerDelegate?
    var securePaymentRedirect: WDSecurePaymentRedirect?
    
    @IBOutlet private weak var cvvTextField: UITextField!
    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var cvvScrollView: UIScrollView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var securityMessageLabel: UILabel!
    @IBOutlet private weak var cvvHelpImageView: UIImageView!
    
    @IBOutlet private weak var navigationBar: UINavigationBar!
    
    private var cvv: String?
    private var paRes: String?
    private var md: String?
    private var bReadyToRedirect = false
    private var maxCvvLength = 0
    private var kbSize = CGSize.zero
    
    
    override public func viewDidLoad(){
        super.viewDidLoad()
        
        maxCvvLength = 3
        bReadyToRedirect = false
        
        webView?.delegate = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        initViewFromSecurePaymentRedirect()
        
        // Firebase logevent.
        #if !DEBUG
        FIRAnalytics.logEvent(withName: "3d Secure", parameters: nil)
        #endif
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        removeKeyboardObservers()
    }
    
    func setSecurePaymentRedirect(_ securePaymentRedirect: WDSecurePaymentRedirect?) {
        self.securePaymentRedirect = securePaymentRedirect
        if self.isViewLoaded {
            initViewFromSecurePaymentRedirect()
        }
    }
    
    func initViewFromSecurePaymentRedirect() {
    
        //securityMessageLabel.text = securePaymentRedirect.message
        
        if securePaymentRedirect?.cvvRequired == false {
            cvvScrollView.isHidden = true
            webView?.isHidden = false
            activityIndicator.isHidden = false
        } else {
            addKeyboardObservers()
            
            if securePaymentRedirect?.issuer != .AMEX {
                securityMessageLabel.text = NSLocalizedString("Please enter the 3 digit CVV number found on the back of your card", comment: "")
                cvvHelpImageView.image = UIImage(named: "cvv_Help")
                maxCvvLength = 3
            } else {
                securityMessageLabel.text = NSLocalizedString("Please enter the 4 digit CVV number found on the front of your American Express card", comment: "")
                cvvHelpImageView.image = UIImage(named: "cvv_Help_Amex")
                maxCvvLength = 4
            }
            //self.webView.hidden = YES;
            webView?.isHidden = false
            cvvScrollView.isHidden = false
            cvvScrollView.isScrollEnabled = true
            
            cvvTextField.becomeFirstResponder()
        }
        
        if let redirectString = securePaymentRedirect?.getRedirectHtml(){
            webView?.loadHTMLString(redirectString, baseURL: nil)
        }
        
        
        self.navigationBar.barTintColor = UIColor(red: 0.0, green: 131/255, blue: 201/255, alpha: 1.0)
        self.navigationBar.isTranslucent = false
        self.navigationBar.tintColor = UIColor.white

        let addItemShadow = NSShadow()
         addItemShadow.shadowColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.15)
         addItemShadow.shadowOffset = CGSize(width: 1.5, height: 1.5)
         addItemShadow.shadowBlurRadius = 0.5
         
         let font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
         var attributes: [NSAttributedString.Key: Any]? = nil
         
         attributes = [
             NSAttributedString.Key.font: font,
             NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.shadow: addItemShadow
         ]
         
         self.navigationBar.titleTextAttributes = attributes
    }
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        if cvvTextField.text?.count ?? 0 < maxCvvLength {
            
            //WDNotificationManager.sharedInstance().dismissAllVisibleNotificationViews(true)
            //let msg = "The CVV must be \(maxCvvLength) digits long"
            //WDNotificationManager.sharedInstance().addNotificationMessage(msg, type: WDNotificationTypeError, userInfo: nil)
                        
            WDNotificationManager.sharedInstance.dismissAllVisibleNotificationViews(true)
            let msg = "The CVV must be \(maxCvvLength) digits long"
            WDNotificationManager.sharedInstance.addNotificationMessage(msg, type: .WDNotificationTypeError, userInfo: nil)
           
            return
        }
        
        if webView?.isLoading == true {
            activityIndicator.isHidden = false
        }
        
        cvvTextField.endEditing(true)
        cvv = cvvTextField.text
    
        self.delegate?.wd3DSecureViewController?(self, cvvSet: cvv)
    
        if bReadyToRedirect{
            self.delegate?.wd3DSecureViewController(self, completed3DSecureRedirectWithPayload: paRes, andMD: md, cvv: cvv)
            dismiss(animated: true)
            return
        }
        
        securityMessageLabel.text = NSLocalizedString("For your protection, walletdoc will redirect you to your bank to verify your card.", comment: "")
        
        UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: [], animations: {
            self.cvvScrollView.alpha = 0.0
        }) { finished in
            self.cvvScrollView.isHidden = true
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.delegate?.wd3DSecureViewControllerCancelled?(self)
        dismiss(animated: true)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - UITextFieldDelegate
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // only allow numbers
        if (string as NSString).rangeOfCharacter(from: CharacterSet.decimalDigits.inverted).location != NSNotFound {
            return false
        }
        
        var text = textField.text
        
        text = (text as NSString?)?.replacingCharacters(in: range, with: string)
        
        if (text?.count ?? 0) > maxCvvLength {
            return false
        }
        
        return true
    }
    
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.isHidden = true
        
        webView.scrollView.delegate = self
        webView.scrollView.maximumZoomScale = 5
        webView.scrollView.minimumZoomScale = 1
    }
    
    public func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        webView?.scrollView.maximumZoomScale = 5
    }
    
    // MARK: - UIWebViewDelegate
    
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebView.NavigationType) -> Bool {
        if (request.url?.absoluteString == "https://localhost/") && request.httpBody != nil {
            var bodyStr: String? = nil
            if let HTTPBody = request.httpBody {
                bodyStr = String(data: HTTPBody, encoding: .utf8)
            }
            var bodyDic: [AnyHashable : Any] = [:]
            let keyValueArray = bodyStr?.components(separatedBy: "&")
            for keyValueStr in keyValueArray ?? [] {
                let components = keyValueStr.components(separatedBy: "=")
                if components.count == 2 {
                    bodyDic[components[0]] = components[1].removingPercentEncoding ?? ""
                }
            }
            
            paRes = bodyDic["PaRes"] as? String
            md = bodyDic["MD"] as? String
            bReadyToRedirect = true
            
            if (cvvScrollView.isHidden == true || cvvScrollView.alpha < 1.0)   {
                self.delegate?.wd3DSecureViewController(self, completed3DSecureRedirectWithPayload: paRes, andMD: md, cvv: cvv)
                dismiss(animated: true)
                return false
            }
        }
        
        return true
    }
    
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        if (error as NSError).code == NSURLErrorCancelled {
            print("Error : \(error)")
            return
        }
        
        self.confirmationAlert(title: "Error", message: error.localizedDescription,isDestructive: false, approveButtonText:"OK", denyButtonText:"Cancel") { (result) in
            if result {
                self.delegate?.wd3DSecureViewController?(self, failedWithError: error)
                self.dismiss(animated: true)
            }
        }
    }
    
    // MARK: - Observer
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Notifications
    
    @objc func keyboardWillShow(notification: Notification) {
        if view.bounds.size.height <= 480.0 {
            let info = notification.userInfo
            kbSize = (info?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue.size
            
            let contentInsets = UIEdgeInsets(top: 0.0, left: 0, bottom: kbSize.height, right: 0.0)
            cvvScrollView.contentInset = contentInsets
            cvvScrollView.scrollIndicatorInsets = contentInsets
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        //NSDictionary* info = [notification userInfo];
        
        if view.bounds.size.height <= 480.0 {
            let contentInsets: UIEdgeInsets = .zero
            cvvScrollView.contentInset = contentInsets
            cvvScrollView.scrollIndicatorInsets = contentInsets
        }
    }
}
