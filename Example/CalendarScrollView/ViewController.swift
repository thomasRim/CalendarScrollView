//
//  ViewController.swift
//  CalendarScrollView
//
//  Created by 4egoshev on 11/20/2019.
//  Copyright (c) 2019 4egoshev. All rights reserved.
//

import UIKit
import CalendarScrollView

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var calendarScrollView: CalendarScrollView!
    
    @IBOutlet fileprivate weak var calendarHeightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        let settings = CalendarSettings()
        settings.begin = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: Date())))!
        settings.generateMonths()
        settings.day = Day(date: Date())
        settings.local = Locale(identifier: "ru_RU")
        settings.selectedRoundInset = 1
        settings.style.prevArrowImage = UIImage(named: "prev")
        settings.style.nextArrowImage = UIImage(named: "next")
        settings.style.weekHeaderTextColor = .lightGray
        settings.style.daySelectedRoundColor = .orange
        calendarScrollView.settings = settings
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        calendarHeightConstraint.constant = calendarScrollView.estimateCalendarHeight()
    }
}

