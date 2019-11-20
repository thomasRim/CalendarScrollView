//
//  UIColor+Extentions.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

extension UIColor {
    static func rgb(red: Int, green: Int, blue: Int, alpha: CGFloat = 1) -> UIColor {
        return UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: alpha)
    }
}
