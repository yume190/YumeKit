//
//  EventSendable.swift
//  MaxwinBus
//
//  Created by Yume on 2019/2/22.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol EventSendable {
    associatedtype Result
    typealias Event = (Result) -> Result
    associatedtype State: Statable where State.Result == Result

    var state: State { get }

    func send(event: @escaping Event)
}

extension EventSendable {
    public func send(event: @escaping Event) {
        _ = self.state.recieve(event: event)
    }
}
