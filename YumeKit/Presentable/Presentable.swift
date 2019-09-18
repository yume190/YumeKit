//
//  CellPresentable.swift
//  CustomGenericViewFromXib
//
//  Created by Yume on 2018/12/26.
//  Copyright © 2018 Yume. All rights reserved.
//

import UIKit

public protocol Presentable: class {
    associatedtype InnerData
    associatedtype ExtraData

    func present(data: InnerData, extra: ExtraData?, indexPath: IndexPath)
}
