//
//  Notifiable.swift
//  YumeKit
//
//  Created by Yume on 2019/3/18.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol Cancelable {
    func cancel()
}

public protocol NotificationCancelable: Cancelable {}

fileprivate final class NotificationObserver: NotificationCancelable {
    
    private let object: NSObjectProtocol
    fileprivate init(object: NSObjectProtocol) {
        self.object = object
    }
    
    public func cancel() {
        NotificationCenter.default.removeObserver(self.object)
    }
}

public protocol Notifiable {
    var name: NSNotification.Name { get }

    func add(object: Any?, queue: OperationQueue?, using: @escaping (Notification) -> Void) -> NotificationCancelable
    func add(observer: Any, selector: Selector, object: Any?)
    func remove(observer: Any, object: Any?)
    func post(object: Any?, userInfo: [AnyHashable: Any]?)
}

public extension Notifiable {
    func add(object: Any? = nil, queue: OperationQueue?, using: @escaping (Notification) -> Void) -> NotificationCancelable {
        return NotificationObserver(
            object: NotificationCenter.default.addObserver(forName: self.name, object: object, queue: queue, using: using)
        )
    }
    
    func add(observer: Any, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }

    func remove(observer: Any, object: Any? = nil) {
        NotificationCenter.default.removeObserver(observer, name: name, object: object)
    }

    func post(object: Any? = nil, userInfo: [AnyHashable: Any]? = nil) {
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
}

extension NSNotification.Name: Notifiable {
    public var name: NSNotification.Name {
        return self
    }
}

#if canImport(RxSwift)
import RxSwift

public extension Notifiable {
    var rx: Observable<Notification> {
        return NotificationCenter.default.rx
            .notification(self.name)
    }
    
    func autoDeallocatedRx(_ object: NSObject) -> Observable<Notification> {
        return self.rx
          .takeUntil(object.rx.deallocated) //页面销毁自动移除通知监听
    }
}
#endif
