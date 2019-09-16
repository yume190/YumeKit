//
//  SuperStack+default.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/30.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation
import CoreData

extension SuperCoreDataStack {
    struct Default {
        static let bigUpdatePrefix: String = "_"
        static let defaultStackName: String = {
            let bundleName: String? = Bundle.main.infoDictionary?["CFBundleName"] as? String
            return bundleName ?? "YumeKit"
        }()
        static let stackOption = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
    }
}
