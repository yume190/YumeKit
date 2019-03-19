//
//  FPMacro.swift
//  BusApp
//
//  Created by Yume on 2017/1/12.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

public struct Measure {
    public static func MEASURE<A, B>(_ function:@escaping ((A) -> B)) -> ((A) -> B) {
        return MEASURE("Start", "End", function)
    }

    public static func MEASURE<A, B>(_ description: String, _ function:@escaping ((A) -> B)) -> ((A) -> B) {
        return MEASURE(description + " Start", description + " End", function)
    }

    public static func MEASURE<A, B>(_ start: String, _ end: String, _ function:@escaping ((A) -> B)) -> ((A) -> B) {
        func wrapFunction(_ parameter: A) -> B {
            NSLog(start)
            defer { NSLog(end) }
            return function(parameter)
        }
        return wrapFunction
    }
}
