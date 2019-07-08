//
//  Array+MinMax.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/8.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Array where Element: Comparable {
    public var minIndex: (min: Element, index: Int)? {
        guard let min: Element = self.min() else {return nil}
        guard let index: Int = self.firstIndex(of: min) else {return nil}
        return (min, index)
    }
    
    public var maxIndex: (max: Element, index: Int)? {
        guard let max: Element = self.max() else {return nil}
        guard let index: Int = self.firstIndex(of: max) else {return nil}
        return (max, index)
    }
}
