//
//  Date+Extentions.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

extension Date {
    func startOfYear() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func startOfQarter() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .quarter], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
    
    func isSameDay(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isEarlyCurrentDate() -> Bool {
        let result = Calendar.current.compare(self, to: Date(), toGranularity: .day)
        if result == .orderedDescending {
            return false
        }
        return true
    }
    
    func isLaterNextDate() -> Bool {
        let result = Calendar.current.compare(self, to: Date().plus(1, component: .day), toGranularity: .day)
        if result == .orderedAscending {
            return false
        }
        return true
    }
    
    func isLaterCurrentDate() -> Bool {
        let result = Calendar.current.compare(self, to: Date(), toGranularity: .day)
        if result == .orderedAscending {
            return false
        }
        return true
    }
    
    func isCurrentMonth(date: Date? = Date()) -> Bool {
        guard let date = date else { return false }
        let result = Calendar.current.compare(self, to: date, toGranularity: .month)
        if result == .orderedSame {
            return true
        }
        return false
    }
    
    func isCurrentYear(date: Date?) -> Bool {
        guard let date = date else { return false }
        let result = Calendar.current.compare(self, to: date, toGranularity: .year)
        if result == .orderedSame {
            return true
        }
        return false
    }
    
    func isStartMonth() -> Bool {
        let startDate = self.startOfMonth()
        if self.isSameDay(startDate) {
            return true
        }
        return false
    }
    
    func isEndMonth() -> Bool {
        let endDate = self.endOfMonth()
        if self.isSameDay(endDate) {
            return true
        }
        return false
    }
    
    func isMonday() -> Bool {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        var inset = 1
        if let language = Calendar.current.locale?.languageCode {
            switch language {
            case "en":
                inset = 0
            default: break
            }
        }
        if components.weekday == Calendar.current.firstWeekday - inset + 1 {
            return true
        }
        return false
    }
    
    func isSunDay() -> Bool {
        let components = Calendar.current.dateComponents([.weekday], from: self)
        var inset = 1
        if let language = Calendar.current.locale?.languageCode {
            switch language {
            case "en":
                inset = 0
            default: break
            }
        }
        if components.weekday == Calendar.current.firstWeekday - inset {
            return true
        }
        return false
    }
    
    func isToday() -> Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func isDecember() -> Bool {
        if Calendar.current.component(.month, from: self) == 12 { return true }
        else { return false }
    }
    
    func isJanuary() -> Bool {
        if Calendar.current.component(.month, from: self) == 1 { return true }
        else { return false }
    }
    
    func plus(_ value: Int, component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: value, to: self) ?? self
    }
    
    func minus(_ value: Int, component: Calendar.Component) -> Date {
        return Calendar.current.date(byAdding: component, value: -value, to: self) ?? self
    }
}

extension Date {
    
    func isWorkDay() -> Bool {
        return !Calendar.current.isDateInWeekend(self)
    }
}
