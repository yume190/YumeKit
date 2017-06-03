//
//  Updater.swift
//  BusApp
//
//  Created by Yume on 2016/8/31.
//  Copyright © 2016年 Yume. All rights reserved.
//

import Foundation
import Alamofire
import CryptoSwift

public protocol UpdaterDelegate:class {
    var FILE_NAME:String {get}
    var FILE_EXTENSION:String {get}
    var FILE_FULL_NAME:String {get}
    
    func apiRequest(_ url:String) -> Alamofire.DataRequest
    func update(_ data:Data)
}

extension UpdaterDelegate {
    public var FILE_FULL_NAME:String { return "\(FILE_NAME).\(FILE_EXTENSION)" }
}

// 責任：負責 存取檔案 & 讀取檔案 (格式 Data)
// API 來源交由 delegate 提供
// 要如何 Update 經由 delegate 處置
open class Updater {
    public final let API:String
    public final weak var delegate:UpdaterDelegate?
    
    public init(API:String) {
        self.API = API
    }
    
    public final func updateData() {
        delegate?.apiRequest(API).response {
            res in
            guard let data = res.data else {
                self.forceUpdate()
                return
            }

            if data.md5().toHexString() != self.getCurrentMD5(), self.saveFile(data) {
                self.delegate?.update(data)
            } else {
                self.forceUpdate()
            }
        }
    }
    
    private final func forceUpdate() {
        if let data = getCurrentData() {
            self.delegate?.update(data)
        }
    }
}

// MARK: DATA FILE URL
extension Updater {
    final var downloadedJSONURL:URL? {
        guard let delegate = delegate else { return nil }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent(delegate.FILE_FULL_NAME)
    }
    
    final var appJSONURL:URL? {
        guard let delegate = delegate else { return nil }
        return Bundle.main.url(forResource: delegate.FILE_NAME, withExtension: delegate.FILE_EXTENSION)
    }
}

extension Updater {
    fileprivate final func saveFile(_ data:Data) -> Bool {
        guard let downloadedJSONURL = downloadedJSONURL else { return false }
        // 刪除既有檔案
        if FileManager.default.fileExists(atPath: downloadedJSONURL.path) {
            do {
                try FileManager.default.removeItem(at: downloadedJSONURL)
            } catch {
                NSLog("\(error)")
            }
        }
        
        // 存檔
        FileManager.default.createFile(atPath: downloadedJSONURL.path, contents: data, attributes: nil)
        return true
    }
    
    fileprivate final func getCurrentData() -> Data? {
        if let downloadedJSONURL = downloadedJSONURL {
            return (try? Data(contentsOf: downloadedJSONURL))
        }
        if let appJSONURL = appJSONURL {
            return (try? Data(contentsOf: appJSONURL))
        }
        return nil
    }
    
    fileprivate final func getCurrentMD5() -> String {
        if let data = getCurrentData() {
            return data.md5().toHexString()
        }
        return ""
    }
    
}
