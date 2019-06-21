//
//  NSPredicateExtension.swift
//  SuperRecord
//
//  Created by Piergiuseppe Longo on 26/11/14.
//  Copyright (c) 2014 Michael Armstrong. All rights reserved.
//

import Foundation

// MARK: Logical operators
/**
 Create a new NSPredicate as logical AND of left and right predicate
 
 - parameter left:
 - parameter right:
 
 - returns: NSPredicate
 */
public func & (left: NSPredicate, right: NSPredicate ) -> NSPredicate {
    return [left] & [right]
}

/**
 Create a new NSPredicate as logical AND of left and right predicates
 
 - parameter left:
 - parameter right: a collection NSPredicate
 
 - returns: NSPredicate
 */
public func & (left: NSPredicate, right: [NSPredicate] ) -> NSPredicate {
    return [left] & right
}

/**
 Create a new NSPredicate as logical AND of left and right predicates
 
 - parameter left: a collection NSPredicate
 - parameter right: a collection NSPredicate
 
 - returns: NSPredicate
 */
public func & (left: [NSPredicate], right: [NSPredicate] ) -> NSPredicate {
    return NSCompoundPredicate(andPredicateWithSubpredicates: left + right)
}

/**
 
 Create a new NSPredicate as logical OR of left and right predicate
 
 - parameter left:
 - parameter right:
 
 - returns: NSPredicate
 */

public func | (left: NSPredicate, right: NSPredicate ) -> NSPredicate {
    return [left] | [right]
}

/**
 
 Create a new NSPredicate as logical OR of left and right predicates
 
 - parameter left:
 - parameter right: a collection NSPredicate
 
 - returns: NSPredicate
 */

public func | (left: NSPredicate, right: [NSPredicate] ) -> NSPredicate {
    return [left] | right
}

/**
 
 Create a new NSPredicate as logical OR of left and right predicates
 
 - parameter left: a collection NSPredicate
 - parameter right: a collection NSPredicate
 
 - returns: NSPredicate
 */
public func | (left: [NSPredicate], right: [NSPredicate] ) -> NSPredicate {
    return NSCompoundPredicate(orPredicateWithSubpredicates: left + right)
}

/**
 Used to specify the the logical operator to use in the init of a complex NSPredicate
 */
public enum NSLogicOperator: String {
    /**
     And Operator
     */
    case And = "AND"

    /**
     OR Operator
     */
    case Or = "OR"
}

/**
 Used to specify the the  operator to use in NSPredicate.predicateBuilder
 */
public enum NSPredicateOperator: String {
    /**
     Operator &&
     */
    case and = "AND"

    /**
     Operator ||
     */
    case or = "OR"

    /**
     Operator IN
     */
    case `in` = "IN"

    /**
     Operator ==
     */
    case equal = "=="

    /**
     Operator !=
     */
    case notEqual = "!="

    /**
     Operator >
     */
    case greaterThan = ">"

    /**
     Operator >=
     */
    case greaterThanOrEqual = ">="

    /**
     Operator <
     */
    case lessThan = "<"

    /**
     Operator <=
     */
    case lessThanOrEqual = "<="
}

/**
 
 Build NSPredicate using the input parameters
 
 - parameter attribute: the name of the attribute
 - parameter value: the value the attribute should assume
 - parameter predicateOperator: to use in the predicate
 
 - returns: NSPredicate
 */
public func predicateBuilder(_ attribute: String!, value: Any?, predicateOperator: NSPredicateOperator) -> NSPredicate? {
    guard let value = value else { return nil }
    var predicate = NSPredicate(format: "%K \(predicateOperator.rawValue) $value", attribute)
    predicate = predicate.withSubstitutionVariables(["value": value])
    return predicate
}

public extension NSPredicate {

    /**
     Init a new NSPredicate using the input predicates adding parenthesis for more complex NSPredicate
     
     - parameter firstPredicate:
     - parameter secondPredicate:
     - parameter NSLogicOperator: to use in the predicate AND/OR
     
     - returns: NSPredicate
     */
    // swiftlint:disable:next
    convenience init?(firstPredicate: NSPredicate, secondPredicate: NSPredicate, predicateOperator: NSLogicOperator ) {
        self.init(format: "(\(firstPredicate)) \(predicateOperator.rawValue) (\(secondPredicate))")
    }

}
