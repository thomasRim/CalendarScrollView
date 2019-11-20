//
//  Period.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

public class Period {
    
    public var start: Day
    public var end: Day
    
    public init() {
        self.start = Day(date: Date())
        self.end = Day(date: Date())
    }
    
    public init(start: Day, end: Day) {
        self.start = start
        self.end = end
    }
    
    func isOneDay() -> Bool {
        if start.date.isSameDay(end.date) {
            return true
        }
        return false
    }
    
    func isToday() -> Bool {
        if isOneDay() {
            return start.date.isToday()
        }
        return false
    }
    
    func daysCount() -> Int {
        guard let days = Calendar.current.dateComponents([.day], from: start.date, to: end.date).day else { return 1 }
        return days + 1
    }
}
