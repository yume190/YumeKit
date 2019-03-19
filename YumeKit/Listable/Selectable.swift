//
//  Selectable.swift
//  MaxwinBus
//
//  Created by Yume on 2019/3/6.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol Selectable: class {
    func select(indexPath: IndexPath, state: Bool)
}
