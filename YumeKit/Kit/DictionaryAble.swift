//
//  DictionaryAble.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

public protocol DictionaryAble {
    associatedtype Key: Hashable
    associatedtype Value
    typealias DictionaryType = [Key: Value]
    var key: Key {get}
    var value: Value {get}
}

extension Array where Element: DictionaryAble {
    public var dictionary: [Element.Key: Element.Value] {
        typealias Target = [Element.Key: Element.Value]

        let mapping: [(Element.Key, Element.Value)] = self.map {
            ($0.key, $0.value)
        }
        return Dictionary(uniqueKeysWithValues: mapping)
    }
}
