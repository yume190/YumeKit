//
//  MultiSectionTableViewBox.swift
//  YumeKit
//
//  Created by Yume on 2019/3/19.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension Box.TableView {
    final public class SingleSection<Cell: UITableViewCell & Presentable>: NSObject, SingleSectionTableViewPresentable, UITableViewDataSource, UITableViewDelegate {
        public var extra: (() -> Cell.ExtraData)? = nil
        
        public var tableView: UITableView?

        public var cellType: Box.TableView.CellType

        public var items: [Cell.InnerData] = []

        public var select: SelectFunction?

        public init(tableView: UITableView?, cellType: Box.TableView.CellType) {
            self.tableView = tableView
            self.cellType = cellType

            super.init()

            self.tableView?.delegate = self
            self.tableView?.dataSource = self

            switch cellType {
            case .dynamic:
                tableView?.rowHeight = UITableView.automaticDimension
            case .static(let height):
                tableView?.rowHeight = height
            }
        }

        // MARK: UITableViewDataSource
        public func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }

        public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.items.count
        }

        public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath)
            switch self.cellType {
            case .dynamic:
                let _cell: Cell? = cell as? Cell
                let data: Cell.InnerData = self[indexPath]
                let extra: Cell.ExtraData? = self.extra?()
                _cell?.present(data: data, extra: extra, indexPath: indexPath)
            case .static:
                break
            }
            return cell
        }

        // MARK: UITableViewDelegate
        public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            switch self.cellType {
            case .dynamic:
                return
            case .static:
                guard let cell: Cell = cell as? Cell else { return }
                let data: Cell.InnerData = self[indexPath]
                let extra: Cell.ExtraData? = self.extra?()
                cell.present(data: data, extra: extra, indexPath: indexPath)
            }
        }

        public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let data: Cell.InnerData = self[indexPath]
            self.select?(tableView, indexPath, data)
        }
    }
}
