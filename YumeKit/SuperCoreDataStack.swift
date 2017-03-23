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

public var mainMOC:NSManagedObjectContext? = SuperCoreDataStack.defaultStack.managedObjectContext
public var backgroundMOC:NSManagedObjectContext? = SuperCoreDataStack.defaultStack.backgroundContext

let infoDictionary = Bundle.main.infoDictionary as NSDictionary?
let stackName = "BusApp"//infoDictionary!["CFBundleName"] as! String
let storeName = stackName + ".sqlite"
let bigUpdateStoreName = "_" + storeName
let storeNameURL = applicationDocumentsDirectory.appendingPathComponent(storeName)
let bigUpdateStoreNameURL = applicationDocumentsDirectory.appendingPathComponent(bigUpdateStoreName)
let groupName = "group.yume190Team"
let stackOption = [NSMigratePersistentStoresAutomaticallyOption: true,
                   NSInferMappingModelAutomaticallyOption: true]

let applicationDocumentsDirectory: URL = {
    let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//    let url = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier(groupName)
        return urls.last!
    }()

open class SuperCoreDataStack: NSObject {
    
    let persistentStoreURL : URL?
    let storeType : String
    
    //TODO: Move away from this pattern so developers can use their own stack name and specify store type.
    open class var defaultStack : SuperCoreDataStack {
        struct DefaultStatic {
            static let instance : SuperCoreDataStack = SuperCoreDataStack(storeType:NSSQLiteStoreType,storeURL: applicationDocumentsDirectory.appendingPathComponent(storeName))
        }
        return DefaultStatic.instance
    }
    
    open class var inMemoryStack : SuperCoreDataStack {
        struct InMemoryStatic {
            static let instance : SuperCoreDataStack = SuperCoreDataStack(storeType:NSInMemoryStoreType,storeURL:nil)
        }
        return InMemoryStatic.instance
    }
    
    init(storeType: String, storeURL: URL?) {
        self.persistentStoreURL = storeURL
        self.storeType = storeType
        
        super.init()
    }
    
    deinit{
        managedObjectContext = nil
        backgroundContext = nil
        bigUpdateBackgroundContext = nil
        bigUpdateManagedObjectContext = nil
    }
    
    // MARK: - Core Data stack
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: stackName, withExtension: "momd")
        return NSManagedObjectModel(contentsOf: modelURL!)!
        }()
    
    open lazy var managedObjectContext: NSManagedObjectContext? = self.createMainMOC(self.copiedCoordinator())
    open lazy var backgroundContext: NSManagedObjectContext? = self.createBackgroundMOC(self.normalCoordinator(storeNameURL))
    open lazy var bigUpdateManagedObjectContext: NSManagedObjectContext? = self.createMainMOC(self.normalCoordinator(bigUpdateStoreNameURL))
    open lazy var bigUpdateBackgroundContext: NSManagedObjectContext? = self.createBackgroundMOC(self.normalCoordinator(bigUpdateStoreNameURL))
    
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
    
    private func copiedCoordinator() -> NSPersistentStoreCoordinator? {
        checkAndCopyDatabaseFromProject()
        return normalCoordinator(storeNameURL)
    }
    
    private func checkAndCopyDatabaseFromProject() {
        if !FileManager.default.fileExists(atPath: self.persistentStoreURL!.path) {
            copyDatabaseFileFromMainBundle("sqlite")
            copyDatabaseFileFromMainBundle("sqlite-shm")
            copyDatabaseFileFromMainBundle("sqlite-wal")
        }
    }
    
    private func copyDatabaseFileFromMainBundle(_ extensionName:String) {
        #if TC
            let prefix = "TC_"
        #elseif PD
            let prefix = "PD_"
        #elseif CH
            let prefix = "CH_"
        #elseif KM
            let prefix = "KM_"
        #else
            let prefix = ""
        #endif
        
        let target = prefix + "BusApp"
        guard let fromFile = Bundle.main.url(forResource: target, withExtension: extensionName) else {
            print("Can't load \(target) from main bundle")
            return
        }
        
        print("Load \(target) from main bundle")
        let toFile = applicationDocumentsDirectory.appendingPathComponent(stackName + "." + extensionName)
        SuperCoreDataStack.copyFile(fromFile, toFile: toFile)
    }
    
    public static func updatingDatabase() {
        if FileManager.default.fileExists(atPath: bigUpdateStoreNameURL.path) {
            updatingDatabaseFile(bigUpdateStoreName,storeName)
            updatingDatabaseFile(bigUpdateStoreName + "-shm",storeName + "-shm")
            updatingDatabaseFile(bigUpdateStoreName + "-wal",storeName + "-wal")
        }
    }
    
    private static func updatingDatabaseFile(_ from:String,_ to:String) {
        let fromFile = applicationDocumentsDirectory.appendingPathComponent(from)
        let toFile = applicationDocumentsDirectory.appendingPathComponent(to)
        
        deleteFile(toFile)
        copyFile(fromFile, toFile: toFile)
        deleteFile(fromFile)
    }
    
    private static func deleteFile(_ file:URL) {
        if FileManager.default.fileExists(atPath: file.path) {
            do {
                try FileManager.default.removeItem(at: file)
            } catch {
                NSLog("\(error)")
            }
        }
    }
    
    private static func copyFile(_ fromFile:URL,toFile:URL) {
        if !FileManager.default.fileExists(atPath: toFile.path) {
            do {
                try FileManager.default.copyItem(at: fromFile, to: toFile)
            } catch {
                NSLog("\(error)")
            }
        }
    }
    
    private func normalCoordinator(_ url:URL) -> NSPersistentStoreCoordinator? {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        do {
            try coordinator.addPersistentStore(ofType: self.storeType as String, configurationName: nil, at: url, options: stackOption)
        } catch {
            return nil
        }
        return coordinator
    }
    
}

public extension NSManagedObjectContext {
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
