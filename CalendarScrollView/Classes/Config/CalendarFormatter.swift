//
//  CalendarFormatter.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

class CalendarFormatter {
    
    static func monthStringForCalendar(month: Month, local: Locale) -> String {
        let formatter = DateFormatter()
        formatter.locale = local
        formatter.dateFormat = "LLLL  yyyy"
        return formatter.string(from: month.firstDate)
    }
    
    static func dayStringForCalendar(day: Day) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: day.date)
    }
    
    static func dateStringForDictionary(day: Day) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyy"
        return formatter.string(from: day.date)
    }
    
    static func dateFromDictionaryString(_ string: String) -> Date? {
        let formatter = DateFormatter()
        return formatter.date(from: "dd.MM.yyy")
    }
}
