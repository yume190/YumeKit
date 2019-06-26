//
//  TimeMacro.swift
//  BusApp
//
//  Created by Yume on 2017/1/12.
//  Copyright © 2017年 Yume. All rights reserved.
//

import Foundation

public struct TimeMacro {
    // http://stackoverflow.com/questions/7288671/how-to-set-time-on-nsdate
    public static func getSecondFromString(_ time: String) -> Int {
        guard let targetDateHM: Date = DateFormatter.taiwan().date(from: time) else {
            return -1
        }

        let calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let today: Date = Date()
        let todayComps: DateComponents = (calendar as NSCalendar).components([.day, .month, .year], from: today)

        var comps: DateComponents = (calendar as NSCalendar).components([.hour, .minute], from: targetDateHM)

        comps.day = todayComps.day
        comps.month = todayComps.month
        comps.year = todayComps.year

        guard let targetDate: Date = calendar.date(from: comps) else {
            return -1
        }
        let diff: Int = Int(targetDate.timeIntervalSince(today))
        return diff >= 0 ? diff : 86400 + diff
    }

    public static func getNowTime() -> DateComponents {
        let date: Date = Date()
        let calendar: Calendar = Calendar.current
        return (calendar as NSCalendar).components([.hour, .minute], from: date)
    }
}
