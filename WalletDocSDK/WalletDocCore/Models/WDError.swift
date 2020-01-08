//
//  WDError.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

// MARK:- WDError

struct WDError: Codable, Equatable {
    
    var code = ""
    var message = ""
    
    // MARK: - CodingKeys
    
    enum RootKeys: String, CodingKey {
        case error = "error"
    }
    
    enum CodingKeys: String, CodingKey {
        case code = "code"
        case message = "message"
    }
    
    // MARK: - Init
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let errorContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .error)
        
        self.code = try errorContainer.decode(String.self, forKey: .code)
        self.message = try errorContainer.decode(String.self, forKey: .message)
    }
}
