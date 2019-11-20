//
//  MonthView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

protocol MonthViewDelegate {
    func saveDay(_ day: Day)
}

class MonthView: UIView {
    
    var delegate: MonthViewDelegate?
    
    var settings = CalendarSettings()
    var month: Month?
    
    var weekHeight: CGFloat = 0.0
    var dayWidth: CGFloat = 0.0
    
    fileprivate var weekViews = [WeekView]()
    
    func add(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        setup()
    }
    
    func setup() {
        self.weekViews.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        
        var commonHeight: CGFloat = 0
        
        guard let month = month else { return }
        month.weeks.enumerated().forEach { index, week in
            let weekView = WeekView(week: week)
            weekView.delegate = self
            weekView.settings = settings
            weekView.currentMonth = month
            weekView.dayWidth = dayWidth
            weekView.add(to: self, top: commonHeight, height: weekHeight)
            
            weekViews.append(weekView)
            commonHeight += weekHeight
        }
    }
}

//MARK: - WeekViewDelegate
extension MonthView: WeekViewDelegate {
    func saveDay(_ day: Day) {
        delegate?.saveDay(day)
    }
}
