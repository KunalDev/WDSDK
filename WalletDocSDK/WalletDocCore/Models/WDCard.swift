//
//  WDCard.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 26/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation


public struct WDTokenRequest {
    var nickname = ""
    var cardholder = ""
    
    var number = ""
    
    var expiryMonth = ""
    var expiryYear = ""
    
    var cvv = ""

    
    func toDict() -> [String:Any] {
        
        var cardDict = [String:Any]()

        var dict = [String:String]()
        
        dict["nickname"] = self.nickname
        dict["cardholder"] = self.cardholder
        dict["number"] = self.number
        dict["expiry_month"] = self.expiryMonth
        dict["expiry_year"] = self.expiryYear
        dict["cvv"] = cvv
        
        cardDict["card"] = dict
        
        return cardDict
    }
    
    func expiryDate() -> Date? {
        let calendar = Calendar.current
        var components = DateComponents()
        components.day = 0
        components.month = Int(expiryMonth)
        components.year = Int(expiryYear)
        let date = calendar.date(from: components)
        return date
    }
}

struct WDToken: Codable {
    var id: String
    var type: String
    
    var card: WDCard
}

struct WDCard: Codable {
    var nickname = ""
    var brand = ""
    
    var expiryMonth = ""
    var expiryYear = ""
    
    var last4 = ""
    var fingerprint:String?
}


//
//{
//    "id": "ct_49309ee4433f4338a82bb89a65061d92",
//    "type": "card",
//    "card": {
//        "nickname": "test",
//        "brand": "MasterCard",
//        "expiry_month": "12",
//        "expiry_year": "2025",
//        "last4": "0329",
//        "fingerprint": "MYZxng6MYiEkKRhj"
//    }
//}
