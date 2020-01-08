//
//  WDSDKURLResponse.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

extension URLResponse {
    func getStatusCode() -> Int? {
        if let httpResponse = self as? HTTPURLResponse {
            return httpResponse.statusCode
        }
        return nil
    }
}
