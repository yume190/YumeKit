//
//  Notifiable.swift
//  YumeKit
//
//  Created by Yume on 2019/3/18.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol Notifiable {
    var name: NSNotification.Name { get }

    func add(observer: Any, selector: Selector, object: Any?)
    func remove(observer: Any, object: Any?)
    func post(object: Any?, userInfo: [AnyHashable: Any]?)
}

extension Notifiable {
    public func add(observer: Any, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

    public func remove(observer: Any, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }

    public func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}

extension NSNotification.Name: Notifiable {
    public var name: NSNotification.Name {
        return self
    }
}
