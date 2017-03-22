//
//  FetchedResultsControllerExtension.swift
//
//  SuperRecord - A small set of utilities to make working with CoreData a bit easier.
//  http://mike.kz/
//
//  Created by Michael Armstrong on 21/10/2014.
//  Copyright (c) 2014 SuperArmstrong.UK. All rights reserved.
//
//  RESPONSIBILITY : Setup a Fetched Results controller ready for use with the Delegate.

import CoreData
import UIKit

//public extension NSFetchedResultsController<Self> {
extension MOProtocol where Self:NSManagedObject {
    
    // MARK: Public Methods
    public static func superFetchedResultsController(_ entityName: String!, collectionView: UICollectionView!) -> NSFetchedResultsController<Self> {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(collectionView)
        let fetchedResultsController = superFetchedResultsController(entityName, reusableView: collectionView, delegate: fetchedResultsDelegate)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    public static func superFetchedResultsController(_ entityName: String!, tableView: UITableView!) -> NSFetchedResultsController<Self> {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(tableView)
        let fetchedResultsController =  superFetchedResultsController(entityName, reusableView: tableView, delegate: fetchedResultsDelegate)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortedBy: sortedBy, ascending: ascending, delegate: delegate)
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortedBy: sortedBy, ascending: ascending, delegate: delegate)
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate)
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate)
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, collectionView: UICollectionView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate, context: context)
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, tableView: UITableView!, delegate: NSFetchedResultsControllerDelegate, context: NSManagedObjectContext!) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: delegate,  context: context)
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, collectionView: UICollectionView!, context: NSManagedObjectContext!) -> NSFetchedResultsController<Self> {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(collectionView)
        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    public static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortDescriptors: [NSSortDescriptor]?, predicate: NSPredicate?, tableView: UITableView!, context: NSManagedObjectContext!) -> NSFetchedResultsController<Self> {
        let fetchedResultsDelegate = setupFetchedResultsControllerDelegate(tableView)
        let fetchedResultsController = superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate: predicate, delegate: fetchedResultsDelegate, context: context)
        fetchedResultsDelegate.bindsLifetimeTo(fetchedResultsController)
        return fetchedResultsController
    }
    
    
    // MARK: Private Methods
    
    fileprivate static func setupFetchedResultsControllerDelegate(_ tableView: UITableView!) -> SuperFetchedResultsControllerDelegate {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakTableView = tableView
        let reusableView: UITableView! = weakTableView
        fetchedResultsDelegate.tableView = reusableView
        return fetchedResultsDelegate
    }
    
    fileprivate static func setupFetchedResultsControllerDelegate(_ collectionView: UICollectionView!) -> SuperFetchedResultsControllerDelegate {
        let fetchedResultsDelegate = SuperFetchedResultsControllerDelegate()
        weak var weakCollectionView = collectionView
        let reusableView: UICollectionView! = weakCollectionView
        fetchedResultsDelegate.collectionView = reusableView
        return fetchedResultsDelegate
    }
    
    fileprivate static func superFetchedResultsController(_ entityName: String!, reusableView: UIScrollView!, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Self> {
        return superFetchedResultsController(entityName, sectionNameKeyPath: nil, sortDescriptors: nil, predicate: nil, delegate: delegate)
    }
    
    fileprivate static func superFetchedResultsController(_ entityName: String!, sectionNameKeyPath: String?, sortedBy: String?, ascending: Bool, delegate: NSFetchedResultsControllerDelegate) -> NSFetchedResultsController<Self> {
        
        var sortDescriptors:[NSSortDescriptor] = []
        if let sortedBy = sortedBy {
            sortDescriptors = [NSSortDescriptor(key: sortedBy, ascending: ascending)]
        }
        return superFetchedResultsController(entityName, sectionNameKeyPath: sectionNameKeyPath, sortDescriptors: sortDescriptors, predicate:nil, delegate: delegate)
    }
    
    fileprivate static func superFetchedResultsController(
        _ entityName: String!,
        sectionNameKeyPath: String?,
        sortDescriptors: [NSSortDescriptor]?,
        predicate: NSPredicate?, 
        delegate: NSFetchedResultsControllerDelegate,
        context: NSManagedObjectContext! = SuperCoreDataStack.defaultStack.managedObjectContext!)
        -> NSFetchedResultsController<Self> {
        
        let fetchRequest = NSFetchRequest<Self>(entityName: entityName)
        fetchRequest.entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        
        if let predicate = predicate {
            fetchRequest.predicate = predicate
        }
        if let sortDescriptors = sortDescriptors {
            fetchRequest.sortDescriptors = sortDescriptors
        } else {
            fetchRequest.sortDescriptors = []
        }
        
        var tempFetchedResultsController : NSFetchedResultsController<Self>!
        if let sectionNameKeyPath = sectionNameKeyPath {
            tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: sectionNameKeyPath, cacheName: nil)
        } else {
            tempFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest , managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        }
        tempFetchedResultsController.delegate = delegate
        
        NSFetchedResultsController<Self>.deleteCache(withName: nil)
        
        var error : NSError?
        do {
            try tempFetchedResultsController.performFetch()
        } catch let error1 as NSError {
            error = error1
        }
        
        if (error != nil){
            //TODO: This needs actual error handling.
            print("Error : \(error)")
        }
        
        return tempFetchedResultsController
    }
    
}
