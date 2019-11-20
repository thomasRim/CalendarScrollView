//
//  WeekView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

protocol WeekViewDelegate {
    func saveDay(_ day: Day)
}

class WeekView: UIView {
    
    var delegate: WeekViewDelegate?
    
    var settings = CalendarSettings()
    var currentMonth: Month?
    
    var dayWidth: CGFloat = 0
    
    fileprivate let calendar = Calendar.current
    fileprivate let week: Week
    fileprivate var dayViews = [DayView]()
    
    init(week: Week) {
        self.week = week
        super.init(frame: .zero)
        backgroundColor = .clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func add(to view: UIView, top: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        setup()
    }
    
    func setup() {
        dayViews.removeAll()
        
        var commonWidth: CGFloat = 0
        week.days.enumerated().forEach { index, day in
            let dayView = DayView(day: day)
            dayView.delegate = self
            dayView.settings = settings
            dayView.currentMonth = currentMonth
            
            let startResult = calendar.compare(day.date, to: settings.period.start.date, toGranularity: .day)
            let endResult = calendar.compare(day.date, to: settings.period.end.date, toGranularity: .day)
            
            if startResult == .orderedSame {
                dayView.position = .start
            }
            if endResult == .orderedSame {
                dayView.position = .end
            }
            if startResult == .orderedDescending, endResult == .orderedAscending {
                dayView.position = .middle
            }
            if startResult == .orderedAscending, endResult == .orderedDescending {
                dayView.position = .out
            }
            if settings.period.start.date.isSameDay(settings.period.end.date) {
                dayView.isSameDays = true
            }
            let left = index == 0 ? settings.monthLeftInset : settings.monthLeftInset + commonWidth
            commonWidth += dayWidth
            
            dayView.add(to: self, left: left, width: dayWidth)
            
            dayViews.append(dayView)
        }
    }
    
    func contains(date: Date) -> Bool {
        return week.dateInThisWeek(date)
    }
}

//MARK: - DayViewDelegate
extension WeekView: DayViewDelegate {
    func saveDay(_ day: Day) {
        delegate?.saveDay(day)
    }
}
