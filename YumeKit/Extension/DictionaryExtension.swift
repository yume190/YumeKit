//
//  DictionaryExtension.swift
//  BusApp
//
//  Created by Yume on 2017/7/17.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

infix operator <| : MultiplicationPrecedence
infix operator <|? : MultiplicationPrecedence
//infix operator <|| : MultiplicationPrecedence

extension Dictionary where Key == AnyHashable, Value == Any {
    public enum DictionaryDecodeError: Error {
        case keyNotFound(key:String, dictionary:[Key:Value])
        case nullValue(key:String, dictionary:[Key:Value])
        case typeMismatch(key:String, expectType: Any, actualType: Any, value: Any, dictionary:[Key:Value])
        case specialCase(reason:String)
    }

    static public func <|? <T>(dictionary: [Key: Value], key: String) -> T? {
        return dictionary[key] as? T
    }

    static public func <| <T> (dictionary: [Key: Value], key: String) throws -> T {
        if let r: T = dictionary <|? key {
            return r
        }

        if let data = dictionary[key] {
            if data is NSNull {
                throw DictionaryDecodeError.nullValue(key: key, dictionary: dictionary)
            }

            throw DictionaryDecodeError.typeMismatch(key: key, expectType: T.self, actualType: type(of: data), value: data, dictionary: dictionary)
        }
        throw DictionaryDecodeError.keyNotFound(key: key, dictionary: dictionary)
    }

    //    static public func <|| <T:JSONDecodable>(json:JSON,key:String) throws -> [T] {
    //        return try json.getBy(key: key).toArray()
    //    }
}
