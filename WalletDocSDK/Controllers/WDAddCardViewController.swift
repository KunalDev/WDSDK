//
//  WDAddCardViewController.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 14/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit

public class WDAddCardViewController: UIViewController,UITextFieldDelegate {
    
    fileprivate let cardDataManager = WDCardDataManager()
    
    @IBOutlet weak var cardNumberTextField: WDMaskTextField!
    @IBOutlet weak var expiryDateTextField: WDMaskTextField!
    @IBOutlet weak var cvvTextField: WDMaskTextField!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!
    
    @IBOutlet weak var cardTypeImageView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var creditCardView: UIView!
    
    @IBOutlet weak var helperView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var storyBoard: UIStoryboard!
    
   // let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    /* @property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *separatorConstraintArray;*/
    
    var invalidMonthNotificationView: WDNotificationView?
    var invalidDateNotificationView: WDNotificationView?
    
    
    public var isSecurePayment = false
    
    // MARK: - ViewLifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let myBundle = Bundle(for: type(of: self))
        storyBoard = UIStoryboard(name: "Main", bundle: myBundle)
        
        
        self.customizeViews()
        self.addKeyboardObservers()
        self.setGeneralSettingsForCurrentMode()
        self.setNavigationBar()
    }
    
    func setNavigationBar(){
        
        self.navigationItem.title = "Payment Gateway"
        
        //   self.navigationController?.navigationBar.isHidden = true
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0, green: 131/255, blue: 201/255, alpha: 1.0)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
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
        
        self.navigationController?.navigationBar.titleTextAttributes = attributes
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardObservers()
    }
    
    func setGeneralSettingsForCurrentMode() {
        addShadowForHelperView()
        
        cardNumberTextField.inputAccessoryView = helperView
        cardHolderTextField.inputAccessoryView = helperView
        nicknameTextField.inputAccessoryView = helperView
        expiryDateTextField.inputAccessoryView = helperView
        cvvTextField.inputAccessoryView = helperView
    }
    
    func addShadowForHelperView() {
        let shadowPath = UIBezierPath(rect: helperView.bounds)
        helperView.layer.shadowPath = shadowPath.cgPath
        helperView.layer.masksToBounds = false
        helperView.layer.shadowColor = UIColor.black.cgColor
        helperView.layer.shadowOpacity = 0.5
        helperView.layer.shadowRadius = 10.0
        helperView.layer.shadowOffset = CGSize(width: 0, height: -5.0)
    }
    
    func updateHelperButtons() {
        prevButton.isEnabled = !cardHolderTextField.isFirstResponder
        nextButton.isEnabled = !nicknameTextField.isFirstResponder
    }
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func nextHelperAction(_ sender: Any) {
        if cardHolderTextField.isFirstResponder {
            cardNumberTextField.becomeFirstResponder()
        } else if cardNumberTextField.isFirstResponder {
            expiryDateTextField.becomeFirstResponder()
        } else if expiryDateTextField.isFirstResponder {
            cvvTextField.becomeFirstResponder()
        } else if cvvTextField.isFirstResponder {
            nicknameTextField.becomeFirstResponder()
        }
    }
    
    @IBAction func previosHelperAction(_ sender: Any) {
        if nicknameTextField.isFirstResponder {
            cvvTextField.becomeFirstResponder()
        } else if cvvTextField.isFirstResponder {
            expiryDateTextField.becomeFirstResponder()
        } else if expiryDateTextField.isFirstResponder {
            cardNumberTextField.becomeFirstResponder()
        } else if cardNumberTextField.isFirstResponder {
            cardHolderTextField.becomeFirstResponder()
        }
    }
    
    // MARK: - ViewSetup
    
    func addKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    @objc func keyboardWillShow(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 300, right: 0)
    }
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = .zero
    }
    
    func customizeViews() {
        let borderColor = UIColor(red: 205 / 255.0, green: 205 / 255.0, blue: 205 / 255.0, alpha: 1.0)
        self.customize(cardTypeImageView, withCornerRadius: 7.0, borderWidth: 0.5, borderColor: borderColor)
        self.customize(creditCardView, withCornerRadius: 7.0, borderWidth: 1.0, borderColor: borderColor)
    }
    
    func customize(_ view: UIView, withCornerRadius radius: CGFloat, borderWidth width: CGFloat, borderColor color: UIColor?) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.layer.borderWidth = width
        view.layer.borderColor = color?.cgColor
    }
    
    // MARK: - Add Card Clicked
    
    @IBAction func addCardClicked(_ sender: Any) {
        let card = collectData()
        if isCardValid(card) {
            makeAddCardRequest(with: card)
        }
    }
    
    func makeAddCardRequest(with tokenRequest: WDTokenRequest) {
        
        DispatchQueue.main.async {
            self.showModalProgressView(in: self.creditCardView)
        }
        
        cardDataManager.generateToken(tokenRequest) { (result) in
            
            self.hideModalProgressView(in: self.creditCardView)
            
            switch result{
            case .failure(let error):
                Utility.showAlert(on: self, forErrorMessage: error.localizedDescription)
            case .success(let accountResponse):
                if self.isSecurePayment{
                    self.completionAlert(title:"Success" , message: "Token Generated", completion: {
                        self.navigateToProcessPayment(paymentMethodID: accountResponse.id, CVV: self.cvvTextField.text!)
                    })
                }else{
                    Utility.showAlert(on: self, withTitle: "Success", andMessage: "Token Generated")
                }
                print("\(accountResponse)")
            }
        }
    }
    
    func navigateToProcessPayment(paymentMethodID: String, CVV: String){
        let controller =  storyBoard.instantiateViewController(withIdentifier: "transactionViewController") as? WDTransactionViewController
        if let controller = controller {
            controller.paymentMethodID = paymentMethodID
            // controller.cvv = "123"
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func collectData() -> WDTokenRequest {
        
        
        // ======
        
        
        
        
        //        var tokenRequest = WDTokenRequest()
        //
        //            tokenRequest.nickname = "test"
        //            tokenRequest.cardholder = "Jane Jones"
        //
        //            tokenRequest.number = "4038220000353021"
        //
        //            tokenRequest.expiryMonth = "11"
        //            tokenRequest.expiryYear = "2021"
        //
        //            tokenRequest.cvv = "283"
        //            return tokenRequest
        
        
        
        // autoAuthenticate = true/false
        
        var tokenRequest = WDTokenRequest()
        
        tokenRequest.nickname = "test"
        tokenRequest.cardholder = "Jane Jones"
        
        tokenRequest.number = "2223600089020329"
        
        tokenRequest.expiryMonth = "12"
        tokenRequest.expiryYear = "2025"
        
        tokenRequest.cvv = "123"
        return tokenRequest
        
        
        //var autoAuthenticate = "true"
        
        //                {
        //                    amount = 100;
        //                    capture = 0;
        //                    "charged_amount" = 0;
        //                    currency = ZAR;
        //                    "customer_id" = "<null>";
        //                    id = e718b294e0494a9fb05940f1cf9d8e2c;
        //                    "payment_method_id" = "ct_c22f6c09fa1a442b9b1e6840cb0f31d1";
        //                    redirect =     {
        //                        "authentication_url" = "https://www.walletdoc.tech/authenticate";
        //                        "transaction_id" = e718b294e0494a9fb05940f1cf9d8e2c;
        //                    };
        //                    status = "awaiting_authentication";
        //                }
        
        //var autoAuthenticate = "false"
        
        //        {
        //            amount = 100;
        //            capture = 0;
        //            "charged_amount" = 0;
        //            currency = ZAR;
        //            "customer_id" = "<null>";
        //            id = 1331f077646347c886af8c4f8fa24f21;
        //            "payment_method_id" = "ct_296195e3894e48b38e51608fd1f89f2a";
        //            redirect =     {
        //                "authentication_url" = "https://acsabsatest.bankserv.co.za/mdpayacs/pareq";
        //                "cvv_required" = 0;
        //                payload = "eJxVUdtSwjAQ/ZUOH9B0WzpYZslMERx5gIEKzshbTFbpKCmkLaBfb1Ja0aecs5eT3bO43hmiyRPJ2hDHOZWleCcvV6PeMlsld8Egjvo9jss0oyPHE5kyLzQHP/BDZB21fUbuhK44CnkczxYcAJC1GPdkZhMOYYTsClGLPfGx0B8lmVP6ZnIpvE4DWZNFWdS6Ml98AAGyjmBtPvmuqg7lkLHz+ey/tiK+LPxvgczlkd3mWdYOlVbvkis+/15sFwGsV6CyNajJPFDbzfR5unl4GSFzFahERTwMIIEwjDyAYZQMoz6yJo5i7wbh2zTzrAd2sDaAB/dPeiXgEn8DaN01pGW3TMeQLodCk62wZv5iVFRKu0T73Da4f3T+yso6mEQxQNxvTG4CTiq3BoUxXLUcQeZaWHs81l7Xon9X/wH1IKsN";
        //                "return_url" = "https://www.walletdoc.tech/completePayment";
        //                "session_id" = 94c3481db4f04721959a798fe8141c8f;
        //            };
        //            status = "awaiting_authentication";
        //        }
        
        
        // ======
        
        
        // ======
        
        
        //        var tokenRequest = WDTokenRequest()
        //
        //        tokenRequest.nickname = "test A"
        //        tokenRequest.cardholder = "Dan"
        //
        //        tokenRequest.number = "5413330089020060"
        //
        //        tokenRequest.expiryMonth = "12"
        //        tokenRequest.expiryYear = "2025"
        //
        //        tokenRequest.cvv = "123"
        //        return tokenRequest
        
        
        //            // capture - true
        //            {
        //                amount = 100;
        //                capture = 1;
        //                "charged_amount" = 100;
        //                currency = ZAR;
        //                "customer_id" = "<null>";
        //                id = f43bbc5708074376be5daf2595496c45;
        //                "payment_method_id" = "ct_2dbe21a3fa96476f8e70083a730e73cf";
        //                status = successful;
        //        }
        //        capture - false
        //        {
        //            amount = 100;
        //            capture = 0;
        //            "charged_amount" = 0;
        //            currency = ZAR;
        //            "customer_id" = "<null>";
        //            id = b733aff44e9f4339a1df886cbbc65f00;
        //            "payment_method_id" = "ct_f7849b7f47e148bf8fdbf6ee592b3910";
        //            status = "awaiting_capture";
        //        }
        
        
        // ======
        
        
        
        //        var tokenRequest = WDTokenRequest()
        //
        //             tokenRequest.nickname = "test A"
        //             tokenRequest.cardholder = "Dan"
        //
        //             tokenRequest.number = "5239090000095029"
        //
        //             tokenRequest.expiryMonth = "11"
        //             tokenRequest.expiryYear = "2021"
        //
        //             tokenRequest.cvv = "587"
        //             return tokenRequest
        
        
        
        
//                var tokenRequest = WDTokenRequest()
//        
//                tokenRequest.cardholder = cardHolderTextField.text ?? ""
//                tokenRequest.nickname = nicknameTextField.text ?? ""
//                // remove formatting from the card number
//                tokenRequest.number = (cardNumberTextField.text ?? "").replacingOccurrences(of: " ", with: "")
//                tokenRequest.cvv = cvvTextField.text ?? ""
//        
//                let expireString = expiryDateTextField.text ?? ""
//                let expireArray = expireString.components(separatedBy: "/")
//                if expireArray.count == 2 {
//        
//                    tokenRequest.expiryMonth =  expireArray[0] //NSNumber(value: Int(expireArray[0]) ?? 0)
//                    let expiryYear = getFullYear(fromTwoDigitString: expireArray[1])
//                    tokenRequest.expiryYear = String(expiryYear) //NSNumber(long: expiryYear)
//                }
//                return tokenRequest
    }
    
    func getFullYear(fromTwoDigitString yearString: String?) -> Int {
        if (yearString?.count ?? 0) != 2 {
            return -1
        }
        
        var expiryYear: Int
        
        let yearTwoDigits = Int(yearString ?? "") ?? 0
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: Date())
        
        // assume credit cards can be valid up to 20 years for handling of new century
        let currentYearTwoDigits = currentYear % 100
        if currentYearTwoDigits >= 80 {
            if yearTwoDigits <= (currentYearTwoDigits + 20 - 100) {
                expiryYear = currentYear + 100 - currentYearTwoDigits + yearTwoDigits
            } else {
                expiryYear = currentYear - currentYearTwoDigits + yearTwoDigits
            }
        } else {
            expiryYear = currentYear - currentYearTwoDigits + yearTwoDigits
        }
        
        return expiryYear
    }
    
    func isCardValid(_ card: WDTokenRequest) -> Bool {
        var errorString: String? = nil
        let issuer = CreditCardUtility.identifyCreditCardIssuer(card.number)
        
        if card.cardholder == "" || card.number == "" || card.cvv == "" || card.expiryMonth == "" || card.expiryYear == "" {
            errorString = NSLocalizedString("Please fill in all required fields", comment: "")
        } else if !CreditCardUtility.isCreditCardNumberValid(card.number) {
            errorString = NSLocalizedString("Credit Card number is not valid!", comment: "")
        } else if issuer == .AMEX && card.cvv.count != 4 {
            errorString = NSLocalizedString("CVV should contain 4 numbers", comment: "")
        } else if issuer != .AMEX && card.cvv.count != 3 {
            errorString = NSLocalizedString("CVV should contain 3 numbers", comment: "")
        } else {
            // get date for start of this month
            let calendar = Calendar.current
            let todayDate = calendar.dateComponents([], from: Date())
            var components = DateComponents()
            components.day = 0
            components.month = todayDate.month
            components.year = todayDate.year
            let dateCompare = calendar.date(from: components) ?? Date()
            
            if card.expiryDate()?.compare(dateCompare) == .orderedAscending {
                errorString = NSLocalizedString("Expiry date can't be in past", comment: "")
            }
        }
        
        if errorString != nil {
            Utility.showAlert(on: self, forErrorMessage: errorString)
            return false
        }
        return true
    }
    
    func updateCardIssuer(fromCardNumber cardNumber: String?) {
        let issuer = CreditCardUtility.identifyCreditCardIssuer(cardNumber)
        
        switch issuer {
        case .AMEX:
            cardTypeImageView.image = UIImage(named: "Payment_Method_Amex")
        case .DINERSCLUB:
            cardTypeImageView.image = UIImage(named: "Payment_Method_Diners")
        case .MASTERCARD:
            cardTypeImageView.image = UIImage(named: "Payment_Method_Mastercard")
        case .VISA:
            cardTypeImageView.image = UIImage(named: "Payment_Method_Visa")
        case .UNKNOWN:
            cardTypeImageView.image = UIImage(named: "Payment_Method_Unknown")
        default:
            cardTypeImageView.image = nil
        }
        
        switch issuer {
        case .AMEX:
            cvvTextField.formatPattern = "####"
            cardNumberTextField.formatPattern = "#### ###### #####"
            cvvTextField.placeholder = NSLocalizedString("CVV (4 digits)", comment: "")
        case .UNKNOWN:
            cvvTextField.formatPattern = "####"
            cvvTextField.placeholder = NSLocalizedString("CVV", comment: "")
            cardNumberTextField.formatPattern = "#### #### #### ####"
        case .DINERSCLUB:
            cardNumberTextField.formatPattern = "#### ###### ####"
            cvvTextField.formatPattern = "###"
            cvvTextField.placeholder = NSLocalizedString("CVV (3 digits)", comment: "")
        default:
            cardNumberTextField.formatPattern = "#### #### #### ####"
            cvvTextField.formatPattern = "###"
            cvvTextField.placeholder = NSLocalizedString("CVV (3 digits)", comment: "")
        }
    }
    
    // MARK: - Textfield delegate 
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == cardNumberTextField {
            //    var text = textField.text
            //   updateCardIssuer(fromCardNumber: text)
            
            
            var text = textField.text
            
            if range.location >= CreditCardUtility.maxFormattedCreditCardLength(text) {
                return false
            }
            
            let oldLength = text?.count ?? 0
            
            text = (text as NSString?)?.replacingCharacters(in: range, with: string)
            updateCardIssuer(fromCardNumber: text)
            text = CreditCardUtility.formatCreditCardString(text)
            
            let beginning = textField.beginningOfDocument
            let start = textField.position(from: beginning, offset: range.location)
            
            textField.text = text
            
            let newLength = text?.count ?? 0
            var cursorOffset: Int? = nil
            if let start = start {
                cursorOffset = textField.offset(from: beginning, to: start)
            }
            cursorOffset! += newLength - oldLength
            
            // special case when a character is deleted
            if newLength < oldLength {
                cursorOffset = (cursorOffset ?? 0) + 1
            }
            
            let newCursorPosition = textField.position(from: textField.beginningOfDocument, offset: cursorOffset ?? 0)
            var newSelectedRange: UITextRange? = nil
            if let newCursorPosition = newCursorPosition {
                newSelectedRange = textField.textRange(from: newCursorPosition, to: newCursorPosition)
            }
            textField.selectedTextRange = newSelectedRange
            
            
            // return false to let ios know that we handled the text change ourselves
            return false
        }else if textField == expiryDateTextField {
            
            //let text = textField.text.replacingCharacters(in: range, with: string)
            
            //let maxLength = 4
            let currentString: NSString = textField.text! as NSString
            let text: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            
            //return newString.length <= maxLength
            
            let textFieldText = textField.text ?? ""
            
            // remove any visible notification if user deleted a character
            if text.length < textFieldText.count{
                if (invalidMonthNotificationView != nil) {
                    WDNotificationManager.sharedInstance.remove(invalidMonthNotificationView, animated: true)
                    //WDNotificationManager.sharedInstance.removeNotificationView(invalidMonthNotificationView, animated: true)
                    invalidMonthNotificationView = nil
                }
                
                if (invalidDateNotificationView != nil) {
                    WDNotificationManager.sharedInstance.remove(invalidMonthNotificationView, animated: true)
                    //WDNotificationManager.sharedInstance().removeNotificationView(invalidDateNotificationView, animated: true)
                    invalidDateNotificationView = nil
                }
            }
            
            if text.length > 1 {
                let monthStr = text.substring(to: 2)
                let expiryMonth = Int(monthStr) ?? 0
                if expiryMonth > 12 || expiryMonth < 1 {
                    if WDNotificationManager.sharedInstance.isNotificationViewComplete(invalidMonthNotificationView) {
                        invalidMonthNotificationView = WDNotificationManager.sharedInstance.addNotificationMessage(NSLocalizedString("Month must be value from 01 to 12 ", comment: ""), type: .WDNotificationTypeError, userInfo: nil)
                    }
                    return false
                }
                
                if (invalidMonthNotificationView != nil) {
                    WDNotificationManager.sharedInstance.remove(invalidMonthNotificationView, animated: true)
                    invalidMonthNotificationView = nil
                }
                
                if text.length == 5 {
                    let expireArray = text.components(separatedBy: "/")
                    if expireArray.count == 2 {
                        let expiryYear = getFullYear(fromTwoDigitString: expireArray[1])
                        
                        let components = Calendar.current.dateComponents([.year, .month], from: Date())
                        let currentYear = components.year ?? 0
                        let currentMonth = components.month ?? 0
                        
                        if expiryYear < currentYear || (expiryYear == currentYear && expiryMonth < currentMonth) {
                            
                            if WDNotificationManager.sharedInstance.isNotificationViewComplete(invalidDateNotificationView) {
                                invalidDateNotificationView = WDNotificationManager.sharedInstance.addNotificationMessage(NSLocalizedString("The expiry date can not be in the past", comment: ""), type: .WDNotificationTypeError, userInfo: nil)
                            }
                            
                            return false
                        }
                    }
                    
                    if (invalidDateNotificationView != nil) {
                        WDNotificationManager.sharedInstance.remove(invalidDateNotificationView, animated: true)
                        invalidDateNotificationView = nil
                    }
                }
            }
        }else if textField == nicknameTextField {
            let maxLength = 30
            let currentString: NSString = textField.text! as NSString
            let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        self.updateHelperButtons()
    }
}
