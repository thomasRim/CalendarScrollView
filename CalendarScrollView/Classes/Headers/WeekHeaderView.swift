//
//  WeekHeaderView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

class WeekHeaderView: UIView {
    
    var dayWidth: CGFloat = 0
    var locale = Locale.current
    var settings = CalendarSettings()
    
    fileprivate let separatorView = UIView()
    fileprivate var dayLabels = [UILabel]()
    
    func add(to view: UIView, top: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        heightAnchor.constraint(equalToConstant: settings.weekHeaderViewHeight).isActive = true
        
        setup()
    }
    
    fileprivate func setup() {
        setupDaysLabel()
        addDayLabels()
        if settings.isWeekSeparationLine {
            addSeparationLine()
        }
    }
    
    fileprivate func setupDaysLabel() {
        var calendar = Calendar.current
        let firstay = 2 //--- Monday
        calendar.firstWeekday = firstay
        let formatter = DateFormatter()
        formatter.locale = settings.local
        guard var days = formatter.shortWeekdaySymbols else { return }
        days = Array(days[firstay-1..<days.count]) + days[0..<firstay-1]
        
        days.enumerated().forEach { index, day in
            let label = UILabel()
            label.text = day.uppercased()
            label.textAlignment = .center
            label.font = settings.style.weekHeaderFont
            label.textColor = settings.style.weekHeaderTextColor
            dayLabels.append(label)
            addSubview(label)
        }
    }
    
    fileprivate func addDayLabels() {
        var commonWidth: CGFloat = 0
        dayLabels.enumerated().forEach { index, label in
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            let left = index == 0 ? settings.monthLeftInset : settings.monthLeftInset + commonWidth
            commonWidth += dayWidth
            
            label.leftAnchor.constraint(equalTo: leftAnchor, constant: left).isActive = true
            label.topAnchor.constraint(equalTo: topAnchor).isActive = true
            label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            label.widthAnchor.constraint(equalToConstant: dayWidth).isActive = true
        }
    }
    
    fileprivate func addSeparationLine() {
        let line = UIView()
        line.backgroundColor = .lightGray
        line.translatesAutoresizingMaskIntoConstraints = false
        addSubview(line)
        
        line.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        line.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        line.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
}
