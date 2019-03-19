//
//  YumeSerializable.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

// https://stackoverflow.com/questions/28916535/swift-structs-to-nsdata-and-back
// 盡量不要 archive string

import Foundation

public protocol YumeSerializable {
    func archive() -> Data
    static func archive(serializable: Self) -> Data
    static func unarchive(data: Data) -> Self?
}

extension YumeSerializable {
    public func archive() -> Data {
        return Self.archive(serializable: self)
    }

    public static func archive(serializable: Self) -> Data {
        var _serializable = serializable
        return Data(bytes: &_serializable, count: MemoryLayout<Self>.stride)
    }

    public static func unarchive(data: Data) -> Self? {
        guard data.count == MemoryLayout<Self>.stride else {
            return nil
        }

        return data.withUnsafeBytes { (bytes: UnsafePointer<Self>) -> Self in
            return UnsafePointer<Self>(bytes).pointee
        }
    }
}
