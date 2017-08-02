//
//  NSManagedObject+Delete.swift
//  YumeKit
//
//  Created by Yume on 2017/8/2.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation
import CoreData

extension NSManagedObject {
    func delete() {
        self.managedObjectContext?.delete(self)
    }
}
