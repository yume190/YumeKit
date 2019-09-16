//
//  Drawerable.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

public protocol Drawerable: class {
    var center: UIViewController? { get set }
    var left: UIViewController? { get set }
    var right: UIViewController? { get set }
    
    var isOpen: Bool { get }
    
    var menu: Menu.Instance? { get }
    
    func open(way: Drawer.Way)
    func close(way: Drawer.Way)
    
    func enable(way: Drawer.Way)
    func disable(way: Drawer.Way)
}
