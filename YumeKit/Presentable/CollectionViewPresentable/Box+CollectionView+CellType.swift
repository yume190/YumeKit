//
//  CollectionViewCellType.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Box.CollectionView {
    public enum CellType {
        case `static`(size: CGSize)
        case `dynamic`(count: Int, height: CGFloat)
    }
}
