//
//  HtmlMacro.swift
//  BusApp
//
//  Created by Yume on 2017/1/12.
//  Copyright © 2017年 Yume. All rights reserved.
//

import UIKit

public struct HTML {
    public static func htmlToString(html:String) -> String {
        guard let data = html.data(using: String.Encoding.unicode, allowLossyConversion: true) else {
            return html
        }
        
        return (try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html], documentAttributes: nil))?.string ?? html
    }
}
