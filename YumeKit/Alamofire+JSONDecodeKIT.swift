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

public enum Entry {
    case StopEstimateTime // "http://163.29.110.218/busstop/getdata"
    case StopSchedule // "http://163.29.110.218/api/schedule"
    case custom(url:String)
    fileprivate var url:String {
        switch self {
        case .StopEstimateTime:
            return "http://163.29.110.218/busstop/getdata"
        case .StopSchedule:
            return "http://163.29.110.218/api/schedule"
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

public func commomNetworkCallSingle<OutputType:JSONDecodable>(
    entry:Entry,
    parameters:[String:String],
    noResponseProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    not200ProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    handler: ((OutputType) -> Void)?) {
    Alamofire.request(entry.url, method: .get, parameters: parameters).response {
        res in
        
        guard let response = res.response,let data = res.data else {
            print("API No Response.")
            noResponseProcessFunc(nil)
            return
        }
        
        guard response.statusCode == 200 else {
            print("API Status Code Not 200")
            not200ProcessFunc(data)
            return
        }
        
        do {
            let output = try OutputType.decode(JSON(data: data,isTraceKeypath:true))
            handler?(output)
        } catch {
            print(
                "API Data Parse Error.\n" +
                "Type : \(OutputType.self)\n" +
                "Url : \(res.request?.url)"
            )
            print(error)
        }
    }
}

public func commomNetworkCallArray<OutputType:JSONDecodable>(
    entry:Entry,
    parameters:[String:String],
    noResponseProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    not200ProcessFunc:@escaping ProcessDataFunction = recordProcessDataFunction,
    handler: (([OutputType]) -> Void)?) {
    Alamofire.request(entry.url, method: .get, parameters: parameters).response {
        res in
        
        guard let response = res.response,let data = res.data else {
            print("API No Response.")
            noResponseProcessFunc(nil)
            return
        }
        
        guard response.statusCode == 200 else {
            print("API Status Code Not 200")
            not200ProcessFunc(data)
            return
        }
        
        do {
            let output:[OutputType] = try JSON(data: data,isTraceKeypath:true).toArray()
            handler?(output)
        } catch {
            print(
                "API Data Parse Error.\n" +
                "Type : \(OutputType.self)\n" +
                "Url : \(res.request?.url)"
            )
            print(error)
        }
    }
}
