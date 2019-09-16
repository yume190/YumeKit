//
//  Menu+VC.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension UIViewController {
    static var drawer: Drawer.Instance? {
        return UIApplication.shared.keyWindow?.rootViewController as? Drawer.Instance
    }
    
    static var menu: Menu.Instance? {
        return self.drawer?.menu
    }
}

extension Menu {
    open class ViewController: UIViewController, MenuSelectable {
        
        @IBOutlet private weak var tableview: UITableView?
        
        public weak var drawer: Drawer.Instance?
        
        public init(nibName: String, bundle: Bundle? = Bundle.main, drawer: Drawer.Instance? = nil, list: MenuListable.Type? = nil) {
            super.init(nibName: nibName, bundle: bundle)
            self.drawer = drawer
            self.list = list ?? DummyMenuList.self
        }
        
        required public init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private lazy var resource: Menu.Resource = Menu.Resource(menu: self)
        public private(set) var list: MenuListable.Type {
            set {
                self.resource.list = newValue
                for Cell in self.resource.list.default {
                    Cell.cellType.registerNibTo(tableView: self.tableview)
                }
                self.tableview?.reloadData()
            }
            get {
                return self.resource.list
            }
        }
        
        override open func viewDidLoad() {
            super.viewDidLoad()
            tableview?.dataSource = resource
            tableview?.delegate = resource
        }
        
        public func change(item: Menu.Item) {
            if case .function(let function) = item.type() {
                function(self)
                return
            }
            
            let vc: UIViewController? = item.type().viewController
            vc?.title = item.title
            self.changeCenterViewController(vc)
            if let drawer = drawer, drawer.isOpen {
                drawer.close(way: .left)
            } else {
                
            }
        }
        
        private func changeCenterViewController(_ showVC: UIViewController?) {
            if let _showVC = showVC {
                weak var nav = drawer?.center as? UINavigationController
                //            weak var vc = nav?.topViewController
                if _showVC != drawer?.center {
                    nav?.setViewControllers([], animated: false)
                }
                drawer?.center = _showVC
            }
        }
    }
}
