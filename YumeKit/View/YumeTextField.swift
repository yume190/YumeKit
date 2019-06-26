//
//  YumeTextField.swift
//  MaxwinBus
//
//  Created by Yume on 2019/3/6.
//  Copyright © 2019 Yume. All rights reserved.
//

import UIKit

@IBDesignable
public class YumeTextField: UITextField {
    public typealias Action = (YumeTextField, UIButton) -> Void
    public var leftFunction: YumeTextField.Action?
    public var rightFunction: YumeTextField.Action?

    @IBInspectable public var leftPadding: CGFloat = 0
    override public func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.leftViewRect(forBounds: bounds)
        rect.origin.x += leftPadding
        return rect
    }

    @IBInspectable public var rightPadding: CGFloat = 0
    override public func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect: CGRect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= rightPadding
        return rect
    }

    private final lazy var leftButton = UIButton()
    private final lazy var rightButton = UIButton()

    @IBInspectable
    public var leftImage: UIImage? {
        didSet {
            let btn: UIButton = self.leftButton
            btn.setImage(self.leftImage, for: .normal)
            btn.addTarget(
                self,
                action: #selector(self.leftAction(sender:)),
                for: .touchUpInside
            )
            self.leftView = btn
        }
    }

    @IBInspectable
    public var rightImage: UIImage? {
        didSet {
            let btn: UIButton = self.rightButton
            btn.setImage(self.rightImage, for: .normal)
            btn.addTarget(
                self,
                action: #selector(self.rightAction(sender:)),
                for: .touchUpInside
            )
            self.rightView = btn
        }
    }

    @IBInspectable
    public var leftString: String? {
        didSet {
            let btn: UIButton = self.leftButton
            btn.setTitle(self.leftString, for: .normal)
            btn.addTarget(
                self,
                action: #selector(self.leftAction(sender:)),
                for: .touchUpInside
            )
            self.leftView = btn
        }
    }

    @IBInspectable
    public var rightString: String? {
        didSet {
            let btn: UIButton = self.rightButton
            btn.setTitle(self.rightString, for: .normal)
            btn.addTarget(
                self,
                action: #selector(self.rightAction(sender:)),
                for: .touchUpInside
            )
            self.rightView = btn
        }
    }

    @objc
    private final func leftAction(sender: UIButton) {
        self.leftFunction?(self, sender)
    }

    @objc
    private final func rightAction(sender: UIButton) {
        self.rightFunction?(self, sender)
    }
}
