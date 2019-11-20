//
//  CalendarSettings.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

public class CalendarSettings {
    
    public init() {}
    
    public var months: [Month]?
    public var years: [Year]?
    public var day = Day()
    public var period = Period()
    public var selectionType: CalendarViewConfig.SelectionType? = .day
    public var selectionStyle: CalendarViewConfig.SelectionStyle = .round
    public var ableDate: CalendarViewConfig.AbleDates = .next
    
    public var firstDateBuffer = [Date]()
    public var secondDateBuffer = [Date]()
    
    public var local = Locale.current
    
    public var begin = Date(timeIntervalSince1970: 0)
    public var end = Calendar.current.date(byAdding: .year, value: 100, to: Date(timeIntervalSince1970: 0))
    
    public var monthCollectionSideInset: CGFloat = 30
    public var monthHeaderViewHeight: CGFloat = 53
    public var weekHeaderViewHeight: CGFloat = 53
    
    public var monthLeftInset: CGFloat = 10
    public var monthRightInset: CGFloat = 10
    
    public var selectedRoundInset: CGFloat = 0
    
    public var dayInset: CGFloat = 5
    
    public var arrawImageWidth: CGFloat = 12
    public var arrawButtonWidth: CGFloat = 50
    
    public var isWeekSeparationLine = false
    
    public var style = Style(monthHeaderFont: .systemFont(ofSize: 17),
                             monthHeaderTextColor: .black,
                             prevArrowImage: UIImage(),
                             nextArrowImage: UIImage(),
                             arrowColor: .gray,
                             weekHeaderFont: .systemFont(ofSize: 17),
                             weekHeaderTextColor: .black,
                             dayFont: .systemFont(ofSize: 17),
                             dayTextColor: .black,
                             currentDayFont: .systemFont(ofSize: 17),
                             currentDayTextColor: .black,
                             dayDisableTextColor: .lightGray,
                             daySelectedTextColor: .white,
                             daySelectedRoundColor: .orange,
                             periodSelectedColor: UIColor.rgb(red: 242, green: 241, blue: 237),
                             firstBufferColor: .orange,
                             secondBufferColor: .blue,
                             grayBufferColor: .gray)
    
    public struct Style {
        public var monthHeaderFont: UIFont
        public var monthHeaderTextColor: UIColor
        public var prevArrowImage: UIImage?
        public var nextArrowImage: UIImage?
        
        public var arrowColor: UIColor
        
        public var weekHeaderFont: UIFont
        public var weekHeaderTextColor: UIColor
        
        public var dayFont: UIFont
        public var dayTextColor: UIColor
        public var currentDayFont: UIFont
        public var currentDayTextColor: UIColor
        public var dayDisableTextColor: UIColor
        public var daySelectedTextColor: UIColor
        public var daySelectedRoundColor: UIColor
        public var periodSelectedColor: UIColor
        
        public var firstBufferColor: UIColor
        public var secondBufferColor: UIColor
        public var grayBufferColor: UIColor
    }
    
    public func generateMonths() {
        let calendar = Calendar.current
        guard let endDate = end else { return }
        var months = [Month]()
        var startDate = begin
        repeat {
            let date = startDate
            let month = Month(month: date, calendar: calendar)
            months.append(month)
            startDate = calendar.date(byAdding: .month, value: 1, to: startDate)!
        } while !calendar.isDate(startDate, inSameDayAs: endDate)
        self.months = months
    }
}

