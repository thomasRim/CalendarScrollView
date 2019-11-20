//
//  MonthCollectionView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

protocol MonthCollectionViewDelegate {
    func saveDay(_ day: Day)
    func scrollMonth(offset: CGPoint)
}

class MonthCollectionView: UIView {
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var delegate: MonthCollectionViewDelegate?
    
    var settings = CalendarSettings()
    
    var weekHeight: CGFloat = 0.0
    var dayWidth: CGFloat = 0.0
    
    fileprivate var didLoad = false
    
    fileprivate let layout = Layout()
    
    fileprivate var prevOffset: CGPoint = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollToCurrentDate()
    }
    
    func add(to view: UIView, top: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: top).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
        
        setupCollectionViews(height: height)
    }
    
    func update() {
        collectionView.reloadData()
    }
    
    fileprivate func scrollToCurrentDate() {
        if !didLoad {
            guard let months = settings.months else { return }
            for (index, month) in months.enumerated() {
                if Date().isCurrentMonth(date: month.firstDate) {
                    collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
                    break
                }
            }
            didLoad = true
        }
    }
    
    func scrollToSelectedDate() {
        guard let months = settings.months else { return }
        for (index, month) in months.enumerated() {
            if settings.day.date.isCurrentMonth(date: month.firstDate) {
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
                break
            }
        }
    }
    
    func scrollToNextMonth() {
        let offset = CGPoint(x: collectionView.contentOffset.x + collectionView.frame.width, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: true)
    }
    
    func scrollToPrevMonth() {
        let offset = CGPoint(x: collectionView.contentOffset.x - collectionView.frame.width, y: collectionView.contentOffset.y)
        collectionView.setContentOffset(offset, animated: true)
    }
    
    fileprivate func setupCollectionViews(height: CGFloat) {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: dayWidth * CalendarViewConfig.daysCount + settings.monthLeftInset + settings.monthRightInset,
                                     height: height)
        }
        collectionView.register(MonthCell.self, forCellWithReuseIdentifier: String(describing: MonthCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addCollectionViewsConstraint()
    }
    
    fileprivate func addCollectionViewsConstraint() {
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}

extension MonthCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.months?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthCell.self), for: indexPath) as! MonthCell
        cell.delegate = self
        cell.settings = settings
        cell.month = settings.months?[indexPath.row]
        cell.weekHeight = weekHeight
        cell.dayWidth = dayWidth
        cell.config()
        return cell
    }
}

extension MonthCollectionView: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if didLoad {
            delegate?.scrollMonth(offset: scrollView.contentOffset)
        }
        prevOffset = collectionView.contentOffset
    }
}

extension MonthCollectionView: MonthCellDelegate {
    func saveDay(_ day: Day) {
        delegate?.saveDay(day)
    }
}
