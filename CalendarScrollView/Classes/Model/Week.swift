//
//  Week.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

public class Week {
    
    public var days: [Day]
    public let date: Date
    
    fileprivate let calendar: Calendar
    
    public init(days: [Day], date: Date, calendar: Calendar) {
        self.days = days
        self.date = date
        self.calendar = calendar
    }
    
    func days(for dates: [Date]) -> [Day] {
        return dates.flatMap { date in days.filter { $0.dateInDay(date) }}
    }
    
    func dateInThisWeek(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: self.date, toGranularity: .weekOfYear)
    }
}
