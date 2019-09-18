//
//  TableViewPresentable.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

public protocol TableViewPresentable: class {
    associatedtype Cell: UITableViewCell & Presentable
    var tableView: UITableView? { get set }
    var cellType: Box.TableView.CellType { get }

    static func registerNibTo(tableView: UITableView?)
    static func registerClassTo(tableView: UITableView?)

    func registerNibTo(tableView: UITableView?)
    func registerClassTo(tableView: UITableView?)

    typealias SelectFunction = (UITableView, IndexPath, Cell.InnerData) -> Void
    var select: SelectFunction? { get set }

    init(tableView: UITableView?, cellType: Box.TableView.CellType)
}

extension TableViewPresentable {
    public static func registerNibTo(tableView: UITableView?) {
        Cell.registerNibTo(tableView: tableView)
    }

    public static func registerClassTo(tableView: UITableView?) {
        Cell.registerClassTo(tableView: tableView)
    }

    public func registerNibTo(tableView: UITableView?) {
        Self.registerNibTo(tableView: tableView)
    }

    public func registerClassTo(tableView: UITableView?) {
        Self.registerClassTo(tableView: tableView)
    }
}
