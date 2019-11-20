//
//  Layout.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

class Layout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 0
        self.sectionInset = .zero
        self.scrollDirection = .horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
