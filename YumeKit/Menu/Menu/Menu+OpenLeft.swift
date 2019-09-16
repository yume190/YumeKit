//
//  DrawerKit.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/29.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension UIViewController {
    func setup(menuButton: UIBarButtonItem) {
        self.navigationItem.setLeftBarButton(menuButton, animated: true)
    }
}

extension UIViewController {
    @objc func pressMenu(_ sender: Any) {
        UIApplication.shared.sendAction(#selector(resignFirstResponder), to: nil, from: nil, for: nil)
        UIViewController.drawer?.open(way: .left)
    }
}
