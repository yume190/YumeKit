//
//  Menu+Item.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension Menu {
    public struct Item {
        public let type: () -> Menu.Types
        public let title: String
        public let icon: UIImage?
        public let cellType: UITableViewCell.Type
        
        public init(type: @escaping () -> Menu.Types, title: String, icon: UIImage?, cellType: UITableViewCell.Type) {
            self.type = type
            self.title = title
            self.icon = icon
            self.cellType = cellType
        }
    }
}
