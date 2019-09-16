//
//  SuperStack+Config.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/30.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

import CoreData

extension SuperCoreDataStack {
    public struct Config {
        public let type: CoreDataType
        public let stackName: String // BusAPP
        public let momName: String
        public let prefixName: String
        
        public let userDocumentURL: URL
        
        var copyTargetName: String { return self.prefixName + self.stackName}
        var storeName: String { return self.stackName + ".sqlite" }
        var storeNameURL: URL { return self.userDocumentURL.appendingPathComponent(self.storeName) }
        
        func updatingDatabaseFile(_ from: String, _ to: String) {
            let fromFile: URL = self.userDocumentURL.appendingPathComponent(from)
            let toFile: URL = self.userDocumentURL.appendingPathComponent(to)
            
            self.deleteFile(toFile)
            self.copyFile(fromFile, toFile: toFile)
            self.deleteFile(fromFile)
        }
        
        func deleteFile(_ file: URL) {
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    try FileManager.default.removeItem(at: file)
                } catch {
                    NSLog("\(error)")
                }
            }
        }
        
        func copyFile(_ fromFile: URL, toFile: URL) {
            if !FileManager.default.fileExists(atPath: toFile.path) {
                do {
                    try FileManager.default.copyItem(at: fromFile, to: toFile)
                } catch {
                    NSLog("\(error)")
                }
            }
        }
    }
}
