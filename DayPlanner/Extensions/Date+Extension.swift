//
//  Date+Extension.swift
//  DayPlanner
//
//  Created by Usama Fouad on 13/11/2022.
//

import Foundation

extension Date {
    static var yesterday: Date? { return Date().dayBefore }
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    var endOfDay: Date? {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)
    }
    var dayBefore: Date? {
        if let noon {
            return Calendar.current.date(byAdding: .day, value: -1, to: noon)
        }
        return nil
    }
    var noon: Date? {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)
    }
}

extension Date {
    func dateString(with strFormat: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormat
        return dateFormatter.string(from: self)
    }
    
    func adding(minutes: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: self)!
    }
    
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
