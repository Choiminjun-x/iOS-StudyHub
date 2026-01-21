//
//  CalendarView.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import UIKit
import Combine
import SnapKit


// MARK: ViewEventLogic

protocol CalendarViewEventLogic where Self: NSObject {
    
}

// MARK: ViewDisplayLogic

protocol CalendarViewDisplayLogic where Self: NSObject {
    func displayPageInfo(_ model: [CalendarDay])
    
    var didChangeMonth: PassthroughSubject<String, Never> { get }
}

final class CalendarView: UIView, CalendarViewEventLogic, CalendarViewDisplayLogic {
    
    private var collectionView: UICollectionView!
    private let dateProvider: CalendarDateProviding
    private var days: [CalendarDay] = []
    
    private let monthLabel = UILabel()
    private let dayOfWeekHeader = DayOfWeekHeaderView()
    
    var didChangeMonth: PassthroughSubject<String, Never> = .init()
    
    // MARK: instantiate
    
    init(dateProvider: CalendarDateProviding) {
        self.dateProvider = dateProvider
        super.init(frame: .zero)
        self.makeViewLayout()
        self.makeEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    deinit {
        print(type(of: self), #function)
    }
    
    static func create(with dateProvider: CalendarDateProviding) -> CalendarView {
        return CalendarView(dateProvider: dateProvider)
    }
    
    // MARK: MakeViewLayout
    
    private func makeViewLayout() {
        self.backgroundColor = .white

        // MARK: Month Label
        monthLabel.font = .systemFont(ofSize: 18, weight: .semibold)
        monthLabel.textAlignment = .center
        monthLabel.textColor = .label

        self.addSubview(monthLabel)
        monthLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(32)
        }

        self.addSubview(dayOfWeekHeader)
        dayOfWeekHeader.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(4)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(24)
        }
        
        
        // MARK: CollectionView
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        let itemWidth = UIScreen.main.bounds.width / 7
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .clear

        self.collectionView.register(CalendarDateCell.self, forCellWithReuseIdentifier: "DateCell")
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        self.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(dayOfWeekHeader.snp.bottom).offset(4)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    // MARK: MakeViewEvents
    
    private func makeEvents() {
        
    }
    
    func displayPageInfo(_ model: [CalendarDay]) {
        self.days = model
        self.collectionView.reloadData()
        
        // 상단 라벨 업데이트
         if let currentDate = days.first(where: { $0.isInCurrentMonth })?.date {
             let formatter = DateFormatter()
             formatter.locale = Locale(identifier: "ko_KR")
             formatter.dateFormat = "yyyy년 M월"
             
             self.didChangeMonth.send(formatter.string(from: currentDate))
         }
    }
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = days[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! CalendarDateCell
        cell.configure(with: day)
        return cell
    }
}


final class CalendarDateCell: UICollectionViewCell {
    
    private let label = UILabel()
    private let todayCircleView = UIView()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(todayCircleView)
        contentView.addSubview(label)
        
        todayCircleView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.height.equalTo(32)
        }
        todayCircleView.layer.cornerRadius = 16
        todayCircleView.backgroundColor = .systemBlue
        todayCircleView.isHidden = true
        
        label.textAlignment = .center
        label.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with day: CalendarDay) {
        let dayNumber = Calendar.current.component(.day, from: day.date)
        label.text = "\(dayNumber)"
        label.textColor = day.isInCurrentMonth ? .label : .lightGray
        
        if day.isToday {
            todayCircleView.isHidden = false
            label.textColor = .white
        } else {
            todayCircleView.isHidden = true
            label.textColor = day.isInCurrentMonth ? .label : .lightGray
        }
    }
}

final class DayOfWeekHeaderView: UIView {
    private let stackView = UIStackView()
    private let days = ["일", "월", "화", "수", "목", "금", "토"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func setup() {
        self.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually

        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }

        for (index, day) in days.enumerated() {
            let label = UILabel()
            label.text = day
            label.font = .systemFont(ofSize: 13, weight: .medium)
            label.textAlignment = .center
            label.textColor = index == 0 ? .systemRed : (index == 6 ? .systemBlue : .secondaryLabel)
            stackView.addArrangedSubview(label)
        }
    }
}
