//
//  MultiSectionTableViewBox.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension TableViewBox {
    final public class SingleSection<Cell: UITableViewCell & Presentable>: SingleSectionTableViewPresentable {
        public lazy var dataSource: UITableViewDataSource = DataSource(presentable: self)

        public lazy var delegate: UITableViewDelegate = Delegate(presentable: self)

        public var tableView: UITableView?

        public var cellType: CellType

        public var items: [Cell.InnerData] = []

        public var select: SelectFunction?

        public init(tableView: UITableView?, cellType: CellType) {
            self.tableView = tableView
            self.cellType = cellType

            self.tableView?.delegate = self.delegate
            self.tableView?.dataSource = self.dataSource

            switch cellType {
            case .dynamic:
                tableView?.rowHeight = UITableView.automaticDimension
            case .static(let height):
                tableView?.rowHeight = height
            }
        }
    }
}

extension TableViewBox.SingleSection {
    private final class DataSource<Presentable: SingleSectionTableViewPresentable>: NSObject, UITableViewDataSource {

        var presentable: Presentable
        init(presentable: Presentable) {
            self.presentable = presentable
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.presentable.items.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: Presentable.Cell.identifier, for: indexPath)
            switch self.presentable.cellType {
            case .dynamic:
                let _cell = cell as? Presentable.Cell
                let data = self.presentable[indexPath]
                _cell?.present(data: data)
            case .static:
                break
            }
            return cell
        }
    }
}

extension TableViewBox.SingleSection {
    private final class Delegate<Presentable: SingleSectionTableViewPresentable>: NSObject, UITableViewDelegate {

        var presentable: Presentable
        init(presentable: Presentable) {
            self.presentable = presentable
        }

        func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            switch self.presentable.cellType {
            case .dynamic:
                return
            case .static:
                guard let cell = cell as? Presentable.Cell else { return }
                let data = self.presentable[indexPath]
                cell.present(data: data)
            }
        }

        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let data = self.presentable[indexPath]
            self.presentable.select?(tableView, indexPath, data)
        }
    }
}
