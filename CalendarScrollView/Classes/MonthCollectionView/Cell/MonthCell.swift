//
//  MonthCell.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

protocol MonthCellDelegate {
    func saveDay(_ day: Day)
}

class MonthCell: UICollectionViewCell {
    
    fileprivate var monthView: MonthView = MonthView()
    
    var delegate: MonthCellDelegate?
    
    var settings = CalendarSettings()
    var month: Month?
    
    var weekHeight: CGFloat = 0.0
    var dayWidth: CGFloat = 0.0
    
    func config() {
        monthView.delegate = self
        monthView.month = month
        monthView.settings = settings
        monthView.weekHeight = weekHeight
        monthView.dayWidth = dayWidth
        monthView.add(to: self)
    }
}

extension MonthCell: MonthViewDelegate {
    func saveDay(_ day: Day) {
        delegate?.saveDay(day)
    }
}
