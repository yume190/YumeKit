//
//  Alamofire+JSONDecodeKIT.swift
//  BusApp
//
//  Created by Yume on 2017/2/2.
//  Copyright © 2017年 Yume. All rights reserved.

//

import Foundation
import JSONDecodeKit
import Alamofire


// Alamofire.request(entry.url, method: .get, parameters: parameters).response {

//protocol RestAPI {
//    static var entry:Entry {get}
//    static var method:Alamofire.HTTPMethod {get}
//    static var parameters:Alamofire.Parameters? {get}
//    static var headers:Alamofire.HTTPHeaders? {get}
//}
//
//struct ABC:RestAPI {
//    static var entry:Entry = Entry.custom(url: "")
//    static var method:Alamofire.HTTPMethod = .get
//    static var parameters:Alamofire.Parameters? = [:]()
//    static var headers:Alamofire.HTTPHeaders? = nil
//    
//    static func call() {
//        
//    }
//}

public enum Entry {
    case custom(url:String)
    fileprivate var url:String {
        switch self {
        case .custom(let url):
            return url
        }
    }
}

public typealias ProcessDataFunction = (_ data:Data?) -> Swift.Void
public func passProcessDataFunction(data:Data?) {}
public func recordProcessDataFunction(data:Data?) {
    guard let data = data else {
        return
    }
    print("The error response : \(String.init(data: data, encoding: .utf8) ?? "")")
}

private func getResponseAndContentData(res:DefaultDataResponse,noResponseProcessFunc:ProcessDataFunction) -> (response:HTTPURLResponse,data:Data)? {
    guard let response = res.response,let data = res.data else {
        print("API (\(res.request?.url?.path ?? "")): No Response.")
        noResponseProcessFunc(nil)
        return nil
    }
    return (response:response,data:data)
}

private func decodeAsSingle<OutputType:JSONDecodable>(data:Data) throws -> OutputType {
    return try OutputType.decode(JSON(data: data,isTraceKeypath:true))
}

private func decodeAsArray<OutputType:JSONDecodable>(data:Data) throws -> [OutputType] {
    return try JSON(data: data,isTraceKeypath:true).toArray()
}

public func commomNetworkCallSingle<OutputType:JSONDecodable>(
    dataRequeset:Alamofire.DataRequest,
    noResponseProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    handler: ((OutputType) -> Void)?) {
    dataRequeset.response {
        res in
        
        guard let target = getResponseAndContentData(res: res, noResponseProcessFunc: noResponseProcessFunc) else {
            return
        }
        
        do {
            try handler?(decodeAsSingle(data:target.data))
        } catch {
            print([
                "API Data Parse Error.",
                "Type : \(OutputType.self)",
                "Url : \(res.request?.url?.path ?? "")"
                ].joined(separator: "\n"))
            print(error)
        }
    }
}

public func commomNetworkCallSingle<OutputType:JSONDecodable>(
    entry:Entry,
    parameters:[String:String],
    noResponseProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    handler: ((OutputType) -> Void)?) {
    
    commomNetworkCallSingle(
        dataRequeset:Alamofire.request(entry.url, method: .get, parameters: parameters),
        noResponseProcessFunc:noResponseProcessFunc,
        handler:handler
    )
}

public func commomNetworkCallArray<OutputType:JSONDecodable>(
    dataRequeset:Alamofire.DataRequest,
    noResponseProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    handler: (([OutputType]) -> Void)?) {
    dataRequeset.response {
        res in
        
        guard let target = getResponseAndContentData(res: res, noResponseProcessFunc: noResponseProcessFunc) else {
            return
        }
        
        do {
            try handler?(decodeAsArray(data: target.data))
        } catch {
            print([
                "API Data Parse Error.",
                "Type : \(OutputType.self)",
                "Url : \(res.request?.url?.path ?? "")"
                ].joined(separator: "\n"))
            print(error)
        }
    }
}

public func commomNetworkCallArray<OutputType:JSONDecodable>(
    entry:Entry,
    parameters:[String:String],
    noResponseProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    handler: (([OutputType]) -> Void)?) {
    
    commomNetworkCallArray(
        dataRequeset:Alamofire.request(entry.url, method: .get, parameters: parameters),
        noResponseProcessFunc:noResponseProcessFunc,
        handler:handler
    )
}
