//
//  SingleSectionCollectionViewPresentable.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol SingleSectionCollectionViewPresentable: CollectionViewPresentable {
    var items: [Cell.InnerData] { get set }
    var extra: (() -> Cell.ExtraData)? { get }

    subscript(indexPath: IndexPath) -> Cell.InnerData { get }
}

extension SingleSectionCollectionViewPresentable {
    public subscript(indexPath: IndexPath) -> Cell.InnerData {
        return self.items[indexPath.row]
    }
}
