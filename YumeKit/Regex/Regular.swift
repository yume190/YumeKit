//
//  ReMacro.swift
//  Bus
//
//  Created by Yume on 2015/3/7.
//  Copyright (c) 2015年 Yume. All rights reserved.
//

import UIKit

infix operator =~ :ComparisonPrecedence
infix operator ==~ :ComparisonPrecedence
extension String {
    public static func =~ (lhs: String, rhs: String) -> Bool {
        return RegexHelper(rhs).match(lhs)
    }

    public static func ==~ (lhs: String, rhs: String) -> [String] {
        return RegexHelper(rhs).match2(lhs)
    }
}

public struct RegexHelper {
    private var regex: NSRegularExpression?

    public init(_ pattern: String) {
        do {
            self.regex = try NSRegularExpression(pattern: pattern,
                options: .caseInsensitive)
        } catch {
            print(error)
        }
    }

    public func match(_ input: String) -> Bool {
        if let matches: [NSTextCheckingResult] = regex?.matches(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            return matches.count > 0
        } else {
            return false
        }
    }

    public func match2(_ input: String) -> [String] {
        if let matches: [NSTextCheckingResult] = regex?.matches(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            let s: NSString = input as NSString
            return matches.map { s.substring(with: $0.range) }
        } else {
            return []
        }
    }
}
