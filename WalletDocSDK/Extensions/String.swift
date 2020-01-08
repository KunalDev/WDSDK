//
//  String.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    
    static func blank(text: String) -> Bool {
        let trimmed = text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        return trimmed.isEmpty
    }
    
    /*
     func isEmpty(_ string: String?) -> Bool {
     if string == nil || (string is NSNull) || (string?.count ?? 0) == 0 {
     return true
     }
     if (string?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count ?? 0) == 0 {
     return true
     }
     return false
     }
     
     func stringWith(expirationDateMonth month: NSNumber?, year: NSNumber?)  -> String? {
     let monthString = "\(month?.intValue ?? 0 < 10 ? "0" : "")\(month?.stringValue ?? "")"
     "\(monthString)/\((year?.stringValue ?? "" as? NSString)?.substring(from: 2) ?? "")"
     }
     */
    
    func stringWith(currency amount: Double)  -> String? {
        return Utility.formatCurrencyAmount(amount, forCurrencyCode: "ZAR", withMinimumFractionDigits: 2)
    }
    
    func stringWithShort(currency amount: Double)  -> String? {
        let currencyString = Utility.formatCurrencyAmount(amount, forCurrencyCode: "ZAR", withMinimumFractionDigits: 2)
        return currencyString?.replacingOccurrences(of: "ZAR", with: "R")
    }
    
    func stringWithShortAndNoFraction(currency amount: Double)  -> String? {
        let currencyString = Utility.formatCurrencyAmount(amount, forCurrencyCode: "ZAR", withMinimumFractionDigits: 0)
        return currencyString?.replacingOccurrences(of: "ZAR", with: "R")
    }
    
    
    static func filename(fromContentDispositionHeader contentDispositionHeader: String?) -> String? {
        let pattern = "filename=\"(.*)\""
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let result: NSTextCheckingResult? = regex?.firstMatch(in: contentDispositionHeader ?? "", options: [], range: NSRange(location: 0, length: contentDispositionHeader?.count ?? 0))
        let resultRange: NSRange? = result?.range(at: 0)
        
        if Int(resultRange?.location ?? 0) == NSNotFound {
            return ""
        } else {
            return (contentDispositionHeader as NSString?)?.substring(with: NSRange(location: Int((resultRange?.location ?? 0) + 10), length: Int((resultRange?.length ?? 0) - 11)))
        }
    }
    
    func isValidAccordingRegex(_ regex: String?) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES[c] %@", regex ?? "")
        return predicate.evaluate(with: self)
    }
    
    func isValidEmail() -> Bool {
        let emailRegex = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,})$"
        return isValidAccordingRegex(emailRegex)
    }
    
    func isValidPhoneNumber() -> Bool {
        let phoneRegex = "^[0-9]{6,14}$"
        return isValidAccordingRegex(phoneRegex)
    }
    
    func isvalidUserName() -> Bool {
        let nameRegex = "^[A-Za-z]+(?:\\s[A-Za-z]+)*$"
        return isValidAccordingRegex(nameRegex)
    }
    
    //This function trim only white space:
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    //This function trim whitespeaces and new line that you enter:
    func trimWhiteSpaceAndNewLine() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func whiteSpacesRemoved() -> String {
        return self.filter { $0 != Character(" ") }
    }
    
    
    func isValidWebsiteURL() -> Bool {
        
        return true
        
        //check for this Regex
        
        //        guard let url = URL(string: self)
        //        else { return false }
        
        //        if !UIApplication.shared.canOpenURL(url) { return false }
        //        return true
        
        /*
         let regEx = "/[-a-zA-Z0-9@:%_\\+.~#?&//=]{2,256}\\.[a-z]{2,4}\\b(\\/[-a-zA-Z0-9@:%_\\+.~#?&//=]*)?/"
         let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
         return predicate.evaluate(with: self) */
    }
    
    static func format(strings: [String],
                       boldFont: UIFont = UIFont.boldSystemFont(ofSize: 14),
                       boldColor: UIColor = UIColor.blue,
                       inString string: String,
                       font: UIFont = UIFont.systemFont(ofSize: 14),
                       color: UIColor = UIColor.black) -> NSAttributedString {
        let attributedString =
            NSMutableAttributedString(string: string,
                                      attributes: [
                                        NSAttributedString.Key.font: font,
                                        NSAttributedString.Key.foregroundColor: color])
        let boldFontAttribute = [NSAttributedString.Key.font: boldFont, NSAttributedString.Key.foregroundColor: boldColor]
        for bold in strings {
            attributedString.addAttributes(boldFontAttribute, range: (string as NSString).range(of: bold))
        }
        return attributedString
    }
}

//let phoneRegex = "^((\\+)|(00))[0-9]{16,4}$"

//"^[0-9]{6,14}$"

/*
 NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$"
 NSString *phoneRegex = @"^((\\+)|(00))[0-9]{6,14}$"
 @"^(\\+(2(6(2\\d{0,9})?)?)?)?$"] */


//"^((\\+)|(00))[0-9]{16,4}$"
//"^((\\+)|(00))[0-9]{16,4}$"
