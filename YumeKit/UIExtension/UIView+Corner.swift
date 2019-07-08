//
//  UIView+Corner.swift
//  MaxwinBus
//
//  Created by Yume on 2019/3/27.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

extension UIView {
    public final func cornerPart(roundedCorners: UIRectCorner, radius: CGFloat? = nil) {
        let corners: UIRectCorner = roundedCorners
        let _radius: CGFloat = radius ?? self.bounds.size.height/CGFloat(2.0)
        let maskPath: UIBezierPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: _radius, height: 0.0)
        )
        let maskLayer: CAShapeLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
    
    public final func corner(radius: CGFloat? = nil) {
        let radius: CGFloat = radius ?? self.bounds.size.height/CGFloat(2.0)
        self.layer.masksToBounds = true
        self.layer.cornerRadius = CGFloat(radius)
    }
}
