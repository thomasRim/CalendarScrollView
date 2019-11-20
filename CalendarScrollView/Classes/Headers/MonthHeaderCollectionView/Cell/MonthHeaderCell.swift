//
//  MonthHeaderCell.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

class MonthHeaderCell: UICollectionViewCell {
    
    fileprivate let monthLabel = UILabel()
    
    var month: Month?
    var settings = CalendarSettings()
    
    func config() {
        addMonthLabel()
    }
    
    fileprivate func addMonthLabel() {
        guard let month = month else { return }
        monthLabel.text = CalendarFormatter.monthStringForCalendar(month: month, local: settings.local).capitalized
        monthLabel.clipsToBounds = false
        monthLabel.textAlignment = .center
        monthLabel.font = settings.style.monthHeaderFont
        monthLabel.textColor = settings.style.monthHeaderTextColor
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(monthLabel)
        monthLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        monthLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        monthLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        monthLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
