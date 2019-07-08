//
//  UIColor+Ex.swift
//  MaxwinBus
//
//  Created by Yume on 2019/3/12.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

@inline(__always)
fileprivate func shiftting(color: Int, mask: Int, shift: Int) -> CGFloat {
    let masked: Int = color & mask
    let origin: Int = masked >> shift
    let _origin: CGFloat = CGFloat(origin)
    return _origin/255.0
}

public extension UIColor {
    convenience public init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(
            red: shiftting(color: rgb, mask: 0xFF0000, shift: 16),
            green: shiftting(color: rgb, mask: 0x00FF00, shift: 8),
            blue: shiftting(color: rgb, mask: 0x0000FF, shift: 0),
            alpha: alpha
        )
    }
}
