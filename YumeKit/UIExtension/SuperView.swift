//
//  SuperView.swift
//  MaxwinBus
//
//  Created by Yume on 2019/4/9.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

// https://stackoverflow.com/questions/15711645/how-to-get-uitableview-from-uitableviewcell
public extension UIView {
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view: UIView = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
}

//extension UITableViewCell {
//    var tableView: UITableView? {
//        return self.parentView(of: UITableView.self)
//    }
//}
