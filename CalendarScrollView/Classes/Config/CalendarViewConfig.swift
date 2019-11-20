//
//  CalendarViewConfig.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

public class CalendarViewConfig {
    
    enum MonthPosition {
        case first
        case last
        case middle
    }
    
    enum DayPosition {
        case start
        case end
        case middle
        case out
        case same
    }
    
    public enum SelectionType {
        case day
        case period
    }
    
    public enum SelectionStyle {
        case round
        case circle
    }
    
    public enum AbleDates {
        case previous
        case next
        case all
    }
    
    static let maxWeekCount: CGFloat = 6
    
    static let daysCount: CGFloat = CGFloat(Calendar.current.shortWeekdaySymbols.count)
}
