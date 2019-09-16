//
//  NSManagedObjectExtension.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 12/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Several helpers for NSManagedObject to make common operations simpler.

import CoreData

public protocol MOProtocol: class {}
extension NSManagedObject: MOProtocol {}

extension MOProtocol where Self: NSManagedObject {
    public func otherContextMO(moc: NSManagedObjectContext?) -> Self? {
        do {
            return try moc?.existingObject(with: self.objectID) as? Self
        } catch {
            return nil
        }
    }
}

extension MOProtocol where Self: NSManagedObject {
    public func delete() {
        self.managedObjectContext?.delete(self)
    }
}

// MARK: Custom
extension MOProtocol where Self: NSManagedObject {
    public static func custom(
        _ predicate: NSPredicate!,
        context: NSManagedObjectContext = mainMOC!,
        fetchRequestConfig: ((NSFetchRequest<NSDictionary>) -> Void)? = nil) -> [NSDictionary] {

        let fetchRequest: NSFetchRequest<NSDictionary> = NSFetchRequest<NSDictionary>(entityName: entityName())
        fetchRequest.predicate = predicate
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequestConfig?(fetchRequest)

        return commonFetch(context: context, fetchRequest: fetchRequest)
    }
}

// MARK: Entity
extension MOProtocol where Self: NSManagedObject {
    public static func entityName() -> String {
        return String(describing: self)
    }

    public static func createNewEntity(_ context: NSManagedObjectContext = mainMOC!) -> Self {
        let entityDescription: NSEntityDescription? = NSEntityDescription.entity(forEntityName: entityName(), in: context)
        let obj: Self = Self(entity: entityDescription!, insertInto: context)
        return obj
    }
}

// MARK: Find
extension MOProtocol where Self: NSManagedObject {

    // MARK: Find All
    public static func findAllWithPredicate(
        _ predicate: NSPredicate!,
        includesPropertyValues: Bool = true,
        context: NSManagedObjectContext = mainMOC!,
        fetchRequestConfig: ((NSFetchRequest<Self>) -> Void)? = nil) -> [Self] {

        let fetchRequest: NSFetchRequest<Self> = commonFetchRequest(predicate: predicate, context: context) { fetchRequest in
            fetchRequest.includesPropertyValues = includesPropertyValues
            fetchRequestConfig?(fetchRequest)
        }

        return commonFetch(context: context, fetchRequest: fetchRequest)
    }

    public static func findAll(_ context: NSManagedObjectContext = mainMOC!) -> [Self] {
        return findAllWithPredicate(nil, context: context)
    }

    // swiftlint:disable:next
    public static func findAllWithAttribute(_ attribute: String!, value: Any, context: NSManagedObjectContext) -> [Self] {
        let predicate: NSPredicate? = predicateBuilder(attribute, value: value, predicateOperator: .equal)
        return findAllWithPredicate(predicate, context: context)
    }

    // MARK: Find One
    public static func findFirst(_ predicate: NSPredicate!, context: NSManagedObjectContext = mainMOC!) -> Self? {
        let fetchRequest: NSFetchRequest<Self> = commonFetchRequest(predicate: predicate, context: context) { fetchRequest in
            fetchRequest.fetchLimit = 1
        }

        return commonFetch(context: context, fetchRequest: fetchRequest).first
    }

    // swiftlint:disable:next
    public static func findFirstOrCreateWithPredicate(_ predicate: NSPredicate!, context: NSManagedObjectContext = mainMOC!) -> Self {
        if let first = findFirst(predicate, context: context) {
            return first
        }

        return createNewEntity(context)
    }

    // swiftlint:disable:next
    public static func findFirstOrCreateWithAttribute(_ attribute: String!, value: Any!, context: NSManagedObjectContext = mainMOC!) -> Self {
        let predicate: NSPredicate? = predicateBuilder(attribute, value: value, predicateOperator: .equal)
        return findFirstOrCreateWithPredicate(predicate, context: context)
    }
}

// MARK: Delete
extension MOProtocol where Self: NSManagedObject {
    public static func deleteAll(_ context: NSManagedObjectContext = mainMOC!) {
        deleteAll(nil, context: context)
    }

    public static func deleteAll(_ predicate: NSPredicate!, context: NSManagedObjectContext = mainMOC!) {
        let results: [Self] = findAllWithPredicate(predicate, includesPropertyValues: false, context: context)
        for result in results {
            context.delete(result)
        }
    }
}

// MARK: 通用
extension MOProtocol where Self: NSManagedObject {
    fileprivate static func commonFetch<T>(context: NSManagedObjectContext, fetchRequest: NSFetchRequest<T>) -> [T] {
        var results: [T] = []

        context.performAndWait { () -> Void in
            do {
                results = try context.fetch(fetchRequest)
            } catch {
                print(error)
            }
        }

        return results
    }

    fileprivate static func commonFetchRequest(
        predicate: NSPredicate?,
        context: NSManagedObjectContext,
        customSetting: ((NSFetchRequest<Self>) -> Void)? = nil) -> NSFetchRequest<Self> {
        let fetchRequest: NSFetchRequest<Self> = NSFetchRequest<Self>(entityName: entityName())
        fetchRequest.predicate = predicate
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName(), in: context)
        customSetting?(fetchRequest)
        return fetchRequest
    }

    // 打算作成 generator 式，可 next
    //    // MARK: Yume Make
    // swiftlint:disable:next
    //    public static func batchFetch(_ limit:Int = 0,offset:Int = 0,predicate: NSPredicate!,sorter:[NSSortDescriptor]!,context: NSManagedObjectContext) -> [Self] {
    //
    //        let entityDescription = NSEntityDescription.entity(forEntityName: entityName(), in: context)
    //        let fetchRequest = commonFetchRequest(predicate: predicate) { fetchRequest in
    //            fetchRequest.sortDescriptors = sorter
    //            fetchRequest.entity = entityDescription
    //            fetchRequest.fetchLimit = limit
    //            fetchRequest.fetchOffset = offset
    //        }
    //
    //        var results:[Self] = []
    //        context.performAndWait { () -> Void in
    //            do {
    //                results = try context.fetch(fetchRequest)
    //            } catch {
    //                print(error)
    //            }
    //        }
    //        return results
    //    }

    // swiftlint:disable:next
    public static func count(_ context: NSManagedObjectContext = mainMOC!, predicate: NSPredicate? = nil) -> Int {
        let fetchRequest: NSFetchRequest<Self> = commonFetchRequest(predicate: predicate, context: context) { fetchRequest in
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false
            fetchRequest.propertiesToFetch = []
        }

        // swiftlint:disable:next
        return (try? context.count(for: fetchRequest)) ?? 0
    }
}

//public extension NSManagedObject {
//
//
//
//
//
//    /**
//    Create a new Entity
//
//    - parameter context: NSManagedObjectContext
//
//    - returns: NSManagedObject.
//    */
//
//
//
//    /**
//    Search for the entity with the specify value or create a new Entity
//
//    - parameter attribute: name of the attribute to find
//
//    - parameter value: of the attribute to find
//
// swiftlint:disable:next
//    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
//
//    - returns: NSManagedObject.
//    */
//
//
//
// MARK: Entity operations
//
//    /**
//    Count all the entity
//
// swiftlint:disable:next
//    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
//
//    - parameter error:
//
//    - returns: Int of total result set count.
//    */
// swiftlint:disable:next
//    class func count(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, error: NSErrorPointer) -> Int {
//        return count(context, predicate: nil, error: error);
//    }
//
//    /**
//    Count all the entity matching the input predicate
//
// swiftlint:disable:next
//    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
//
//    - parameter predicate:
//
//    - parameter error:
//
//    - returns: Int of total result set count.
//    */
// swiftlint:disable:next
//    class func count(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, predicate : NSPredicate?, error: NSErrorPointer) -> Int {
//            let fetchRequest = NSFetchRequest(entityName: entityName());
//            fetchRequest.includesPropertyValues = false
//            fetchRequest.includesSubentities = false
//            fetchRequest.predicate = predicate
//            fetchRequest.propertiesToFetch = [];
//            return context.count(for: fetchRequest, error: error)
//    }
//
// swiftlint:disable:next
//    class func function(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, function: String, fieldName: [String], predicate : NSPredicate?, handler: ((NSError?) -> Void)! = nil) -> [Double] {
//
//        var expressionsDescription = [NSExpressionDescription]();
//        for field in fieldName{
//            let expression = NSExpression(forKeyPath: field);
//            let expressionDescription = NSExpressionDescription();
//            expressionDescription.expression = NSExpression(forFunction: function, arguments: [expression])
//            expressionDescription.expressionResultType = NSAttributeType.doubleAttributeType;
//            expressionDescription.name = field
//            expressionsDescription.append(expressionDescription);
//        }
//
//        let fetchRequest = NSFetchRequest(entityName: entityName());
//        fetchRequest.propertiesToFetch = expressionsDescription
//        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
//        fetchRequest.predicate = predicate
//        var results = [AnyObject]();
//        var resultValue = [Double]();
//        context.performAndWait { () -> Void in
//            do {
//                results = (try context.fetch(fetchRequest)) as! [NSDictionary]
//            } catch {
//            }
//
//            var tempResult = [Double]()
//            for result in results{
//                for field in fieldName{
//                    let value = result.value(forKey: field) as! Double
//                    tempResult.append(value)
//                }
//            }
//            resultValue = tempResult
//        }
//        return resultValue;
//    }
//
//    class func sum(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> [Double] {
//        return function(context, function: "sum:", fieldName: fieldName, predicate: predicate, handler: handler);
//    }
//
//    class func sum(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> Double! {
//        var results = sum(context, fieldName: [fieldName], predicate: predicate, handler: handler)
//        return results.isEmpty ? 0 : results[0];
//    }
//
//    class func max(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> [Double] {
//        return function(context, function: "max:", fieldName: fieldName, predicate: predicate, handler: handler);
//    }
//
//    class func max(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> Double! {
//        var results = max(context, fieldName: [fieldName], predicate: predicate, handler: handler)
//        return results.isEmpty ? 0 : results[0];
//    }
//
//    class func min(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> [Double] {
//        return function(context, function: "min:", fieldName: fieldName, predicate: predicate, handler: handler);
//    }
//
//    class func min(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> Double! {
//        var results = min(context, fieldName: [fieldName], predicate: predicate, handler: handler)
//        return results.isEmpty ? 0 : results[0];
//    }
//
//    class func avg(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: [String], predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)! = nil) -> [Double] {
//        return function(context, function: "average:", fieldName: fieldName, predicate: predicate, handler: handler);
//    }
//
// swiftlint:disable:next
//    class func avg(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)!  = nil) -> Double! {
//        var results = avg(context, fieldName: [fieldName], predicate: predicate, handler: handler)
//        return results.isEmpty ? 0 : results[0];
//    }
//}
