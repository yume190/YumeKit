//
//  SuperStack+Type.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/30.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation
import CoreData



extension SuperCoreDataStack {
    public enum CoreDataType {
        case sql
        case memory
        case binary
        
        public var type: String {
            switch self {
            case .sql:
                return NSSQLiteStoreType
            case .memory:
                return NSInMemoryStoreType
            case .binary:
                return NSBinaryStoreType
            }
        }
        
        public var stack: SuperCoreDataStack? {
            return customStackName(name: SuperCoreDataStack.Default.defaultStackName, prefix: "")
        }
        
        public func customStackName(name: String, momName: String? = nil, prefix: String = "") -> SuperCoreDataStack? {
            guard let userDocumentURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                return nil
            }
            
            let config: SuperCoreDataStack.Config = Config(
                type: self,
                stackName: name,
                momName: momName ?? name,
                prefixName: prefix,
                userDocumentURL: userDocumentURL
            )
            return SuperCoreDataStack(config: config)
        }
    }
}
