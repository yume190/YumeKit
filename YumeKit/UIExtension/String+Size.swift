//
//  String+Ex.swift
//  MaxwinBus
//
//  Created by Yume on 2019/3/26.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension String {
    public func size(width: CGFloat? = nil, font: UIFont? = nil) -> CGSize? {
        let max: CGSize = CGSize(
            width: width ?? UIScreen.main.bounds.size.width,
            height: 1000
        )
        let option: [NSAttributedString.Key: UIFont] = [
            NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: 17.0)
        ]
        return (self as NSString).boundingRect(with: max, options: .usesLineFragmentOrigin, attributes: option, context: nil).size
    }
}

extension UILabel {
    public func size() -> CGSize? {
        let max: CGSize = CGSize(
            width: self.frame.width,
            height: 1000
        )
        let option: [NSAttributedString.Key: UIFont] = [
            NSAttributedString.Key.font: self.font ?? UIFont.systemFont(ofSize: 17.0)
        ]
        
        return ((self.text ?? "") as NSString).boundingRect(
            with: max,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: option,
            context: nil
            ).size
    }
}
