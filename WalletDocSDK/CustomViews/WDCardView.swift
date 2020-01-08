//
//  WDCardView.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit

public class WDCardView: UIView,UITextFieldDelegate{
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var cardNumberTextField: WDMaskTextField!
    @IBOutlet weak var expiryDateTextField: WDMaskTextField!
    @IBOutlet weak var cvvTextField: WDMaskTextField!
    
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var cardHolderTextField: UITextField!
    
    @IBOutlet weak var cardTypeImageView: UIImageView!
    @IBOutlet weak var creditCardView: UIView!
    
    @IBOutlet weak var helperView: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    var invalidMonthNotificationView: WDNotificationView?
    var invalidDateNotificationView: WDNotificationView?
    
    var borderColor = UIColor(red: 205 / 255.0, green: 205 / 255.0, blue: 205 / 255.0, alpha: 1.0)
    
    // MARK: - Init methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width:0, height:0))
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        
        let bundle = Bundle(for: type(of: self))
        //   let nib = UINib(nibName: "CustomUIView", bundle: bundle)
          // let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
       //r    return view
        
        
        bundle.loadNibNamed("WDCardView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.customizeViews()
        self.setGeneralSettingsForCurrentMode()
    }
    
    // MARK: - View customization
    
    func customizeViews() {
        //let borderColor = UIColor(red: 205 / 255.0, green: 205 / 255.0, blue: 205 / 255.0, alpha: 1.0)
        self.customize(cardTypeImageView, withCornerRadius: 7.0, borderWidth: 0.5, borderColor: borderColor)
        self.customize(creditCardView, withCornerRadius: 7.0, borderWidth: 1.0, borderColor: borderColor)
    }
    
    func customize(_ view: UIView, withCornerRadius radius: CGFloat, borderWidth width: CGFloat, borderColor color: UIColor?) {
        view.layer.cornerRadius = radius
        view.clipsToBounds = true
        view.layer.borderWidth = width
        view.layer.borderColor = color?.cgColor
    }
    
    public func setGeneralSettingsForCurrentMode() {
        addShadowForHelperView()
        
        cardNumberTextField.inputAccessoryView = helperView
        cardHolderTextField.inputAccessoryView = helperView
        nicknameTextField.inputAccessoryView = helperView
        expiryDateTextField.inputAccessoryView = helperView
        cvvTextField.inputAccessoryView = helperView
    }
    
    public func addShadowForHelperView() {
        let shadowPath = UIBezierPath(rect: helperView.bounds)
        helperView.layer.shadowPath = shadowPath.cgPath
        helperView.layer.masksToBounds = false
        helperView.layer.shadowColor = UIColor.black.cgColor
        helperView.layer.shadowOpacity = 0.5
        helperView.layer.shadowRadius = 10.0
        helperView.layer.shadowOffset = CGSize(width: 0, height: -5.0)
    }
    
    // MARK: - Add Card Clicked
    
    // Check this later
    /*
     @IBAction func addCardClicked(_ sender: Any) {
     let card = collectData()
     if isCardValid(card) {
     makeAddCardRequest(with: card)
     }
     }*/
    
    // MARK: - Next/Prev Action
    
    private func updateHelperButtons() {
        prevButton.isEnabled = !cardHolderTextField.isFirstResponder
        nextButton.isEnabled = !nicknameTextField.isFirstResponder
    }
    
    @IBAction func doneButtonClicked(_ sender: Any) {
        self.endEditing(true)
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

    // MARK: - Customise apperance
    
    public func customizeAppearance(){
        self.setTextFont(UIFont(name: "HelveticaNeue-Italic", size: 20) ?? UIFont.systemFont(ofSize: 20.0))
        self.setTextColor(UIColor.blue)
        self.setTextPlaceHolderColor(UIColor.cyan)
        self.setBackGroundColor(UIColor.yellow)
    }
    
    func setTextFont(_ font: UIFont){
        self.cardNumberTextField.font = font
        self.expiryDateTextField.font = font
        self.cvvTextField.font = font
        
        self.nicknameTextField.font = font
        self.cardHolderTextField.font = font
    }

    func setTextColor(_ color: UIColor){
        self.cardNumberTextField.textColor = color
        self.expiryDateTextField.textColor = color
        self.cvvTextField.textColor = color
              
        self.nicknameTextField.textColor = color
        self.cardHolderTextField.textColor = color
    }
    
    func setSeparatorColor(_ color: UIColor){
        
        self.cardNumberTextField.textColor = color
        self.expiryDateTextField.textColor = color
        self.cvvTextField.textColor = color
               
        self.nicknameTextField.textColor = color
        self.cardHolderTextField.textColor = color
     }
    
    func setTextPlaceHolderColor(_ color: UIColor){
        self.cardNumberTextField.attributedPlaceholder = NSAttributedString(string: "Card Number", attributes: [NSAttributedString.Key.foregroundColor : color])
        self.expiryDateTextField.attributedPlaceholder = NSAttributedString(string: "MM/YY", attributes: [NSAttributedString.Key.foregroundColor : color])
        self.cvvTextField.attributedPlaceholder = NSAttributedString(string: "CVV", attributes: [NSAttributedString.Key.foregroundColor : color])
        
        self.nicknameTextField.attributedPlaceholder = NSAttributedString(string: "Nickname (optional)", attributes: [NSAttributedString.Key.foregroundColor : color])
        self.cardHolderTextField.attributedPlaceholder = NSAttributedString(string: "Cardholder Name", attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func setBackGroundColor(_ color: UIColor){
        self.creditCardView.backgroundColor = color
    }
    
    // MARK: - Add Card Clicked
    
   public func collectData() -> WDTokenRequest {
        
        var tokenRequest = WDTokenRequest()
        
        tokenRequest.cardholder = cardHolderTextField.text ?? ""
        tokenRequest.nickname = nicknameTextField.text ?? ""
        // remove formatting from the card number
        tokenRequest.number = (cardNumberTextField.text ?? "").replacingOccurrences(of: " ", with: "")
        tokenRequest.cvv = cvvTextField.text ?? ""
        
        let expireString = expiryDateTextField.text ?? ""
        let expireArray = expireString.components(separatedBy: "/")
        if expireArray.count == 2 {
            
            tokenRequest.expiryMonth =  expireArray[0] //NSNumber(value: Int(expireArray[0]) ?? 0)
            let expiryYear = getFullYear(fromTwoDigitString: expireArray[1])
            tokenRequest.expiryYear = String(expiryYear) //NSNumber(long: expiryYear)
        }
        return tokenRequest
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
            let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: "", preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
            alertController.addAction(okAction)
            UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.rootViewController?.present(alertController, animated: true, completion: nil)
            //self.present(alertController, animated: true)
        //    Utility.showAlert(on: self, forErrorMessage: errorString)
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
