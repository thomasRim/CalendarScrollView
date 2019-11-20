//
//  Day.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import Foundation

public class Day {
    
    typealias seletedDayCallBack = () -> Void
    
    public let date: Date
    public let inMonth: Bool
    
    public init(date: Date = Date(), inMonth: Bool = true) {
        self.date = date
        self.inMonth = inMonth
    }
    
    func dateInDay(_ date: Date) -> Bool {
        return Calendar.current.isDate(date, equalTo: self.date, toGranularity: .day)
    }
}
