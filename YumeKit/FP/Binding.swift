//
//  FPMacro.swift
//  BusApp
//
//  Created by Yume on 2017/1/12.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

// MARK: Haskell Bind

infix operator >>- :BindPrecedence
precedencegroup BindPrecedence {
    // 132
    associativity: left
    lowerThan: RangeFormationPrecedence //135
    higherThan: ComparisonPrecedence //130
}

public func >>- <T, U>(box: Optional<T>, f: (T) -> Optional<U>) -> Optional<U> {
    return box.flatMap {f($0)}
}
