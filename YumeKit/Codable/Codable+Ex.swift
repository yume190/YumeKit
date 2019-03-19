//
//  Codable+Ex.swift
//  MaxwinBus
//
//  Created by Yume on 2019/2/27.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Decodable {
    public static func decode(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> Self {
        return try Self.decodeGeneric(data: data, decoder: decoder)
    }

    public static func decodeGeneric<T: Decodable>(data: Data, decoder: JSONDecoder = JSONDecoder()) throws -> T {
        return try decoder.decode(T.self, from: data)
    }
}

extension Encodable {
    public static func encode<T: Encodable>(data: T, encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try encoder.encode(data)
    }

    public func encode(encoder: JSONEncoder = JSONEncoder()) throws -> Data {
        return try Self.encode(data: self, encoder: encoder)
    }
}
