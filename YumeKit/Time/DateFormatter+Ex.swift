//
//  DateFormatter+Ex.swift
//  YumeKit
//
//  Created by Yume on 2019/3/18.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension DateFormatter {
    public static func base(locale: Locale, format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format
        return formatter
    }

    public static func taiwan(format: String = "HH:mm") -> DateFormatter {
        return DateFormatter.base(locale: Locale(identifier: "zh_TW"), format: format)
    }
}
