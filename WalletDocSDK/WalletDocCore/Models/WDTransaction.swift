//
//  WDTransaction.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 19/12/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

// MARK: - CreateTransaction

struct WDCreateTransactionRequest {
    
    var amount = 0.0
    var currency = ""
    
    var capture = true
    
    var customerId = ""
    var paymentMethodId = ""
    
    func toDict() -> [String:String] {
        
        var dict = [String:String]()
        
        dict["amount"] = "100"
        dict["currency"] = "ZAR"
        dict["capture"] = self.capture ? "true" : "false"
        dict["customer_id"] = ""
        dict["payment_method_id"] = self.paymentMethodId
        
        return dict
    }
}

struct WDCreateTransactionResponse: Codable {
    
    var id = ""
    var status = ""
    var amount = 0.0
    var chargedAmount = 0.0
    var currency = ""
    var capture = false
    var customerId: String?
    var paymentMethodId = ""
    var clientSecret = ""
}


// MARK: - ProcessTransaction

struct WDProcessTransactionRequest {
    var clientSecret = ""
    var cvv = ""
    var autoAuthenticate = false
    var id = ""
    
    func toDict() -> [String:String] {
        
        var dict = [String:String]()
        
        dict["client_secret"] = self.clientSecret
        dict["cvv"] = self.cvv
        
        //        if self.cvv != ""{
        //            dict["cvv"] = self.cvv
        //        }
        dict["auto_authenticate"] = self.autoAuthenticate  ? "true" : "false"
        
        return dict
    }
}

struct WDProcessTransactionResponse: Codable {
    var id = ""
    var status = ""
    var amount = 0.0
    var chargedAmount = 0.0
    var currency = ""
    var capture = false
    var customerId: String?
    var paymentMethodId = ""
    var redirect:WDSecurePaymentRedirect?
}

struct WDSecurePaymentRedirect: Codable {
    var payload = ""
    var authenticationUrl = ""
    
    var cvvRequired = false
    var returnUrl = ""
    
    var sessionId = ""
    var transactionId = ""
    
    var issuer: CreditCardIssuer?
    
    enum CodingKeys: String, CodingKey {
        case payload = "payload"
        case authenticationUrl = "authenticationUrl"
        
        case cvvRequired = "cvvRequired"
        case returnUrl = "returnUrl"
        
        case sessionId = "sessionId"
        case transactionId = "transactionId"
    }
    
    //    enum RootKeys: String, CodingKey {
    //        case redirect = "redirect"
    //    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.payload = try container.decodeIfPresent(String.self, forKey: .payload) ?? ""
        self.authenticationUrl = try container.decode(String.self, forKey: .authenticationUrl)
        
        self.cvvRequired = try container.decodeIfPresent(Bool.self, forKey: .cvvRequired) ?? false
        self.returnUrl = try container.decodeIfPresent(String.self, forKey: .returnUrl) ?? ""
        
        self.sessionId = try container.decodeIfPresent(String.self, forKey: .sessionId) ?? ""
        self.transactionId = try container.decodeIfPresent(String.self, forKey: .transactionId) ?? ""
    }
    
    func getRedirectHtml() -> String? {
        return """
        <HTML>\
        <BODY onload="document.frmLaunch.submit();">\
        <FORM name="frmLaunch" method="POST" action="\(self.authenticationUrl)">\
        <input type=hidden name="PaReq" value="\(self.payload)">\
        <input type=hidden name="TermUrl" value="\("https://localhost")">\
        <input type=hidden name="MD" value="\(self.sessionId)">\
        </FORM>\
        </BODY>\
        </HTML>
        """
    }
}


// MARK: - ProcessTransaction

struct WDProcessTransactionWithSessionRequest {
    var sessionID = ""
    var cvv = ""
    var payload = ""
    var id = ""
    var clientSecret = ""
    
    func toDict() -> [String:String] {
        
        var dict = [String:String]()
        
        dict["session_id"] = self.sessionID
        dict["payload"] = self.payload
        dict["client_secret"] = self.clientSecret
        
        if self.cvv != ""{
            dict["cvv"] = self.cvv
        }
        
        return dict
    }
}

struct WDProcessTransactionWithSessionResponse: Codable {
    var id = ""
    var status = ""
    var amount = 0.0
    var chargedAmount = 0.0
    var currency = ""
    var capture = false
    var customerId: String?
    var paymentMethodId = ""
}

//
//{
//    "id": "63978796c8b946f9a64248b0c0dbd2a9",
//    "status": "awaiting_authentication",
//    "amount": 500000,
//    "charged_amount": 0,
//    "currency": "ZAR",
//    "capture": true,
//    "customer_id": "ccffcbdbd4fe43cda80e53d9b660ef46",
//    "payment_method_id": "ct_063ee248aaee4994bd9ef79e308b1cd9",
//    "redirect": {
//        "payload": "eJxVUdtygjAQ/RXGDyAJ4HXWzGB1pj6U8QI641satoWxAgZQ69c3QajtU87Zy8nuWQgThTjfoqwVcnjDshSfaKXxtLfarMf9wcjrD3ocVv4GzxwuqMo0zzizqe0A6ajuUzIRWcVByPNsGXDGGJAWwwnVcs6Z4wJ5QMjECflMZMcS1cX/UKkUVqcBpMmCzOusUt98yCiQjkCtvnhSVUU5IeR6vdrvrYgtc/sugJg8kOc8q9qgUuvd0phv74cgiNZOeCz20S4J94tqv2NBFC3kFIipgFhUyB3KxozRkcXoxB1OmAekiYM4mUH4wd9YrkepTfVsbQwK85X/ICZpcn9joD1WmMlupY4B3oo8Q12hLf3FEGMp9Srt89zj5dW4LCvt45jRodN3G6ubgJFKtU2OS71GyxAgpoW0JyTtjTX6d/sfUTitFg==",
//        "authentication_url": "https://acsabsatest.bankserv.co.za/mdpayacs/pareq",
//        "cvv_required": false,
//        "return_url": "https://www.walletdoc.tech/completePayment",
//        "session_id": "653bb268-02fd-46a5-889c-d44de59cf735"
//    }
//}
//
//
//{
//    "id": "3d4675618311430a93292adc3f07af27",
//    "status": "awaiting_authentication",
//    "amount": 500000,
//    "charged_amount": 0,
//    "currency": "ZAR",
//    "capture": true,
//    "customer_id": "ccffcbdbd4fe43cda80e53d9b660ef46",
//    "payment_method_id": "ct_dc0f94954f2a4f16853ccf7cbc186fc3",
//    "redirect": {
//        "transaction_id": "3d4675618311430a93292adc3f07af27",
//        "authentication_url": "https://www.walletdoc.com/authenticate"
//    }
//}
