//
//  Utility.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

class Utility: NSObject {
    
    /**
     * Returns a number formatter for a specified currency code
     * @param code currency code
     * @return NumberFormatter
     */
    
    class func numberFormatter(forCurrencyCode code: String?) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.currencyCode = code ?? ""
        return numberFormatter
    }
    
    /**
     * Returns a number formatter for a specified currency code with minimum fraction digits
     * @param code currency code
     * @param minFractionDigits minimum fraction digits used for display
     * @return NumberFormatter
     */
    
    class func numberFormatter(forCurrencyCode code: String?, withMinimumFractionDigits minFractionDigits: Int) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = minFractionDigits
        numberFormatter.currencyCode = code ?? ""
        return numberFormatter
    }
    
    /**
     * Returns a displayable formatted currency string for the specified amount
     * @param amount currency amount to format
     * @param code currency code
     * @return String containing formatted currency amount
     */
    
    class func formatCurrencyAmount(_ amount: Double, forCurrencyCode code: String?) -> String? {
        let numberFormatter: NumberFormatter? = self.numberFormatter(forCurrencyCode: code)
        return numberFormatter?.string(from: NSNumber(value: amount))
    }

    /**
     * Returns a displayable formatted currency string for the specified amount
     * @param amount currency amount to format
     * @param code currency code
     * @param minFractionDigits minimum fraction digits used for display
     * @return String containing formatted currency amount
     */
    
    class func formatCurrencyAmount(_ amount: Double, forCurrencyCode code: String?, withMinimumFractionDigits minFractionDigits: Int) -> String? {
        let numberFormatter: NumberFormatter? = self.numberFormatter(forCurrencyCode: code, withMinimumFractionDigits: minFractionDigits)
        return numberFormatter?.string(from: NSNumber(value: amount))
    }
    
    
    /*
    
    /**
     * Checks if the internet is reachable
     * @return true if internet is reachable otherwise false
     */
    
    class func isInternetReachable() -> Bool {
        let networkReachability = Reachability()
        let networkStatus: NetworkStatus = networkReachability.currentReachabilityStatus()
        if networkStatus == NotReachable {
            return false
        }
        
        return true
    }
 */
    
    
    class func showAlert(on viewController: UIViewController?, forErrorMessage message: String?) {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController?.present(alertController, animated: true)
    }
    
    
    /**
     * Shows an alert view for the specified NSError
     * @param viewController the view controlelr to display the alert in
     * @param error the NSError to show the alertview for
     */
    
    class func showAlert(on viewController: UIViewController?, forError error: Error?) throws {
        let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error?.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController?.present(alertController, animated: true)
    }
    
    /**
     * Shows an alert view with the specified title and message
     * @param viewController the view controlelr to display the alert in
     * @param title title to display for alert view
     * @param message message to display in alert view
     */
    
    class func showAlert(on viewController: UIViewController?, withTitle title: String?, andMessage message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil)
        alertController.addAction(okAction)
        
        viewController?.present(alertController, animated: true)
    }
 
    
    /**
     * Checks if an email is valid
     * @param checkString string containing email to check
     * @return true if email is valid, false if not
     */
    class func isEmailValid(_ checkString: String?) -> Bool {
        let emailRegex = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: checkString)
    }

    /*
 
    /**
     * Checks the password strength of the specified password string
     * @param password password string
     * @return PasswordStrengthType indiciating whether the password strength is weak, moderate or strong
     */
    
    class func checkPasswordStrength(_ password: String?) -> PasswordStrengthType {
        let len: Int = password?.count ?? 0
        //will contains password strength
        var strength: Int = 0
        
        if len == 0 {
            return PasswordStrengthTypeWeak
        } else if len <= 5 {
            strength += 1
        } else if len <= 10 {
            strength += 2
        } else {
            strength += 3
        }
        
        strength += self.validate(password, withPattern: REGEX_PASSWORD_ONE_UPPERCASE, caseSensitive: true)
        strength += self.validate(password, withPattern: REGEX_PASSWORD_ONE_LOWERCASE, caseSensitive: true)
        strength += self.validate(password, withPattern: REGEX_PASSWORD_ONE_NUMBER, caseSensitive: true)
        strength += self.validate(password, withPattern: REGEX_PASSWORD_ONE_SYMBOL, caseSensitive: true)
        
        if strength <= 3 {
            return PasswordStrengthTypeWeak
        } else if 3 < strength && strength < 6 {
            return PasswordStrengthTypeModerate
        } else {
            return PasswordStrengthTypeStrong
        }
    }

 */
    
    /*
 
    /**
     * Validates a string against the specified regex pattern
     * @param pattern regex patter
     * @param caseSensitive true for case sensitive check, false for case insensitive
     * @return true if valid, false if invalid
     */
    
    class func validate(_ string: String?, withPattern pattern: String?, caseSensitive: Bool) -> Int {
        var error: Error? = nil
        let regex = try? NSRegularExpression(pattern: pattern ?? "", options: NSRegularExpression.Options(rawValue: ((caseSensitive) ? 0 : NSRegularExpression.Options.caseInsensitive.rawValue)))
        
        assert(regex != nil, "Unable to create regular expression")
        
        let textRange = NSRange(location: 0, length: string?.count ?? 0)
        let matchRange: NSRange? = regex?.rangeOfFirstMatch(in: string ?? "", options: .reportProgress, range: textRange)
        
        var didValidate = Bool(0)
        
        // Did we find a matching range
        if Int(matchRange?.location ?? 0) != NSNotFound {
            didValidate = Bool(1)
        }
        
        return Int(didValidate)
    }
    
    class func daysBetweenDate(_ fromDateTime: Date?, andDate toDateTime: Date?) -> Int {
        var fromDate: Date?
        var toDate: Date?
        let calendar = Calendar.current
        if let fromDateTime = fromDateTime {
            calendar.range(of: .day, start: &fromDate, interval: nil, for: fromDateTime)
        }
        if let toDateTime = toDateTime {
            calendar.range(of: .day, start: &toDate, interval: nil, for: toDateTime)
        }
        var difference: DateComponents? = nil
        if let fromDate = fromDate, let toDate = toDate {
            difference = calendar.components(.day, from: fromDate, to: toDate, options: [])
        }
        return difference?.day ?? 0
    }
     */
}
