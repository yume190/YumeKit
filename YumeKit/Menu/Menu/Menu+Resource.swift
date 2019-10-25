//
//  Menu+Resource.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/9/16.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension Menu {
    internal final class Resource: NSObject {
        internal var list: MenuListable.Type = DummyMenuList.self
        private weak var menu: Menu.Instance?
        init(menu: Menu.Instance) {
            self.menu = menu
        }
    }
}

extension Menu.Resource: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.default.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell: UITableViewCell.Type = self.list.default[indexPath.row].cellType
        return tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellData: Menu.Item = self.list.default[indexPath.row]
        if cellData.cellType.self == UITableViewCell.self {
            cell.textLabel?.text = cellData.title
            cell.imageView?.image = cellData.icon
        }
    }
}

extension Menu.Resource: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedItem: Menu.Item = list.default[indexPath.row]
        self.menu?.change(item: selectedItem)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
}
