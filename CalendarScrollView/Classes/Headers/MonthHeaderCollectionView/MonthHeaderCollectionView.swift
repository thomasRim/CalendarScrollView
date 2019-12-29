//
//  MonthHeaderCollectionView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

protocol MonthHeaderCollectionViewDelegate {
    func nextMonth()
    func prevMonth()
}

class MonthHeaderCollectionView: UIView {
    
    var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    var delegate: MonthHeaderCollectionViewDelegate?
    
    var month: Month?
    var settings = CalendarSettings()
    var collectionWidth: CGFloat = 0
    
    fileprivate let layout = Layout()
    fileprivate var prevOffset: CGPoint = .zero
    fileprivate var multiplier: CGFloat = 0
    
    var position: CalendarViewConfig.MonthPosition?
    
    fileprivate let yearLabel = UILabel()
    fileprivate let prevImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let prevButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let nextImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let nextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate let leftFadeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let rightFadeView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    func add(to view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: settings.monthHeaderViewHeight).isActive = true
        
        setup()
    }
    
    func updateOffset(offset: CGPoint) {
        collectionView.contentOffset.x = offset.x * multiplier
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let months = settings.months else { return }
        for (index, month) in months.enumerated() {
            if settings.day.date.isCurrentMonth(date: month.firstDate) {
                collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: false)
            }
        }
    }
    
    fileprivate func setup() {
        multiplier = (collectionWidth - settings.arrawButtonWidth * 2 - settings.monthCollectionSideInset * 2) / collectionWidth
        addButtons()
        setupCollectionViews()
    }
    
    fileprivate func addButtons() {
        //--- prev
        prevImageView.image = settings.style.prevArrowImage
        addSubview(prevImageView)
        
        prevImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 25).isActive = true
        prevImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        prevImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        prevButton.addTarget(self, action: #selector(prevMonthAction), for: .touchUpInside)
        addSubview(prevButton)
        
        prevButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        prevButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        prevButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        prevButton.widthAnchor.constraint(equalToConstant: settings.arrawButtonWidth).isActive = true
        
        //---next
        nextImageView.image = settings.style.nextArrowImage
        addSubview(nextImageView)
        
        nextImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25).isActive = true
        nextImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        nextImageView.heightAnchor.constraint(equalToConstant: 12).isActive = true
        
        nextButton.addTarget(self, action: #selector(nextMonthAction), for: .touchUpInside)
        addSubview(nextButton)
        
        nextButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: settings.arrawButtonWidth).isActive = true
        
        guard let pos = position else { return }
        switch pos {
        case .first:
            prevImageView.isHidden = true
            prevButton.isHidden = true
        case .last:
            nextImageView.isHidden = true
            nextButton.isHidden = true
        case .middle:
            prevImageView.isHidden = false
            nextImageView.isHidden = false
            prevButton.isHidden = false
            nextButton.isHidden = false
        }
    }
    
    fileprivate func setupCollectionViews() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.itemSize = CGSize(width: collectionWidth - settings.arrawButtonWidth * 2 - settings.monthCollectionSideInset * 2,
                                     height: settings.monthHeaderViewHeight - layout.sectionInset.top - layout.sectionInset.bottom)
        }
        collectionView.register(MonthHeaderCell.self, forCellWithReuseIdentifier: String(describing: MonthHeaderCell.self))
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        addCollectionViewsConstraint()
    }
    
    fileprivate func addCollectionViewsConstraint() {
        addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: prevButton.rightAnchor, constant: settings.monthCollectionSideInset).isActive = true
        collectionView.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: -settings.monthCollectionSideInset).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        /*
        addSubview(leftFadeView)
        leftFadeView.leftAnchor.constraint(equalTo: prevButton.rightAnchor, constant: settings.monthCollectionSideInset).isActive = true
        leftFadeView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        leftFadeView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        leftFadeView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        leftFadeView.frame = CGRect(x: 0, y: 0, width: 40, height: settings.monthHeaderViewHeight)
        
        let leftGradient = CAGradientLayer()
        leftGradient.frame = leftFadeView.bounds
        leftGradient.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
        leftGradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        leftGradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        leftFadeView.layer.mask = leftGradient
        
        addSubview(rightFadeView)
        rightFadeView.rightAnchor.constraint(equalTo: nextButton.leftAnchor, constant: -settings.monthCollectionSideInset).isActive = true
        rightFadeView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        rightFadeView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        rightFadeView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        rightFadeView.frame = CGRect(x: 0, y: 0, width: 40, height: settings.monthHeaderViewHeight)
        
        let rightGradient = CAGradientLayer()
        rightGradient.frame = rightFadeView.bounds
        rightGradient.colors = [UIColor.clear.cgColor, UIColor.red.cgColor]
        rightGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        rightGradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        rightFadeView.layer.mask = rightGradient
        */
    }
    
    //MARK: - Action
    @objc fileprivate func prevMonthAction() {
        prevButton.isEnabled = false
        nextButton.isEnabled = false
        DispatchQueue.main.async {
            self.delegate?.prevMonth()
        }
    }
    
    @objc fileprivate func nextMonthAction() {
        prevButton.isEnabled = false
        nextButton.isEnabled = false
        DispatchQueue.main.async {
            self.delegate?.nextMonth()
        }
    }
    
    //MARK: - Able month
    fileprivate func checkAbleMonth(at index: Int) {
        let newMonth = settings.months?[index]
        switch settings.ableDate {
        case .previous:
            if newMonth?.firstDate.isCurrentMonth() ?? false {
                nextImageView.isHidden = true
                nextButton.isEnabled = false
            } else {
                nextImageView.isHidden = false
                nextButton.isEnabled = true
            }
        case .next:
            if newMonth?.firstDate.isCurrentMonth() ?? false {
                prevImageView.isHidden = true
                prevButton.isEnabled = false
            } else {
                prevImageView.isHidden = false
                prevButton.isEnabled = true
            }
        default: break
        }
    }
}

extension MonthHeaderCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.months?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MonthHeaderCell.self), for: indexPath) as! MonthHeaderCell
        cell.month = settings.months?[indexPath.item]
        cell.settings = settings
        cell.config()
        return cell
    }
}

extension MonthHeaderCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        checkAbleMonth(at: indexPath.item)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if Int(scrollView.contentOffset.x) % Int(scrollView.frame.width) == 0 {
            prevButton.isEnabled = true
            nextButton.isEnabled = true
            let index = Int(scrollView.contentOffset.x / scrollView.frame.width)
            checkAbleMonth(at: index)
        }
    }
}
