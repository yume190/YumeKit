////
////  TableViewPresentable.swift
////  CustomGenericViewFromXib
////
////  Created by Yume on 2018/12/26.
////  Copyright © 2018 Yume. All rights reserved.
////
//
//import UIKit
//
//public protocol MultiSectionTableViewPresentable: TableViewPresentable {
//    var items: [[Cell.InnerData]] { get set }
//
//    subscript(indexPath: IndexPath) -> Cell.InnerData { get }
//}
//
//extension MultiSectionTableViewPresentable {
//    public subscript(indexPath: IndexPath) -> Cell.InnerData {
//        return self.items[indexPath.section][indexPath.row]
//    }
//}
