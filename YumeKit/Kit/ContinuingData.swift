//
//  ContinuesData.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

public enum ContinuingData<Element: Hashable> {
    case pm(previous:Element, middle:Element)
    case pmn(previous:Element, middle:Element, next:Element)
    case mn(middle:Element, next:Element)
    case m(middle:Element)
    case none

    public static func findPrevious(array: [Element], middleIndex: Int) -> Element? {
        let index = middleIndex - 1
        if array.count < 0 {
            return nil
        }

        if index < 0 {
            return nil
        }
        return array[index]
    }

    public static func findNext(array: [Element], middleIndex: Int) -> Element? {
        let index = middleIndex + 1
        if (index + 1) <= array.count {
            return array[index]
        }
        return nil
    }

    public static func findContinousData(array: [Element], middle: Element) -> ContinuingData<Element> {
        guard let middleIndex = array.firstIndex(of: middle) else {
            return .none
        }

        let _previous = ContinuingData.findPrevious(array: array, middleIndex: middleIndex)
        let _next = ContinuingData.findNext(array: array, middleIndex: middleIndex)

        if let previous = _previous, _next == nil {
            return .pm(previous: previous, middle: middle)
        } else if let next = _next, _previous == nil {
            return .mn(middle: middle, next: next)
        } else if let next = _next, let previous = _previous {
            return .pmn(previous: previous, middle: middle, next: next)
        } else {
            return .m(middle:middle)
        }
    }

    public var previous: Element? {
        switch self {
        case .pm(let previous, _):return previous
        case .pmn(let previous, _, _):return previous
        default:return nil
        }
    }

    public var middle: Element? {
        switch self {
        case .pm(_, let middle):return middle
        case .pmn(_, let middle, _):return middle
        case .mn(let middle, _):return middle
        case .m(let middle):return middle
        default:return nil
        }
    }

    public var next: Element? {
        switch self {
        case .pmn(_, _, let next):return next
        case .mn(_, let next):return next
        default:return nil
        }
    }
}
