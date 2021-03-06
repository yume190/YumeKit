//
//  MessageQueue.swift
//  BusApp
//
//  Created by Yume on 2016/4/28.
//  Copyright © 2016年 Yume. All rights reserved.
//

import Foundation

public final class MessageQueue {

    public typealias Message = () -> Void

    fileprivate final var isHandleingMessage: Bool = false
    fileprivate final var messageQueue: [Message] = []
    fileprivate final var loopInterval: DispatchTimeInterval

    public let dispatchQueue: DispatchQueue

    public init (name: String, loopInterval: DispatchTimeInterval = DispatchTimeInterval.milliseconds(500)) {
        self.loopInterval = loopInterval
        self.dispatchQueue = DispatchQueue(label: name, qos: DispatchQoS.background)
        self.loopAfterInBackground {
            self.loop()
        }
    }

    fileprivate func loop() {
        if !isHandleingMessage {
            if let msg = messageQueue.first {
                messageQueue.removeFirst(1)
                handleMessage(msg)
            }
        }

        loopAfterInBackground {
            self.loop()
        }
    }

    fileprivate func loopAfterInBackground(_ block:@escaping () -> Void) {
        let time: DispatchTime = DispatchTime.now() + loopInterval
        let backQ: DispatchQueue = DispatchQueue.global(qos: .background)
        backQ.asyncAfter(deadline: time, execute: block)
    }

    fileprivate func handleMessage(_ msg: Message) {
        isHandleingMessage = true
        dispatchQueue.sync {
            msg()
        }
        isHandleingMessage = false
    }

    public func sendMessage(_ msg:@escaping Message) {
        messageQueue.append(msg)
    }

    public func clear() {
        messageQueue = []
    }

}
