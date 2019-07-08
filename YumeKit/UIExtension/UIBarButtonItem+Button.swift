//
//  UIBarButtonItem+Button.swift
//  YumeKit
//
//  Created by 林煒峻 on 2019/7/8.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    convenience init(image: UIImage?, target: Any?, action: Selector?, size: CGSize, accessibilityIdentifier: String? = nil) {
        let btn: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        btn.setImage(image, for: .normal)
        
        btn.widthAnchor.constraint(equalToConstant: size.width).isActive = true
        btn.heightAnchor.constraint(equalToConstant: size.height).isActive = true
        if let action = action {
            btn.addTarget(target, action: action, for: .touchUpInside)
        }
        self.init(customView: btn)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

public extension UIBarButtonItem {
    typealias Generator = (_ target: Any?, _ action: Selector?) -> UIBarButtonItem
    static func generate(image: UIImage?, size: CGSize, accessibilityIdentifier: String? = nil) -> Generator {
        return { (target: Any?, action: Selector?) -> UIBarButtonItem in
            return UIBarButtonItem(
                image: image,
                target: target,
                action: action,
                size: size,
                accessibilityIdentifier: accessibilityIdentifier
            )
        }
    }
    
    static func carry(image: UIImage?, accessibilityIdentifier: String? = nil) -> Generator {
        return { (target: Any?, action: Selector?) -> UIBarButtonItem in
            let item: UIBarButtonItem = UIBarButtonItem(
                image: image,
                style: UIBarButtonItem.Style.plain,
                target: target,
                action: action
            )
            item.accessibilityIdentifier = accessibilityIdentifier
            return item
        }
    }
}
