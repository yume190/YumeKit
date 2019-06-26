//
//  Monoid.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

// http://www.fewbutripe.com/swift/math/algebra/monoid/2017/04/18/algbera-of-predicates-and-sorting-functions.html

import Foundation

infix operator <>: AdditionPrecedence

public protocol Semigroup {
    // **AXIOM** Associativity
    // For all a, b, c in Self:
    //    a <> (b <> c) == (a <> b) <> c
    static func <> (lhs: Self, rhs: Self) -> Self
}

public protocol Monoid: Semigroup {
    // **AXIOM** Identity
    // For all a in Self:
    //    a <> e == e <> a == a

    static var e: Self { get }
}

extension Bool: Monoid {
    public static func <>(lhs: Bool, rhs: Bool) -> Bool {
        return lhs && rhs
    }

    public static let e = true
}

extension Int: Monoid {
    public static func <>(lhs: Int, rhs: Int) -> Int {
        return lhs + rhs
    }
    public static let e = 0
}

extension String: Monoid {
    public static func <>(lhs: String, rhs: String) -> String {
        return lhs + rhs
    }
    public static let e = ""
}

extension Array: Monoid {
    public static func <>(lhs: Array, rhs: Array) -> Array {
        return lhs + rhs
    }
    public static var e: [Element] { return [] }
    //      ^-- Static properties are not allowed on generics in
    //          Swift 3.1, so we must store it as a computed variable.
}

extension Dictionary: Monoid {
    public static func <>(lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
        //        let l = lhs.flatMap {($0.key,$0.value)}
        //        let r = rhs.flatMap {($0.key,$0.value)}
        //        let all:[(Key,Value)] = l + r
        //        let _: [Key:Value] = Dictionary<Key,Value>(dictionaryLiteral: all)

        var result: [Key: Value] = lhs
        for key in rhs.keys {
            result[key] = rhs[key]
        }

        return result
    }
    public static var e: [Key: Value] { return [:] }
}

public struct FunctionM<A, M: Monoid> {
    public let call: (A) -> M
    public init(call:@escaping (A) -> M) {
        self.call = call
    }
}
extension FunctionM: Monoid {
    public static func <>(lhs: FunctionM, rhs: FunctionM) -> FunctionM {
        return FunctionM { x in
            return lhs.call(x) <> rhs.call(x)
        }
    }

    public static var e: FunctionM {
        return FunctionM { _ in M.e }
    }
}
