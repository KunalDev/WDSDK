//
//  WDSDKDecodable.swift
//  walletdoc
//
//  Created by KUNAL-iMac on 18/11/19.
//  Copyright © 2019 walletdoc. All rights reserved.
//

import Foundation

fileprivate struct DummyCodable: Codable { }

extension UnkeyedDecodingContainer {
    
    public mutating func decodeArrayByIgnoringInvalidElements<T>(_ type: T.Type) throws -> [T] where T : Decodable {
        var decodedArray = [T]()
        while !isAtEnd {
            do {
                let item = try decode(T.self)
                decodedArray.append(item)
            } catch let error {
                print("ERROR decoding: \(error)")
                _ = try? decode(DummyCodable.self) //Move container onto next item to be decoded
            }
        }
        
        return decodedArray
    }
}

extension KeyedDecodingContainerProtocol {
    
    public func decodeArrayByIgnoringInvalidElements<T>(_ type: T.Type, forKey key: Self.Key) throws -> [T] where T : Decodable {
        var unkeyedContainer = try nestedUnkeyedContainer(forKey: key)
        
        return try unkeyedContainer.decodeArrayByIgnoringInvalidElements(type)
    }
}
