//
//  Date+Ex.swift
//  YumeKit
//
//  Created by Yume on 2019/3/18.
//  Copyright © 2019 Yume. All rights reserved.
//

import Foundation

extension Date {
    public static var now: DateComponents {
        let date: Date = Date()
        let calendar: Calendar = Calendar.current
        return calendar.dateComponents(
            [
                .year, .month, .day,
                .hour, .minute, .second
            ], from: date)
    }
}
