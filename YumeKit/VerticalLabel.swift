//
//  VerticalUILabel.swift
//  APSMSwift
//
//  Created by APP559 on 2014/7/29.
//  Copyright (c) 2014 yume. All rights reserved.
//

import UIKit

@IBDesignable
open class VerticalLabel: UILabel {
    
    @IBInspectable public var verticalAlignment:String {
        set {
            if let vAlign = VerticalAlignment(rawValue: newValue){
                _verticalAlignment = vAlign
            }
        }
        get {
            return _verticalAlignment.rawValue
        }
    }
    
    public var _verticalAlignment:VerticalAlignment = .Top{
        didSet{
            self.setNeedsDisplay()
        }
    }
    
    public enum VerticalAlignment: String {
        case Top = "Top"
        case Middle = "Middle"
        case Bottom = "Bottom"
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self._verticalAlignment = .Top
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self._verticalAlignment = .Top
    }
    
    open override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let rect:CGRect = super.textRect(forBounds: bounds, limitedToNumberOfLines: numberOfLines)
        var result:CGRect
        
        switch(_verticalAlignment){
        case .Top:
            result = CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
        case .Middle:
            result = CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
        case .Bottom:
            result = CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
        }
        return result
    }
    
    open override func drawText(in rect: CGRect) {
        let r:CGRect = self.textRect(forBounds: rect, limitedToNumberOfLines: self.numberOfLines)
        super.drawText(in: r)
    }
    
}


