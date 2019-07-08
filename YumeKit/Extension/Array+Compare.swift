//
//  Array+Compare.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/8.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Optional: Comparable where Wrapped: Comparable {
    public static func < (lhs: Optional<Wrapped>, rhs: Optional<Wrapped>) -> Bool {
        switch (lhs, rhs) {
        case (.none, .some): return true
        case (.some, .none): return false
        case (.none, .none): return false
        case (.some(let l), .some(let r)): return l < r
        }
    }
}
