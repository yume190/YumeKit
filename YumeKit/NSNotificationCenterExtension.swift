////
////  NSNotificationCenterExtension.swift
////  BusApp
////
////  Created by Maxwin on 2015/8/12.
////  Copyright (c) 2015年 Yume. All rights reserved.
////
//
//import Foundation
//
//// MARK: BACKGROUND_SAVE
//extension NotificationCenter {
//    
//    fileprivate var BACKGROUND_SAVE:String { return "BACKGROUND_SAVE" }
//    
//    func addObserveBackgroundSave(_ observer: AnyObject, selector: Selector) {
//        self.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: BACKGROUND_SAVE), object: nil)
//    }
//    
//    func removeObserveBackgroundSave(_ observer: AnyObject) {
//        self.removeObserver(observer, name: NSNotification.Name(rawValue: BACKGROUND_SAVE), object: nil)
//    }
//    
//    func postBackgroundSave() {
//        self.post(name: Foundation.Notification.Name(rawValue: BACKGROUND_SAVE), object: nil)
//    }
//    
//}
//
//// MARK: Local Notification Trigger
//extension NotificationCenter {
//    
//    fileprivate var LOCAL_NOTIFICATION_TRIGGER:String { return "LOCAL_NOTIFICATION_TRIGGER" }
//    
//    func addObserveLoalNotificationTrigger(_ observer: AnyObject, selector: Selector) {
//        self.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: LOCAL_NOTIFICATION_TRIGGER), object: nil)
//    }
//    
//    func removeObserveLoalNotificationTrigger(_ observer: AnyObject) {
//        self.removeObserver(observer, name: NSNotification.Name(rawValue: LOCAL_NOTIFICATION_TRIGGER), object: nil)
//    }
//    
//    func postLoalNotificationTrigger() {
//        self.post(name: Foundation.Notification.Name(rawValue: LOCAL_NOTIFICATION_TRIGGER), object: nil)
//    }
//    
//}
