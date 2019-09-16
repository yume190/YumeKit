//
//  Menu+List.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol MenuListable {
    static var `default`: [Menu.Item] {get}
}

internal struct DummyMenuList: MenuListable {
    static let `default`: [Menu.Item] = []
}
