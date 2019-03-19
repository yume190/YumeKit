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

public var mainMOC: NSManagedObjectContext?//SuperCoreDataStack.defaultStack.managedObjectContext
public var backgroundMOC: NSManagedObjectContext?//SuperCoreDataStack.defaultStack.backgroundContext
public func setSuperStackMOC(main: NSManagedObjectContext?, background: NSManagedObjectContext?) {
    mainMOC = main
    backgroundMOC = background
}

//let groupName = "group.yume190Team"

private struct SuperCoreDataStackConfig {
    fileprivate static let bigUpdatePrefix = "_"
    fileprivate static let defaultStackName: String = {
        let bundleName = Bundle.main.infoDictionary?["CFBundleName"] as? String
        return bundleName ?? "YumeKit"
    }()
    fileprivate static let stackOption = [
        NSMigratePersistentStoresAutomaticallyOption: true,
        NSInferMappingModelAutomaticallyOption: true
    ]
}

open class SuperCoreDataStack {

    private struct Temp {
        let doc: URL
        let prefix: String
        let name: String

        var sql: String { return name + ".sqlite" }
        var sqlURL: URL { return doc.appendingPathComponent(self.sql) }
        var sqlShm: String { return name + ".sqlite-shm" }
        var sqlShmURL: URL { return doc.appendingPathComponent(self.sqlShm) }
        var sqlWal: String { return name + ".sqlite-wal" }
        var sqlWalURL: URL { return doc.appendingPathComponent(self.sqlWal) }

        private func isDBExist() -> Bool {
            return FileManager.default.fileExists(atPath: sqlURL.path)
        }
        func checkAndCopyDatabaseFromProject() {
            if !isDBExist() {
                print("Not Found DB copy db from main bundle")
                copyDatabaseFileFromMainBundle(extensionName: "sqlite")
                copyDatabaseFileFromMainBundle(extensionName: "sqlite-shm")
                copyDatabaseFileFromMainBundle(extensionName: "sqlite-wal")
            } else {
                print("Found DB, Don't need to copy")
            }
        }

        private func copyDatabaseFileFromMainBundle(extensionName: String) {
            let targetName = prefix + name
            let target = targetName + "." + extensionName
            guard let fromFile = Bundle.main.url(forResource: targetName, withExtension: extensionName) else {
                print("Can't load \(target) from main bundle")
                return
            }

            print("Load \(target) from main bundle")
            let toFile = doc.appendingPathComponent(name + "." + extensionName)
            Temp.copyFile(fromFile, toFile: toFile)
        }

        static func updatingDatabase(from: Temp, to: Temp) {
            if from.isDBExist() {
                print("Found big DB")
                updatingDatabaseFile(from.sqlURL, to.sqlURL)
                updatingDatabaseFile(from.sqlShmURL, to.sqlShmURL)
                updatingDatabaseFile(from.sqlWalURL, to.sqlWalURL)
            } else {
                print("Not Found big DB")
            }
        }

        static private func updatingDatabaseFile(_ from: URL, _ to: URL) {
            deleteFile(from)
            copyFile(from, toFile: to)
            deleteFile(from)
        }

        static private func deleteFile(_ file: URL) {
            if FileManager.default.fileExists(atPath: file.path) {
                do {
                    try FileManager.default.removeItem(at: file)
                } catch {
                    NSLog("\(error)")
                }
            }
        }

        static private func copyFile(_ fromFile: URL, toFile: URL) {
            if !FileManager.default.fileExists(atPath: toFile.path) {
                do {
                    try FileManager.default.copyItem(at: fromFile, to: toFile)
                } catch {
                    NSLog("\(error)")
                }
            }
        }
    }

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
            return customStackName(name: SuperCoreDataStackConfig.defaultStackName, prefix: "")
        }

        public func customStackName(name: String, prefix: String) -> SuperCoreDataStack? {
            return SuperCoreDataStack(
                storeType: self.type,
                stackName: name,
                resourcePrefix: prefix
            )
        }
    }

    fileprivate let coordinator: NSPersistentStoreCoordinator
    init?(storeType: String, stackName: String, resourcePrefix: String = "") {
        guard
            let userDocumentURL: URL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
            else {
                return nil
        }

        let origin = Temp(doc: userDocumentURL, prefix: resourcePrefix, name: stackName)
        let big = Temp(doc: userDocumentURL, prefix: resourcePrefix, name: "_" + stackName)
        origin.checkAndCopyDatabaseFromProject()
        Temp.updatingDatabase(from: big, to: origin)

        guard
            let momURL = Bundle.main.url(forResource: stackName, withExtension: "momd"),
            let mom = NSManagedObjectModel(contentsOf: momURL)
            else {
                return nil
        }

        guard
            let coordinator = SuperCoreDataStack.makeCoordinator(mom: mom, storeType: storeType, url: origin.sqlURL)
            else {
                return nil
        }
        self.coordinator = coordinator

        setSuperStackMOC(main: self.managedObjectContext, background: self.backgroundContext)
        NotificationCenter.default.addObserver(
            self.managedObjectContext,
            selector: #selector(NSManagedObjectContext.contextDidSaveContext(notification:)),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self.backgroundContext,
            selector: #selector(NSManagedObjectContext.contextDidSaveContext(notification:)),
            name: NSNotification.Name.NSManagedObjectContextDidSave,
            object: nil
        )
    }

    // MARK: - Core Data stack

    // MARK: Coordinator
    private class func makeCoordinator(mom: NSManagedObjectModel, storeType: String, url: URL) -> NSPersistentStoreCoordinator? {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: mom)
        do {
            try coordinator.addPersistentStore(ofType: storeType, configurationName: nil, at: url, options: SuperCoreDataStackConfig.stackOption)
        } catch {
            return nil
        }
        return coordinator
    }

    // MARK: MOC
    open lazy var managedObjectContext: NSManagedObjectContext =
        self.createMainMOC(self.coordinator)
    open lazy var backgroundContext: NSManagedObjectContext =
        self.createBackgroundMOC(self.coordinator)

    // MARK: UTIL
    func createMainMOC(_ coordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSRollbackMergePolicy
        return managedObjectContext
    }

    private func createBackgroundMOC(_ coordinator: NSPersistentStoreCoordinator) -> NSManagedObjectContext {
        let managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.mergePolicy = NSOverwriteMergePolicy
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }
}

extension NSManagedObjectContext {
    @objc func contextDidSaveContext(notification: Notification) {
        //        print("moc save")
        guard let sender = notification.object as? NSManagedObjectContext else {return}

        if sender === mainMOC {
            //            NSLog("******** Saved main Context in this thread")
            backgroundMOC?.perform {
                backgroundMOC?.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === backgroundMOC {
            //            NSLog("******** Saved background Context in this thread")
            mainMOC?.perform {
                mainMOC?.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            //            NSLog("******** Saved Context in other thread")
            mainMOC?.perform {
                mainMOC?.mergeChanges(fromContextDidSave: notification)
            }
            backgroundMOC?.perform {
                backgroundMOC?.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
}

extension SuperCoreDataStack {
    // MARK: - Core Data Saving support

    open func saveContext () {
        saveContext(self.managedObjectContext)
    }

    open func saveContext (_ context: NSManagedObjectContext?) {
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
