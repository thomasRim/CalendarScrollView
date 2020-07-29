//
//  DayView.swift
//  CalendarScrollView
//
//  Created by Александр Чегошев on 24/05/2019.
//

import UIKit

protocol DayViewDelegate {
    func saveDay(_ day: Day)
}

@available(iOS 9.0, *)
class DayView: UIView {
    
    var delegate: DayViewDelegate?
    
    var settings = CalendarSettings()
    
    var currentMonth: Month?
    var position: CalendarViewConfig.DayPosition?
    var isSameDays = false
    
    fileprivate var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var leftLayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var rightLayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var selectedCircleLayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var backgroundCircleLayerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var containerSackView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.distribution = .equalSpacing
        view.alignment = .center
        view.spacing = 2
        return view
    }()
    
    fileprivate var firstRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var secondRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var grayRoundView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        view.layer.cornerRadius = 2
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate let calendar = Calendar.current
    fileprivate var day: Day
    fileprivate var width: CGFloat = 0
    
    init(day: Day) {
        self.day = day
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let type = settings.selectionType else { return }
        switch type {
        case .day:
            if day.date.isSameDay(settings.day.date), day.date.isCurrentMonth(date: currentMonth?.firstDate) {
                selectedCircle()
            }
        case .period:
            if day.date.isCurrentMonth(date: currentMonth?.firstDate) {
                guard let pos = position else { return }
                switch pos {
                case .start, .end:
                    selectedCircle()
                case .middle:
                    grayLine()
                default:
                    break
                }
            }
        }
    }
    
    func add(to view: UIView, left: CGFloat, width: CGFloat) {
        self.width = width - 2 * settings.selectedRoundInset
        translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self)
        
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: left).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
        
        setup()
    }
    
    fileprivate func addLayerViews() {
        //--- left
        addSubview(leftLayerView)
        
        leftLayerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        leftLayerView.rightAnchor.constraint(equalTo: centerXAnchor).isActive = true
        leftLayerView.topAnchor.constraint(equalTo: topAnchor, constant: settings.selectedRoundInset).isActive = true
        leftLayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -settings.selectedRoundInset).isActive = true
        
        //--- right
        addSubview(rightLayerView)
        
        rightLayerView.leftAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rightLayerView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        rightLayerView.topAnchor.constraint(equalTo: topAnchor, constant: settings.selectedRoundInset).isActive = true
        rightLayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -settings.selectedRoundInset).isActive = true
        
        //--- blue circle
        addSubview(selectedCircleLayerView)
        
        selectedCircleLayerView.leftAnchor.constraint(equalTo: leftAnchor, constant: settings.selectedRoundInset).isActive = true
        selectedCircleLayerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -settings.selectedRoundInset).isActive = true
        selectedCircleLayerView.topAnchor.constraint(equalTo: topAnchor, constant: settings.selectedRoundInset).isActive = true
        selectedCircleLayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -settings.selectedRoundInset).isActive = true
        
        selectedCircleLayerView.frame = CGRect(x: settings.selectedRoundInset,
                                               y: settings.selectedRoundInset,
                                               width: width,
                                               height: width)
        
        //--- gray circle
        addSubview(backgroundCircleLayerView)
        
        backgroundCircleLayerView.leftAnchor.constraint(equalTo: leftAnchor, constant: settings.selectedRoundInset).isActive = true
        backgroundCircleLayerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -settings.selectedRoundInset).isActive = true
        backgroundCircleLayerView.topAnchor.constraint(equalTo: topAnchor, constant: settings.selectedRoundInset).isActive = true
        backgroundCircleLayerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -settings.selectedRoundInset).isActive = true
    }
    
    fileprivate func addStackView() {
        if day.inMonth {
            addSubview(containerSackView)
            
            containerSackView.topAnchor.constraint(equalTo: centerYAnchor).isActive = true
            containerSackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            containerSackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            containerSackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            
            containerSackView.addSubview(stackView)
            
            stackView.centerXAnchor.constraint(equalTo: containerSackView.centerXAnchor).isActive = true
            stackView.centerYAnchor.constraint(equalTo: containerSackView.centerYAnchor).isActive = true
            
            firstRoundView.backgroundColor = settings.style.firstBufferColor
            firstRoundView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            firstRoundView.widthAnchor.constraint(equalToConstant: 4).isActive = true
            
            secondRoundView.backgroundColor = settings.style.secondBufferColor
            secondRoundView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            secondRoundView.widthAnchor.constraint(equalToConstant: 4).isActive = true
            
            grayRoundView.backgroundColor = settings.style.grayBufferColor
            grayRoundView.heightAnchor.constraint(equalToConstant: 4).isActive = true
            grayRoundView.widthAnchor.constraint(equalToConstant: 4).isActive = true
            
            var isFirstEvent = false
            var isSecondEvent = false
            var isPrevEvent = false
            
            for date in settings.firstDateBuffer {
                if day.date.isSameDay(date) {
                    if !date.isEarlyCurrentDate() {
                        isFirstEvent = true
                    } else {
                        isPrevEvent = true
                    }
                    break
                }
            }
            
            for date in settings.secondDateBuffer {
                if day.date.isSameDay(date) {
                    if date > Date() {
                        isSecondEvent = true
                    } else {
                        isPrevEvent = true
                    }
                    break
                }
            }
            
            if isPrevEvent {
                if day.date.isToday() {
                    if isFirstEvent {
                        stackView.addArrangedSubview(firstRoundView)
                        stackView.addArrangedSubview(grayRoundView)
                    }
                    if isSecondEvent {
                        stackView.addArrangedSubview(grayRoundView)
                        stackView.addArrangedSubview(secondRoundView)
                    }
                    if !isFirstEvent, !isSecondEvent {
                        stackView.addArrangedSubview(grayRoundView)
                    }
                } else {
                    stackView.addArrangedSubview(grayRoundView)
                }
            } else {
                if isFirstEvent {
                    stackView.addArrangedSubview(firstRoundView)
                }
                if isSecondEvent {
                    stackView.addArrangedSubview(secondRoundView)
                }
            }
        }
    }
    
    fileprivate func setup() {
        addLayerViews()
        addStackView()
        
        dateLabel.text = CalendarFormatter.dayStringForCalendar(day: day)
        dateLabel.textAlignment = .center
        switch settings.ableDate {
        case .next:
            if day.inMonth {
                dateLabel.textColor = day.date.isLaterCurrentDate() ? settings.style.dayTextColor : settings.style.dayDisableTextColor
            } else {
                dateLabel.textColor = .clear
            }
        case .nextAfter:
            if day.inMonth {
                dateLabel.textColor = day.date.isLaterNextDate() ? settings.style.dayTextColor : settings.style.dayDisableTextColor
            } else {
                dateLabel.textColor = .clear
            }
        case .nextAfterWorkDays:
            if day.inMonth {
                    dateLabel.textColor = day.date.isLaterNextDate() && day.date.isWorkDay() ? settings.style.dayTextColor : settings.style.dayDisableTextColor
                } else {
                    dateLabel.textColor = .clear
            }
        case .previous:
            if day.inMonth {
                dateLabel.textColor = day.date.isEarlyCurrentDate() ? settings.style.dayTextColor : settings.style.dayDisableTextColor
            } else {
                dateLabel.textColor = .clear
            }
        case .all:
            if day.inMonth {
                dateLabel.textColor = settings.style.dayTextColor
            } else {
                dateLabel.textColor = .clear
            }
        }
        
        if day.date.isToday(), day.inMonth {
            dateLabel.font = settings.style.currentDayFont
            dateLabel.textColor = settings.style.currentDayTextColor
        } else {
            dateLabel.font = settings.style.dayFont
        }
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        dateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addTap()
    }
    
    fileprivate func addTap() {
        switch settings.ableDate {
        case .next:
            if day.date.isCurrentMonth(date: currentMonth?.firstDate), day.date.isLaterCurrentDate() {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                addGestureRecognizer(tap)
            }
        case .nextAfter:
            if day.date.isCurrentMonth(date: currentMonth?.firstDate), day.date.isLaterNextDate() {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                addGestureRecognizer(tap)
            }
        case .nextAfterWorkDays:
            if day.date.isCurrentMonth(date: currentMonth?.firstDate), day.date.isLaterNextDate(), day.date.isWorkDay() {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                addGestureRecognizer(tap)
            }
        case .previous:
            if day.date.isCurrentMonth(date: currentMonth?.firstDate), day.date.isEarlyCurrentDate() {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                addGestureRecognizer(tap)
            }
        case .all:
            if day.date.isCurrentMonth(date: currentMonth?.firstDate) {
                let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
                addGestureRecognizer(tap)
            }
        }
    }
}

//MARK: - UI
extension DayView {
    fileprivate func selectedCircle() {
        switch settings.selectionStyle {
        case .round:
            selectedCircleLayerView.layer.cornerRadius = width / 2
            selectedCircleLayerView.layer.backgroundColor = settings.style.daySelectedRoundColor.cgColor
            dateLabel.textColor = .white
        case .circle:
            drawRingFittingInsideView()
        }
        
        if !isSameDays {
            guard let pos = position else { return }
            switch pos {
            case .start:
                if !day.date.isEndMonth(), !day.date.isSunDay() {
                    rightLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
                }
                if day.date.isMonday() {
                    rightLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
                }
            case .end:
                if !day.date.isStartMonth(), !day.date.isMonday() {
                    leftLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
                }
            default:
                break
            }
        }
    }
    
    fileprivate func grayLine() {
        if day.date.isStartMonth() || day.date.isMonday() {
            if !day.date.isEndMonth() {
                rightLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
            }
            backgroundCircleLayerView.layer.cornerRadius = width/2
            backgroundCircleLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
        } else if day.date.isEndMonth() || day.date.isSunDay() {
            leftLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
            backgroundCircleLayerView.layer.cornerRadius = width/2
            backgroundCircleLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
        } else {
            if !day.date.isSunDay() {
                rightLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
            }
            if !day.date.isMonday() {
                leftLayerView.layer.backgroundColor = settings.style.periodSelectedColor.cgColor
            }
        }
    }
    
    func drawRingFittingInsideView() {
        let halfSize: CGFloat = min(selectedCircleLayerView.bounds.width / 2, selectedCircleLayerView.bounds.height / 2)
        let desiredLineWidth: CGFloat = 2   // your desired value
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x:halfSize,y:halfSize),
            radius: CGFloat(halfSize - (desiredLineWidth / 2)),
            startAngle: 0,
            endAngle: .pi * 2,
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = settings.style.daySelectedRoundColor.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        
        selectedCircleLayerView.layer.addSublayer(shapeLayer)
    }
}

//MARK: - Action
extension DayView {
    @objc fileprivate func tapAction() {
        delegate?.saveDay(day)
    }
}
