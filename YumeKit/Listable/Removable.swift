//
//  Removable.swift
//  MaxwinBus
//
//  Created by Yume on 2019/3/8.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol Removable: class {
    func remove(indexPath: IndexPath)
}
