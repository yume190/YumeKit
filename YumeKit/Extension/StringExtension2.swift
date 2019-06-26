//import UIKit

extension String {
    public func fontAndFontColor(_ font: UIFont, fontColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.foregroundColor: fontColor,
            NSAttributedString.Key.font: font
            ])
    }

    public func fontColor(_ fontColor: UIColor) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.foregroundColor: fontColor
            ])
    }

    public func font(_ font: UIFont) -> NSMutableAttributedString {
        return NSMutableAttributedString(string: self, attributes: [
            NSAttributedString.Key.font: font
            ])
    }
}

extension String {
    public static func + (l: String, r: NSAttributedString) -> NSAttributedString {
        let str: NSMutableAttributedString = NSMutableAttributedString(string: l)
        str.append(r)
        return str
    }
}

extension NSAttributedString {
    public static func + (l: NSAttributedString, r: String) -> NSAttributedString {
        let str: NSMutableAttributedString = NSMutableAttributedString(attributedString: l)
        str.append(NSAttributedString(string: r))
        return str
    }

    public static func + (l: NSAttributedString, r: NSAttributedString) -> NSAttributedString {
        let str: NSMutableAttributedString = NSMutableAttributedString(attributedString: l)
        str.append(r)
        return str
    }
}

extension NSMutableAttributedString {
    public static func + (l: NSMutableAttributedString, r: String) -> NSMutableAttributedString {
        let str: NSMutableAttributedString = NSMutableAttributedString(attributedString: l)
        str.append(NSAttributedString(string: r))
        return str
    }

    public static func + (l: NSMutableAttributedString, r: NSAttributedString) -> NSMutableAttributedString {
        let str: NSMutableAttributedString = NSMutableAttributedString(attributedString: l)
        str.append(r)
        return str
    }
}
