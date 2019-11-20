//
//  Month.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

public class Month {
    
    public var weeks = [Week]()
    public let firstDate: Date
    public let lastMonthDay: Date
    
    fileprivate let calendar: Calendar
    
    var isCurrent: Bool {
        return calendar.isDate(firstDate, equalTo: Date(), toGranularity: .month)
    }
    
    var numberOfWeeks: Int {
        return weeks.count
    }
    
    var selectedDays = [Day]() {
        didSet {
            self.weeks = generateWeeks()
        }
    }
    
    public init(month: Date, calendar: Calendar) {
        self.firstDate = month
        self.calendar = calendar
        self.lastMonthDay = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: firstDate)!
        weeks = generateWeeks()
    }
    
    func days(for dates: [Date]) -> [Day] {
        return weeks.flatMap { $0.days(for: dates) }
    }
    
    func dateInThisMonth(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: self.firstDate, toGranularity: .month)
    }
    
    fileprivate func generateWeeks() -> [Week] {
        var weeks = [Week]()
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: firstDate)
        var weekDay = calendar.date(from: components)!
        weekDay = calendar.date(byAdding: .day, value: 1, to: weekDay)!
        var checkDay = calendar.date(byAdding: .day, value: -1, to: weekDay)!
        repeat {
            var days = [Day]()
            for index in 0...6 {
                let dayInset = Calendar.current.firstWeekday - 1
                guard let dayInWeek = calendar.date(byAdding: .day, value: +index - dayInset, to: weekDay) else { continue }
                let day = Day(date: dayInWeek, inMonth: inMoth(dayInWeek))
                days.append(day)
            }
            let week = Week(days: days, date: weekDay, calendar: calendar)
            weeks.append(week)
            weekDay = calendar.date(byAdding: .weekOfYear, value: 1, to: weekDay)!
            checkDay = calendar.date(byAdding: .weekOfYear, value: 1, to: checkDay)!
        } while calendar.isDate(checkDay, equalTo: lastMonthDay, toGranularity: .month)
        
        return weeks
    }
    
    fileprivate func inMoth(_ date: Date) -> Bool {
        if !calendar.isDate(date, equalTo: lastMonthDay, toGranularity: .month) {
            return false
        }
        return true
    }
}
