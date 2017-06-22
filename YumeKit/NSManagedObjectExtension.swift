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

public protocol MOProtocol:class {}
extension NSManagedObject:MOProtocol {}

// MARK: Custom
extension MOProtocol where Self:NSManagedObject {
    public final static func custom(
        _ predicate: NSPredicate!,
        context: NSManagedObjectContext = mainMOC!,
        fetchRequestConfig:((NSFetchRequest<NSDictionary>) -> ())? = nil) -> [NSDictionary] {
        
        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: entityName())
        fetchRequest.predicate = predicate
        fetchRequest.resultType = NSFetchRequestResultType.dictionaryResultType
        fetchRequestConfig?(fetchRequest)
        
        return commonFetch(context: context, fetchRequest: fetchRequest)
    }
}

// MARK: Entity
extension MOProtocol where Self:NSManagedObject {
    public final static func entityName() -> String {
        return String(describing: self)
    }
    
    public final static func createNewEntity(_ context: NSManagedObjectContext = mainMOC!) -> Self {
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName(), in: context)
        let obj = Self(entity: entityDescription!, insertInto: context)
        return obj
    }
}

// MARK: Find
extension MOProtocol where Self:NSManagedObject {
    
    // MARK: Find All
    public final static func findAllWithPredicate(
        _ predicate: NSPredicate!,
        includesPropertyValues: Bool = true,
        context: NSManagedObjectContext = mainMOC!,
        fetchRequestConfig:((NSFetchRequest<Self>) -> ())? = nil) -> [Self] {
        
        let fetchRequest = commonFetchRequest(predicate: predicate, context: context) { fetchRequest in
            fetchRequest.includesPropertyValues = includesPropertyValues
            fetchRequestConfig?(fetchRequest)
        }
        
        return commonFetch(context: context, fetchRequest: fetchRequest)
    }
    
    public final static func findAll(_ context: NSManagedObjectContext = mainMOC!) -> [Self] {
        return findAllWithPredicate(nil, context: context)
    }
    
    public final static func findAllWithAttribute(_ attribute: String!, value: Any, context: NSManagedObjectContext) -> [Self] {
        let predicate = predicateBuilder(attribute, value: value, predicateOperator: .Equal)
        return findAllWithPredicate(predicate, context: context)
    }
    
    // MARK: Find One
    public final static func findFirst(_ predicate: NSPredicate!, context: NSManagedObjectContext = mainMOC!) -> Self? {
        let fetchRequest = commonFetchRequest(predicate: predicate, context: context) { fetchRequest in
            fetchRequest.fetchLimit = 1
        }
        
        return commonFetch(context: context, fetchRequest: fetchRequest).first
    }
    
    public final static func findFirstOrCreateWithPredicate(_ predicate: NSPredicate!, context: NSManagedObjectContext = mainMOC!) -> Self {
        if let first = findFirst(predicate, context: context) {
            return first
        }
        
        return createNewEntity(context)
    }
    
    public final static func findFirstOrCreateWithAttribute(_ attribute: String!, value: Any!, context: NSManagedObjectContext = mainMOC!) -> Self {
        let predicate = predicateBuilder(attribute, value: value, predicateOperator: .Equal)
        return findFirstOrCreateWithPredicate(predicate, context: context)
    }
}

// MARK: Delete
extension MOProtocol where Self:NSManagedObject {
    public final static func deleteAll(_ context: NSManagedObjectContext = mainMOC!) -> Void {
        deleteAll(nil, context: context)
    }
    
    public final static func deleteAll(_ predicate: NSPredicate!, context: NSManagedObjectContext = mainMOC!) -> Void {
        let results = findAllWithPredicate(predicate, includesPropertyValues: false, context: context)
        for result in results {
            context.delete(result)
        }
    }
}

// MARK: 通用
extension MOProtocol where Self:NSManagedObject {
    fileprivate final static func commonFetch<T:NSFetchRequestResult>(context: NSManagedObjectContext,fetchRequest:NSFetchRequest<T>) -> [T] {
        var results:[T] = []
        
        context.performAndWait { () -> Void in
            do {
                results = try context.fetch(fetchRequest)
            } catch {
                print(error)
            }
        }
        
        return results
    }
    
    fileprivate final static func commonFetchRequest(
        predicate:NSPredicate?,
        context: NSManagedObjectContext,
        customSetting:((NSFetchRequest<Self>) -> ())? = nil) -> NSFetchRequest<Self> {
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName())
        fetchRequest.predicate = predicate
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName(), in: context)
        customSetting?(fetchRequest)
        return fetchRequest
    }

    // 打算作成 generator 式，可 next
//    // MARK: Yume Make
//    public final static func batchFetch(_ limit:Int = 0,offset:Int = 0,predicate: NSPredicate!,sorter:[NSSortDescriptor]!,context: NSManagedObjectContext) -> [Self] {
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
    
    public final static func count(_ context: NSManagedObjectContext = mainMOC!, predicate : NSPredicate? = nil) throws -> Int {
        let fetchRequest = commonFetchRequest(predicate: predicate, context: context) { fetchRequest in
            fetchRequest.includesPropertyValues = false
            fetchRequest.includesSubentities = false
            fetchRequest.propertiesToFetch = []
        }
        
        return try! context.count(for: fetchRequest)
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
//    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
//    
//    - returns: NSManagedObject.
//    */
//    
//
//
//    //MARK: Entity operations
//    
//    /**
//    Count all the entity
//    
//    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
//    
//    - parameter error:
//    
//    - returns: Int of total result set count.
//    */
//    class func count(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, error: NSErrorPointer) -> Int {
//        return count(context, predicate: nil, error: error);
//    }
//    
//    /**
//    Count all the entity matching the input predicate
//    
//    - parameter context: the NSManagedObjectContext. Default value is SuperCoreDataStack.defaultStack.managedObjectContext
//    
//    - parameter predicate:
//    
//    - parameter error:
//    
//    - returns: Int of total result set count.
//    */
//    class func count(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, predicate : NSPredicate?, error: NSErrorPointer) -> Int {
//            let fetchRequest = NSFetchRequest(entityName: entityName());
//            fetchRequest.includesPropertyValues = false
//            fetchRequest.includesSubentities = false
//            fetchRequest.predicate = predicate
//            fetchRequest.propertiesToFetch = [];
//            return context.count(for: fetchRequest, error: error)
//    }
//    
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
//    class func avg(_ context: NSManagedObjectContext = SuperCoreDataStack.defaultStack.managedObjectContext!, fieldName: String, predicate : NSPredicate? = nil, handler: ((NSError?) -> Void)!  = nil) -> Double! {
//        var results = avg(context, fieldName: [fieldName], predicate: predicate, handler: handler)
//        return results.isEmpty ? 0 : results[0];
//    }
//}
