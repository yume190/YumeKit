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
    
    fileprivate final var isHandleingMessage = false
    fileprivate final var messageQueue:[Message] = []
    fileprivate final var loopInterval:DispatchTimeInterval
    
    open let dispatchQueue:DispatchQueue
    
    public init (name:String,loopInterval:DispatchTimeInterval = DispatchTimeInterval.milliseconds(500)) {
        self.loopInterval = loopInterval
        self.dispatchQueue = DispatchQueue(label: name, qos:DispatchQoS.background)
        self.loopAfterInBackground() {
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
        
        loopAfterInBackground() {
            self.loop()
        }
    }
    
    fileprivate func loopAfterInBackground(_ block:@escaping ()->()) {
        let time = DispatchTime.now() + loopInterval
        let backQ = DispatchQueue.global(qos: .background)
        backQ.asyncAfter(deadline: time, execute: block)
    }
    
    fileprivate func handleMessage(_ msg:Message) {
        isHandleingMessage = true
        dispatchQueue.sync {
            msg()
        }
        isHandleingMessage = false
    }
    
    open func sendMessage(_ msg:@escaping Message) {
        messageQueue.append(msg)
    }
    
    open func clear() {
        messageQueue = []
    }
    
}
