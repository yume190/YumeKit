//
//  TableViewPresentable.swift
//  CustomGenericViewFromXib
//
//  Created by Yume on 2018/12/26.
//  Copyright © 2018 Yume. All rights reserved.
//

import UIKit

public protocol SingleSectionTableViewPresentable: TableViewPresentable {
    var items: [Cell.InnerData] { get set }
    var extra: (() -> Cell.ExtraData)? { get }

    subscript(indexPath: IndexPath) -> Cell.InnerData { get }
}

extension SingleSectionTableViewPresentable {
    public subscript(indexPath: IndexPath) -> Cell.InnerData {
        return self.items[indexPath.row]
    }
}
