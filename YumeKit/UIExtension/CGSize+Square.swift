//
//  CGSize+Square.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/8.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

public extension CGSize {
    static func square(length: Double) -> CGSize {
        return CGSize(width: length, height: length)
    }
}
