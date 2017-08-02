//
//  DictionaryAble.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

public protocol DictionaryAble {
    associatedtype Key:Hashable
    associatedtype Value
    typealias DictionaryType = [Key:Value]
    var key:Key {get}
    var value:Value {get}
}

extension Array where Element:DictionaryAble {
    public func toDictionary() -> Element.DictionaryType {//-> [Key:Value] {
        return self.reduce(Element.DictionaryType()) {
            (dict:Element.DictionaryType, next:Array.Element) -> Element.DictionaryType in
            var _dict = dict
            _dict[next.key] = next.value
            return _dict
        }
    }
}

//func toDictionary<Dict:DictionaryAble>() -> [Dict.Key:Dict.Value] {//-> [Key:Value] {
//    return [:]
//}
