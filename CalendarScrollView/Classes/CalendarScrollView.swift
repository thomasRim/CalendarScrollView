//
//  CalendarScrollView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

@objc public protocol CalendarScrollViewDelegate {
    @objc optional func update(date: Date)
    @objc optional func updatePeriod(startDate: Date, endDate: Date)
}

public class CalendarScrollView: UIView {
    
    public var delegate: CalendarScrollViewDelegate?
    
    public var settings = CalendarSettings()
    
    fileprivate var locale = Locale.current
    fileprivate let calendar = Calendar.current
    fileprivate var currentMonth: Month?
    fileprivate var currenMonthIndex: Int = 0
    fileprivate var currentMonthPosition: CalendarViewConfig.MonthPosition?
    fileprivate var saveTurn: CalendarViewConfig.DayPosition = .start
    
    fileprivate let monthHeaderCollectionView = MonthHeaderCollectionView()
    fileprivate let monthCollectionView = MonthCollectionView()
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setupCurrentMonth()
        setupView()
    }
    
    fileprivate func setupView() {
        subviews.forEach { $0.removeFromSuperview() }
        addWeekHeaderView()
        addMonthHeaderView()
        addMonthView()
    }
    
    fileprivate func setupCurrentMonth() {
        currentMonth = settings.months?.last
        guard let count = settings.months?.count else { return }
        currenMonthIndex = count - 1 - monthInset()
        if currenMonthIndex == 0 {
            currentMonthPosition = .first
        } else if currenMonthIndex == count - 1 {
            currentMonthPosition = .last
        } else {
            currentMonthPosition = .middle
        }
        currentMonth = settings.months?[currenMonthIndex]
    }
    
    fileprivate func monthInset() -> Int {
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        
        let month = Calendar.current.component(.month, from: settings.period.end.date)
        let year = Calendar.current.component(.year, from: settings.period.end.date)
        
        var monthInset = 0
        if year == currentYear {
            if month < currentMonth {
                monthInset = currentMonth - month
            }
        }
        if year < currentYear {
            monthInset = ((currentYear - year) * 12) + (currentMonth - month)
        }
        return monthInset
    }
    
    fileprivate func addMonthHeaderView() {
        monthHeaderCollectionView.delegate = self
        monthHeaderCollectionView.month = currentMonth
        monthHeaderCollectionView.settings = settings
        monthHeaderCollectionView.collectionWidth = bounds.width
        monthHeaderCollectionView.add(to: self)
    }
    
    fileprivate func addWeekHeaderView() {
        let weekHeaderView = WeekHeaderView()
        weekHeaderView.locale = locale
        weekHeaderView.settings = settings
        let top = settings.monthHeaderViewHeight
        weekHeaderView.dayWidth = estimateDayWidth()
        weekHeaderView.add(to: self, top: top)
        
    }
    
    fileprivate func addMonthView() {
        monthCollectionView.delegate = self
        monthCollectionView.settings = settings
        monthCollectionView.weekHeight = estimateWeekHeight()
        monthCollectionView.dayWidth = estimateDayWidth()
        
        let top = settings.monthHeaderViewHeight + settings.weekHeaderViewHeight
        let height = estimateMonthHeight()
        monthCollectionView.add(to: self, top: top, height: height)
    }
    
    
    public func estimateCalendarHeight() -> CGFloat {
        return settings.monthHeaderViewHeight + settings.weekHeaderViewHeight + estimateMonthHeight()
    }
    
    fileprivate func estimateMonthHeight() -> CGFloat {
        return estimateWeekHeight() * CalendarViewConfig.maxWeekCount
    }
    
    fileprivate func estimateWeekHeight() -> CGFloat {
        return estimateDayWidth()
    }
    
    fileprivate func estimateDayWidth() -> CGFloat {
        let width = bounds.width - (settings.monthLeftInset + settings.monthRightInset)
        return width / CalendarViewConfig.daysCount
    }
    
    public func scrollToSelectedDate(_ date: Date) {
        let oldDate = settings.day.date
        settings.day = Day(date: date)
        monthCollectionView.settings = settings
        if date.isCurrentMonth(date: oldDate) {
            monthCollectionView.update()
        } else {
            monthCollectionView.scrollToSelectedDate()
        }
    }
    
    public func updateMonth() {
        monthCollectionView.update()
    }
}

extension CalendarScrollView: MonthHeaderCollectionViewDelegate {
    func nextMonth() {
        monthCollectionView.scrollToNextMonth()
    }
    
    func prevMonth() {
        monthCollectionView.scrollToPrevMonth()
    }
}

//MARK: - MonthViewDelegate
extension CalendarScrollView: MonthCollectionViewDelegate {
    func saveDay(_ day: Day) {
        guard let selectionType = settings.selectionType else { return }
        switch selectionType {
        case .day:
            settings.day = day
            delegate?.update?(date: settings.day.date)
        case .period:
            switch saveTurn {
            case .start:
                let result = calendar.compare(settings.period.end.date, to: day.date, toGranularity: .day)
                switch result {
                case .orderedDescending:
                    if day.date.isSameDay(settings.period.start.date) {
                        settings.period.end = day
                    } else {
                        settings.period.start = day
                    }
                case .orderedAscending:
                    settings.period.end = day
                case .orderedSame:
                    settings.period.start = day
                    settings.period.end = day
                }
                saveTurn = .end
            case .end:
                let result = calendar.compare(settings.period.start.date, to: day.date, toGranularity: .day)
                switch result {
                case .orderedDescending:
                    settings.period.start = day
                case .orderedAscending:
                    if day.date.isSameDay(settings.period.end.date) {
                        settings.period.start = day
                    } else {
                        settings.period.end = day
                    }
                case .orderedSame:
                    settings.period.start = day
                    settings.period.end = day
                }
                saveTurn = .start
                delegate?.updatePeriod?(startDate: settings.period.start.date, endDate: settings.period.end.date)
            default:
                break
            }
        }
        monthCollectionView.update()
    }
    
    func scrollMonth(offset: CGPoint) {
        monthHeaderCollectionView.updateOffset(offset: offset)
    }
}
