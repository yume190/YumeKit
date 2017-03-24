//import UIKit

extension String {
    public func fontAndFontColor(_ font:UIFont,fontColor:UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [
            NSForegroundColorAttributeName:fontColor,
            NSFontAttributeName:font
            ])
    }
    
    public func fontColor(_ fontColor:UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [
            NSForegroundColorAttributeName:fontColor,
            ])
    }
    
    public func font(_ font:UIFont) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [
            NSFontAttributeName:font
            ])
    }
}

extension String {
    public static func + (l:String,r:NSAttributedString) -> NSAttributedString {
        let str = NSMutableAttributedString(string: l)
        str.append(r)
        return str
    }
}

extension NSAttributedString {
    public static func + (l:NSAttributedString,r:String) -> NSAttributedString {
        let str = NSMutableAttributedString(attributedString: l)
        str.append(NSAttributedString(string: r))
        return str
    }

    public static func + (l:NSAttributedString,r:NSAttributedString) -> NSAttributedString {
        let str = NSMutableAttributedString(attributedString: l)
        str.append(r)
        return str
    }
}

extension NSMutableAttributedString {
    public static func + (l:NSMutableAttributedString,r:String) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(attributedString: l)
        str.append(NSAttributedString(string: r))
        return str
    }
    
    public static func + (l:NSMutableAttributedString,r:NSAttributedString) -> NSMutableAttributedString {
        let str = NSMutableAttributedString(attributedString: l)
        str.append(r)
        return str
    }
}
