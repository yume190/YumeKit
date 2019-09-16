////
////  SignPost.swift
////
////  Created by Yume on 2018/12/5.
////  Copyright © 2018 Yume. All rights reserved.
////
//
//import Foundation
//import os.signpost
//
//public protocol SignPostable {
//    var subsystem: String { get }
//    var category: String { get }
//    var object: AnyObject? {get}
//
//    var log: OSLog? {get}
//    @available(iOS 12.0, *)
//    var id: OSSignpostID? {get}
//
//}
//
//
//extension SignPostable {
//    var log: OSLog? {
//        if #available(iOS 10.0, *) {
//            if !ProcessInfo.processInfo.environment.keys.contains("SIGNPOSTS_FOR_REFRESH") {
//                return .disabled
//            }
//            return OSLog(subsystem: self.subsystem, category: self.category)
//        } else {
//            return nil
//        }
//    }
//
//    @available(iOS 12.0, *)
//    var id: OSSignpostID? {
//        guard let log: OSLog = self.log else {return nil}
//        guard let object: AnyObject = self.object else {return nil}
//        return OSSignpostID(log: log, object: self.object)
//    }
//
//}
//
///// Log category:   Related operations
///// Signpost name:  An operation to measure
///// Signpost ID:    Single interval
//struct SignPost: SignPostable {
//    let subsystem: String
//    let category: String
//    let object: AnyObject?
//
//    enum Category: String {
//        case baseDataUpdate
//
//
//        var log: OSLog {
//            //            if !ProcessInfo.processInfo.environment.keys.contains("SIGNPOSTS_FOR_REFRESH") {
//            //                return .disabled
//            //            }
//
//            return OSLog(subsystem: "com.maxwin.FlowerBus", category: self.rawValue)
//        }
//
//        /// Signpost IDs are process-scoped
//        /// Making from object is convenient if you have the same object at .begin and .end
//        @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
//        func id(object: AnyObject) -> OSSignpostID {
//            return OSSignpostID(log: self.log, object: object)
//        }
//
//        //        @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
//        //        public func os_signpost(_ type: OSSignpostType, dso: UnsafeRawPointer = #dsohandle, log: OSLog, name: StaticString, signpostID: OSSignpostID = default, _ format: StaticString, _ arguments: CVarArg...)
//        // dso: UnsafeRawPointer = #dsohandle
//        // _ format: StaticString, _ arguments: CVarArg...
//        @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
//        func post(type: OSSignpostType, name: StaticString, id: OSSignpostID? = nil) {
//            if let id = id {
//                os_signpost(type, log: self.log, name: name, signpostID: id)
//            } else {
//                os_signpost(type, log: self.log, name: name)
//            }
//        }
//
//        @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
//        func post(type: OSSignpostType, name: StaticString, object: AnyObject? = nil) {
//            let id: OSSignpostID?
//            if let object = object {
//                id = self.id(object: object)
//            } else {
//                id = nil
//            }
//            self.post(type: type, name: name, id: id)
//        }
//
//        @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
//        func execute(name: StaticString, id: OSSignpostID, function: @autoclosure () throws -> ()) rethrows {
//            self.post(type: .begin, name: name, id: id)
//            try function()
//            self.post(type: .end, name: name, id: id)
//        }
//
//        @available(OSX 10.14, iOS 12.0, watchOS 5.0, tvOS 12.0, *)
//        func execute(name: StaticString, object: AnyObject? = nil, function: @autoclosure () throws -> ()) rethrows {
//            self.post(type: .begin, name: name, object: object)
//            try function()
//            self.post(type: .end, name: name, object: object)
//        }
//    }
//}
