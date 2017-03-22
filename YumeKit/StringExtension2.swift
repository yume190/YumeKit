////import UIKit
//
//extension String {
//    func fontAndFontColor(_ font:UIFont,fontColor:UIColor) -> NSMutableAttributedString {
//        return NSMutableAttributedString(string: self, attributes: [
//            NSForegroundColorAttributeName:fontColor,
//            NSFontAttributeName:font
//            ])
//    }
//    
//    func fontColor(_ fontColor:UIColor) -> NSMutableAttributedString {
//        return NSMutableAttributedString(string: self, attributes: [
//            NSForegroundColorAttributeName:fontColor,
//            ])
//    }
//    
//    func font(_ font:UIFont) -> NSMutableAttributedString {
//        return NSMutableAttributedString(string: self, attributes: [
//            NSFontAttributeName:font
//            ])
//    }
//}
//
//func + (l:String,r:NSAttributedString) -> NSAttributedString {
//    let str = NSMutableAttributedString(string: l)
//    str.append(r)
//    return str
//}
//
////func + (l:String,r:NSMutableAttributedString) -> NSAttributedString {
////
////}
//
//func + (l:NSAttributedString,r:String) -> NSAttributedString {
//    let str = NSMutableAttributedString(attributedString: l)
//    str.append(NSAttributedString(string: r))
//    return str
//}
//
////func + (l:NSMutableAttributedString,r:String) -> NSAttributedString {
////    let str = l
////    str.appendAttributedString(NSAttributedString(string: r))
////    return str
////}
//
//func + (l:NSAttributedString,r:NSAttributedString) -> NSAttributedString {
//    let str = NSMutableAttributedString(attributedString: l)
//    str.append(r)
//    return str
//}
