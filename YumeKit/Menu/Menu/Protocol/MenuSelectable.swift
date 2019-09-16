//
//  MenuSelectable.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

import class UIKit.UIViewController

public protocol MenuSelectable: class {
    var list: MenuListable.Type { get }
    
    func change(item: Menu.Item)
}
