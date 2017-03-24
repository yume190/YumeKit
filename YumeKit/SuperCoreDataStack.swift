//
//  SuperCoreDataStack.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 12/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Setup a CoreData Stack accessible via a singleton.
//
//  NOTE: !!This Boiler Plate singleton is experimental and a work in progress!!

import UIKit
import CoreData

public var mainMOC:NSManagedObjectContext? = nil//SuperCoreDataStack.defaultStack.managedObjectContext
public var backgroundMOC:NSManagedObjectContext? = nil//SuperCoreDataStack.defaultStack.backgroundContext
public func setSuperStackMOC(main:NSManagedObjectContext?, background:NSManagedObjectContext?) {
    mainMOC = main
    backgroundMOC = background
}

//let groupName = "group.yume190Team"

fileprivate struct SuperCoreDataStackConfig {
    fileprivate static let bigUpdatePrefix = "_"
    fileprivate static let defaultStackName:String = {
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        return bundleName ?? "YumeKit"
    }()
    fileprivate static let stackOption = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
    ]
}

open class SuperCoreDataStack {
    
    fileprivate let resourcePrefix:String
    fileprivate let storeType:String
    fileprivate let stackName:String
    
    public enum CoreDataType {
        case sql
        case memory
        case binary
        
        public var type:String {
            switch self {
            case .sql:
                return NSSQLiteStoreType
            case .memory:
                return NSInMemoryStoreType
            case .binary:
                return NSInMemoryStoreType
            }
        }
        
        public var stack:SuperCoreDataStack? {
            return customStackName(name: SuperCoreDataStackConfig.defaultStackName,prefix: "")
        }
        
        public func customStackName(name:String,prefix:String) -> SuperCoreDataStack? {
            return SuperCoreDataStack(
                storeType:self.type,
                stackName:name,
                resourcePrefix:prefix
            )
        }
    }
    
    fileprivate let storeName:String
    fileprivate let bigUpdateStoreName:String
    fileprivate let storeNameURL:URL
    fileprivate let bigUpdateStoreNameURL:URL
    fileprivate let userDocumentURL:URL
    fileprivate let modelURL:URL
    init?(storeType: String,stackName:String,resourcePrefix:String = "") {
        guard
        let userDocumentURL:URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last,
        let modelURL = Bundle.main.url(forResource: stackName, withExtension: "momd")
        else {
            //    let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupName)
            return nil
        }
        self.stackName = stackName
        self.storeType = storeType
        self.resourcePrefix = resourcePrefix
        
        self.storeName = stackName + ".sqlite"
        self.bigUpdateStoreName = SuperCoreDataStackConfig.bigUpdatePrefix + storeName
        self.storeNameURL = userDocumentURL.appendingPathComponent(storeName)
        self.bigUpdateStoreNameURL = userDocumentURL.appendingPathComponent(bigUpdateStoreName)
        self.userDocumentURL = userDocumentURL
        self.modelURL = modelURL
        
        checkAndCopyDatabaseFromProject()
        setSuperStackMOC(main: self.managedObjectContext, background: self.backgroundContext)
    }
    
    deinit{
        managedObjectContext = nil
        backgroundContext = nil
        bigUpdateBackgroundContext = nil
        bigUpdateManagedObjectContext = nil
    }
    
    // MARK: - Core Data stack
    
    // MARK: MOM
    lazy var managedObjectModel: NSManagedObjectModel? = NSManagedObjectModel(contentsOf: self.modelURL)
    
    // MARK: Coordinator
    private func normalCoordinator(_ url:URL) -> NSPersistentStoreCoordinator? {
        guard let managedObjectModel = self.managedObjectModel else {
            return nil
        }
        
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: self.storeType, configurationName: nil, at: url, options: SuperCoreDataStackConfig.stackOption)
        } catch {
            return nil
        }
        return coordinator
    }
    
    // MARK: MOC
    open lazy var managedObjectContext: NSManagedObjectContext? =
        self.createMainMOC(self.normalCoordinator(self.storeNameURL))
    open lazy var backgroundContext: NSManagedObjectContext? =
        self.createBackgroundMOC(self.normalCoordinator(self.storeNameURL))
    open lazy var bigUpdateManagedObjectContext: NSManagedObjectContext? =
        self.createMainMOC(self.normalCoordinator(self.bigUpdateStoreNameURL))
    open lazy var bigUpdateBackgroundContext: NSManagedObjectContext? =
        self.createBackgroundMOC(self.normalCoordinator(self.bigUpdateStoreNameURL))
    
    // MARK: UTIL
    func createMainMOC(_ coordinator:NSPersistentStoreCoordinator?) -> NSManagedObjectContext? {
        guard let coordinator = coordinator else {
            return nil
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSRollbackMergePolicy
        return managedObjectContext
    }
    
    private func createBackgroundMOC(_ coordinator:NSPersistentStoreCoordinator?) -> NSManagedObjectContext? {
        guard let coordinator = coordinator else {
            return nil
        }
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }
}

extension SuperCoreDataStack {
    fileprivate func checkAndCopyDatabaseFromProject() {
        if !FileManager.default.fileExists(atPath: self.storeNameURL.path) {
            copyDatabaseFileFromMainBundle("sqlite")
            copyDatabaseFileFromMainBundle("sqlite-shm")
            copyDatabaseFileFromMainBundle("sqlite-wal")
        }
    }
    
    fileprivate func copyDatabaseFileFromMainBundle(_ extensionName:String) {
        let targetName = self.resourcePrefix + "BusApp"
        let target = targetName + "." + extensionName
        guard let fromFile = Bundle.main.url(forResource: targetName, withExtension: extensionName) else {
            print("Can't load \(target) from main bundle")
            return
        }
        
        print("Load \(target) from main bundle")
        let toFile = self.userDocumentURL.appendingPathComponent(stackName + "." + extensionName)
        self.copyFile(fromFile, toFile: toFile)
    }
    
    public func updatingDatabase() {
        if FileManager.default.fileExists(atPath: self.bigUpdateStoreNameURL.path) {
            updatingDatabaseFile(self.bigUpdateStoreName,self.storeName)
            updatingDatabaseFile(self.bigUpdateStoreName + "-shm",self.storeName + "-shm")
            updatingDatabaseFile(self.bigUpdateStoreName + "-wal",self.storeName + "-wal")
        }
    }
    
    private func updatingDatabaseFile(_ from:String,_ to:String) {
        let fromFile = self.userDocumentURL.appendingPathComponent(from)
        let toFile = self.userDocumentURL.appendingPathComponent(to)
        
        deleteFile(toFile)
        copyFile(fromFile, toFile: toFile)
        deleteFile(fromFile)
    }
    
    private func deleteFile(_ file:URL) {
        if FileManager.default.fileExists(atPath: file.path) {
            do {
                try FileManager.default.removeItem(at: file)
            } catch {
                NSLog("\(error)")
            }
        }
    }
    
    private func copyFile(_ fromFile:URL,toFile:URL) {
        if !FileManager.default.fileExists(atPath: toFile.path) {
            do {
                try FileManager.default.copyItem(at: fromFile, to: toFile)
            } catch {
                NSLog("\(error)")
            }
        }
    }
}

extension SuperCoreDataStack {
    // MARK: - Core Data Saving support
    
    open func saveContext () {
        saveContext(self.managedObjectContext)
    }
    
    open func saveContext (_ context:NSManagedObjectContext?) {
        //TODO: Improve error handling.
        if let moc = context {
            if moc.hasChanges {
                do {
                    try moc.save()
                } catch let error as NSError {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    NSLog("Unresolved error \(error), \(error.userInfo)")
                    abort()
                }
            }
        }
    }
}

extension NSManagedObjectContext {
    public func mSave() {
        //TODO: Improve error handling.
        
        if self.hasChanges {
            do {
                try self.save()
            } catch let error as NSError {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                NSLog("Unresolved error \(error), \(error.userInfo)")
                //            abort()
            }
        }
    }
}
