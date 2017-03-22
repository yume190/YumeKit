////
////  NSExpressionDescriptionExtension.swift
////  BusApp
////
////  Created by Yume on 2015/5/19.
////  Copyright (c) 2015年 Yume. All rights reserved.
////
//
//import Foundation
//import CoreData
//
//// Predefined functions are:
//// name              parameter array contents               returns
////-------------------------------------------------------------------------------------------------------------------------------------
//// sum:              NSExpression instances representing numbers        NSNumber
//// count:            NSExpression instances representing numbers        NSNumber
//// min:              NSExpression instances representing numbers        NSNumber
//// max:              NSExpression instances representing numbers        NSNumber
//// average:          NSExpression instances representing numbers        NSNumber
//// median:           NSExpression instances representing numbers        NSNumber
//// mode:             NSExpression instances representing numbers        NSArray     (returned array will contain all occurrences of the mode)
//// stddev:           NSExpression instances representing numbers        NSNumber
//// add:to:           NSExpression instances representing numbers        NSNumber
//// from:subtract:    two NSExpression instances representing numbers    NSNumber
//// multiply:by:      two NSExpression instances representing numbers    NSNumber
//// divide:by:        two NSExpression instances representing numbers    NSNumber
//// modulus:by:       two NSExpression instances representing numbers    NSNumber
//// sqrt:             one NSExpression instance representing numbers     NSNumber
//// log:              one NSExpression instance representing a number    NSNumber
//// ln:               one NSExpression instance representing a number    NSNumber
//// raise:toPower:    one NSExpression instance representing a number    NSNumber
//// exp:              one NSExpression instance representing a number    NSNumber
//// floor:            one NSExpression instance representing a number    NSNumber
//// ceiling:          one NSExpression instance representing a number    NSNumber
//// abs:              one NSExpression instance representing a number    NSNumber
//// trunc:            one NSExpression instance representing a number    NSNumber
//// uppercase:    one NSExpression instance representing a string    NSString
//// lowercase:    one NSExpression instance representing a string    NSString
//// random            none                           NSNumber (integer)
//// random:           one NSExpression instance representing a number    NSNumber (integer) such that 0 <= rand < param
//// now               none                           [NSDate now]
//// bitwiseAnd:with:  two NSExpression instances representing numbers    NSNumber    (numbers will be treated as NSInteger)
//// bitwiseOr:with:   two NSExpression instances representing numbers    NSNumber    (numbers will be treated as NSInteger)
//// bitwiseXor:with:  two NSExpression instances representing numbers    NSNumber    (numbers will be treated as NSInteger)
//// leftshift:by:     two NSExpression instances representing numbers    NSNumber    (numbers will be treated as NSInteger)
//// rightshift:by:    two NSExpression instances representing numbers    NSNumber    (numbers will be treated as NSInteger)
//// onesComplement:   one NSExpression instance representing a numbers   NSNumber    (numbers will be treated as NSInteger)
//// noindex:      an NSExpression                    parameter   (used by CoreData to indicate that an index should be dropped)
//// distanceToLocation:fromLocation:
////                   two NSExpression instances representing CLLocations    NSNumber
//
//extension NSExpressionDescription {
//    
//    class func sum(name:String,keyPath:String, type:NSAttributeType = NSAttributeType.doubleAttributeType) -> NSExpressionDescription {
//        let expression = NSExpression(format: "sum:(\(keyPath))")
//        return combine(name: name, expression: expression,type: type)
//    }
//    
//    class func count(name:String,keyPath:String, type:NSAttributeType = NSAttributeType.integer64AttributeType) -> NSExpressionDescription {
//        let expression = NSExpression(format: "count:(\(keyPath))")
//        return combine(name: name, expression: expression,type: type)
//    }
//    
//    class func min(name:String,keyPath:String, type:NSAttributeType = NSAttributeType.doubleAttributeType) -> NSExpressionDescription {
//        let expression = NSExpression(format: "min:(\(keyPath))")
//        return combine(name: name, expression: expression,type: type)
//    }
//    
//    class func max(name:String,keyPath:String, type:NSAttributeType = NSAttributeType.doubleAttributeType) -> NSExpressionDescription {
//        let expression = NSExpression(format: "max:(\(keyPath))")
//        return combine(name: name, expression: expression,type: type)
//    }
//    
//    class func average(name:String,keyPath:String, type:NSAttributeType = NSAttributeType.doubleAttributeType) -> NSExpressionDescription {
//        let expression = NSExpression(format: "average:(\(keyPath))")
//        return combine(name: name, expression: expression,type: type)
//    }
//    
//    fileprivate class func combine(name:String,expression:NSExpression,type:NSAttributeType) -> NSExpressionDescription {
//        let expressionDescription = NSExpressionDescription()
//        expressionDescription.name = name
//        expressionDescription.expression = expression
//        expressionDescription.expressionResultType = type
//        
//        return expressionDescription
//    }
//}
