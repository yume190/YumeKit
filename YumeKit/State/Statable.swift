//
//  Statable.swift
//  MaxwinBus
//
//  Created by Yume on 2019/2/22.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol Statable: class {
    associatedtype Result
    typealias Event = (Result) -> Result

    #if DEBUG
    var events: [Event] { get set }
    #endif
    var result: Result { get set }
    @discardableResult
    func recieve(event: @escaping Event) -> Result
}

extension Statable {
    @discardableResult
    public func recieve(event: @escaping Event) -> Result {
        #if DEBUG
        self.events.append(event)
        #endif
        self.result = event(self.result)
        return self.result
    }
}
