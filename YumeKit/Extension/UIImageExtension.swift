//
//  UIImageExtension.swift
//  BusApp
//
//  Created by Yume on 2017/1/12.
//  Copyright © 2017年 Yume. All rights reserved.
//

import UIKit

extension UIImage {
    public func tint(color: UIColor) -> UIImage {
        let image: UIImage = self
        UIGraphicsBeginImageContextWithOptions(image.size, false, UIScreen.main.scale)
        let context: CGContext? = UIGraphicsGetCurrentContext()

        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)

        let rect: CGRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)

        // draw alpha-mask
        context?.setBlendMode(.normal)
        context?.draw(image.cgImage!, in: rect)

        // draw tint color, preserving alpha values of original image
        context?.setBlendMode(.sourceIn)
        color.setFill()
        context?.fill(rect)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImage!
    }
}
