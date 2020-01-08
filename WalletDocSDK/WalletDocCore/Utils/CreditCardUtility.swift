//
//  CreditCardUtility.swift
//  walletdoc business
//
//  Created by KUNAL-iMac on 05/03/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import UIKit

enum CreditCardIssuer : Int {
    case UNKNOWN
    case VISA
    case MASTERCARD
    case DINERSCLUB
    case AMEX
    case DISCOVER
    case JCB
}

class CreditCardUtility: NSObject {
    
    /**
     * Get the card issuer from the card number
     * @param creditCardNumber The credit card number
     * @return CreditCardIssuer enum identifying the card issuer
     */
    
    class func identifyCreditCardIssuer(_ creditCardNumber: String?) -> CreditCardIssuer {
        let length: Int = creditCardNumber?.count ?? 0
        if length > 0 {
            let regVisa = try? NSRegularExpression(pattern: "^4", options: .caseInsensitive)
            let regMaster = try? NSRegularExpression(pattern: "^5[1-5]|^2(?:2(?:2[1-9]|[3-9]\\d)|[3-6]\\d\\d|7(?:[01]\\d|20))", options: .caseInsensitive)
            let regExpress = try? NSRegularExpression(pattern: "^3[47]", options: .caseInsensitive)
            let regDiners = try? NSRegularExpression(pattern: "^3(?:0[0-5]|[68])", options: .caseInsensitive)
            let regDiscover = try? NSRegularExpression(pattern: "^6(?:011|5)", options: .caseInsensitive)
            let regJCB = try? NSRegularExpression(pattern: "^(?:2131|1800|35)", options: .caseInsensitive)
            
            let range = NSRange(location: 0, length: length)
            
            if regVisa?.firstMatch(in: creditCardNumber ?? "", options: [], range: range) != nil {
                return .VISA
            }
            if regMaster?.firstMatch(in: creditCardNumber ?? "", options: [], range: range) != nil {
                return .MASTERCARD
            }
            if regExpress?.firstMatch(in: creditCardNumber ?? "", options: [], range: range) != nil {
                return .AMEX
            }
            if regDiners?.firstMatch(in: creditCardNumber ?? "", options: [], range: range) != nil {
                return .DINERSCLUB
            }
            if regDiscover?.firstMatch(in: creditCardNumber ?? "", options: [], range: range) != nil {
                return .DISCOVER
            }
            if regJCB?.firstMatch(in: creditCardNumber ?? "", options: [], range: range) != nil {
                return .JCB
            }
        }
        
        return .UNKNOWN
    }
    
    /**
     * Returns the maximum allowed number of digits allowed for the credit card issuer based on the card number provided
     * This functions does not require the full card number, but does require at least the first digit to identify the issuer
     * @param creditCardNumber credit card number
     * @return maximum length of credit card allowed
     */
    
    class func maxCreditCardLength(_ creditCardNumber: String?) -> Int {
        let issuer = self.identifyCreditCardIssuer(creditCardNumber)
        
        return self.maxCreditCardLength(for: issuer)
    }
    
    /**
     * Returns the maximum allowed number of digits allowed for the credit card issuer
     * @param cardIssuer credit card issuer enum
     * @return maximum length of credit card allowed
     */
    class func maxCreditCardLength(for cardIssuer: CreditCardIssuer) -> Int {
        switch cardIssuer {
        case .DINERSCLUB:
            return 14
        case .AMEX:
            return 15
        default:
            return 16
        }
//        return 16
    }
    
    /**
     * Returns the maximum number of digits used for the credit card issuer with formatting based on the card number provided i.e. spacing
     * This functions does not require the full card number, but does require at least the first digit to identify the issuer
     * @param creditCardNumber The credit card number
     * @return maximum length of formatted credit card number i.e. with white spaces
     */
    
    class func maxFormattedCreditCardLength(_ creditCardNumber: String?) -> Int {
        let issuer = self.identifyCreditCardIssuer(creditCardNumber)
        
        return self.maxFormattedCreditCardLength(for: issuer)
    }
    
    /**
     * Returns the maximum number of digits used for the credit card issuer with formatting i.e. spacing
     * @param cardIssuer credit card issuer enum
     * @return maximum length of formatted credit card number i.e. with white spaces
     */
    class func maxFormattedCreditCardLength(for cardIssuer: CreditCardIssuer) -> Int {
        switch cardIssuer {
        case .DINERSCLUB:
            return 14 + 2
        case .AMEX:
            return 15 + 2
        default:
            return 16 + 3
        }
        
      //  return 16 + 3
    }

    
    /**
     * Returns the formatted credit card i.e. the number with spacing
     * @param cardNumber credit card number
     * @return formatted credit card number
     */
    
    class func formatCreditCardString(_ cardNumber: String?) -> String? {
        // remove whitespace
        let plainNumber = cardNumber?.replacingOccurrences(of: " ", with: "")
        var retString = plainNumber
        
        let length: Int = plainNumber?.count ?? 0
        if length > 4 {
            var total: Int = 0
            retString = ""
            let issuer = CreditCardUtility.identifyCreditCardIssuer(plainNumber)
            var tempNumber = plainNumber
            if issuer == .DINERSCLUB {
                // 4-6-4 format
                while (tempNumber?.count ?? 0) > 0 {
                    // add a space if this is not the start of the credit card number
                    if total != 0 {
                        retString = retString! + (" ")
                    }
                    
                    var minimum: Int
                    if total != 1 {
                        minimum = min((tempNumber?.count ?? 0), 4)
                    } else {
                        minimum = min((tempNumber?.count ?? 0), 6)
                    }
                    
                    let subString = (tempNumber as? NSString)?.substring(to: minimum)
                    
                    // append the sub string to our return string
                    retString = retString! + (subString ?? "")
                    
                    // cut out the numbers we used from the string
                    tempNumber = (tempNumber as NSString?)?.substring(from: minimum)
                    
                    total += 1
                    if total == 3 {
                        // can't be bigger than 14 characters so break
                        break
                    }
                }
            } else if issuer == .AMEX {
                    // 4-6-5 format
                    while (tempNumber?.count ?? 0) > 0 {
                        // add a space if this is not the start of the credit card number
                        if total != 0 {
                            retString = retString! + (" ")
                        }
                        
                        var minimum: Int
                        if total == 0 {
                            minimum = min((tempNumber?.count ?? 0), 4)
                        } else if total == 1 {
                            minimum = min((tempNumber?.count ?? 0), 6)
                        } else {
                            minimum = min((tempNumber?.count ?? 0), 5)
                        }
                        
                        let subString = (tempNumber as? NSString)?.substring(to: minimum)
                        
                        // append the sub string to our return string
                        retString = retString! + (subString ?? "")
                        
                        // cut out the numbers we used from the string
                        tempNumber = (tempNumber as? NSString)?.substring(from: minimum)
                        
                        total += 1
                        if total == 3 {
                            // can't be bigger than 15 characters so break
                            break
                        }
                    }
            }else {
                // 4-4-4-4 format
                while (tempNumber?.count ?? 0) > 0 {
                    // add a space if this is not the start of the credit card number
                    if total != 0 {
                        retString = retString! + (" ")
                    }
                    
                    // get the next 4 digits or as much as there is left
                    let minimum = min((tempNumber?.count ?? 0), 4)
                    
                    let subString = (tempNumber as? NSString)?.substring(to: minimum)
                    
                    // append the sub string to our return string
                    
                    retString = retString! + (subString ?? "")
                    
                    // cut out the numbers we used from the string
                    tempNumber = (tempNumber as? NSString)?.substring(from: minimum)
                    
                    total += 1
                    if total == 4 {
                        // can't be bigger than 16 characters so break
                        break
                    }
                }
            }
        }
    
        return retString;
    }
    
    /**
     * Returns true if the credit card number is valid
     * Identifies the issuer and runs the luhn algorithm
     * @param creditCardNumber credit card number
     * @return true if valid, false if invalid
     */
    
    class func isCreditCardNumberValid(_ creditCardNumber: String) -> Bool {
        let regVisa = try? NSRegularExpression(pattern: "^4[0-9]{12}(?:[0-9]{3})?$", options: .caseInsensitive)
        let regMaster = try? NSRegularExpression(pattern: "^5[1-5]\\d{14}$|^2(?:2(?:2[1-9]|[3-9]\\d)|[3-6]\\d\\d|7(?:[01]\\d|20))\\d{12}$", options: .caseInsensitive)
        let regExpress = try? NSRegularExpression(pattern: "^3[47][0-9]{13}$", options: .caseInsensitive)
        let regDiners = try? NSRegularExpression(pattern: "^3(?:0[0-5]|[68][0-9])[0-9]{11}$", options: .caseInsensitive)
        //NSRegularExpression *regDiscover = [NSRegularExpression regularExpressionWithPattern: @"^6(?:011|5[0-9]{2})[0-9]{12}$" options:NSRegularExpressionCaseInsensitive error:nil];
        //NSRegularExpression *regJSB = [NSRegularExpression regularExpressionWithPattern: @"^(?:2131|1800|35\\d{3})\\d{11}$" options:NSRegularExpressionCaseInsensitive error:nil];
        
        let cardLength: Int = creditCardNumber.count 
        let range = NSRange(location: 0, length: cardLength)
        
        // first check that the credit card number matches one of the supported credit cards
        var bValidCreditCard = false
        if regVisa?.firstMatch(in: creditCardNumber , options: [], range: range) != nil {
            bValidCreditCard = true
        } else if regMaster?.firstMatch(in: creditCardNumber , options: [], range: range) != nil {
            bValidCreditCard = true
        } else if regExpress?.firstMatch(in: creditCardNumber , options: [], range: range) != nil {
            bValidCreditCard = true
        } else if regDiners?.firstMatch(in: creditCardNumber , options: [], range: range) != nil {
            bValidCreditCard = true
        }
        
        if bValidCreditCard == false {
            return false
        }
        
        // Do the luan algorithm
        return CreditCardUtility.luhnAlgorithmCheck(creditCardNumber)
    }
    
    /**
     * Returns true if the credit card number passes the luhn Algorithm
     * @param cardNumber credit card number
     * @return true if valid, false if invalid
     */
    
    class func luhnAlgorithmCheck(_ cardNumber: String) -> Bool {
        var sum = 0
        let reversedCharacters = cardNumber.reversed().map { String($0) }
        for (idx, element) in reversedCharacters.enumerated() {
            guard let digit = Int(element) else { return false }
            switch ((idx % 2 == 1), digit) {
            case (true, 9): sum += 9
            case (true, 0...8): sum += (digit * 2) % 9
            default: sum += digit
            }
        }
        return sum % 10 == 0
    }
    
//    class func luhnAlgorithmCheck(_ cardNumber: String?) -> Bool {
//        // reverse the order of the card number
//        var reversedString = String(repeating: "\0", count: cardNumber?.count ?? 0)
//
//        (cardNumber as NSString?)?.enumerateSubstrings(in: NSRange(location: 0, length: cardNumber?.count ?? 0), options: [.reverse, .byComposedCharacterSequences], using: { substring, substringRange, enclosingRange, stop in
//            reversedString += substring ?? ""
//        })
//
//        var odd_sum: UInt = 0
//        var even_sum: UInt = 0
//
//        for i in 0..<reversedString.count {
//            let digit = Int(truncating: "\(reversedString[reversedString.index(reversedString.startIndex, offsetBy: i)])") ?? 0
//
//            // sum the odd digits
//            if i % 2 == 0 {
//                odd_sum += UInt(digit)
//            } else {
//                // multiple all the even digits by 2, add the tens and units together i.e. if answer is 16 then add 1 + 6 = 7.
//                // add the results to the other even digit calculations
//                // divide by 5 is a shortcut to * 2 / 10
//                even_sum += UInt(digit / 5 + (digit * 2) % 10)
//            }
//        }
//
//        // if the odd sum + the even sum end in zero then the credit card is valid
//        return (odd_sum + even_sum) % 10 == 0
//    }
    
    
    /**
     * Gets a display string for a card issuer
     * @param cardIssuer CreditCardIssuer enum
     * @return string representing the card issuer
     */
    
    class func getCardTitle(_ cardIssuer: CreditCardIssuer) -> String? {
        switch cardIssuer {
        case .VISA:
            return NSLocalizedString("Visa", comment: "")
        case .MASTERCARD:
            return NSLocalizedString("MasterCard", comment: "")
        case .DINERSCLUB:
            return NSLocalizedString("Diners Club", comment: "")
        case .AMEX:
            return NSLocalizedString("American Express", comment: "")
        case .DISCOVER:
            return NSLocalizedString("Discover", comment: "")
        case .JCB:
            return NSLocalizedString("JCB", comment: "")
        default:
            break
        }
        
        return nil
    }
}
