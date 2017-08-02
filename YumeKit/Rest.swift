//
//  Rest.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

public enum Rest {
    case host(host:String, port:Int?)
    case full(host:String, port:Int? ,path:String)
    
    public static func + (rest:Rest,subPath:String) -> Rest {
        switch rest {
        case host(let host, let port): return .full(host: host, port: port, path: subPath)
        case full(let host, let port, let path): return .full(host: host, port: port, path: path + subPath)
        }
    }
    
    public var url:String {
        get{
            switch self {
            case .host(let host, let port):
                guard let _port = port else { return host }
                return "\(host):\(_port)"
            case .full(let host, let port, let path):
                guard let _port = port else { return host + path }
                return "\(host):\(_port)\(path)"
            }
        }
    }
}
