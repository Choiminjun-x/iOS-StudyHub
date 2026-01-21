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
    func displayPageInfo(_ model: [[CalendarDay]])
    
    var displayMonthInfo: PassthroughSubject<String, Never> { get }
}

final class CalendarView: UIView, CalendarViewEventLogic, CalendarViewDisplayLogic {
    
    private var calendarCollectionView: UICollectionView!
    private let dateGenerator: DateGenerator
    private var days: [[CalendarDay]] = []
    
    private let weekHeader = WeekHeaderView()
    
    var selectedIndexPath: IndexPath?
    
    var displayMonthInfo: PassthroughSubject<String, Never> = .init()
    
    // MARK: instantiate
    
    init(dateGenerator: DateGenerator) {
        self.dateGenerator = dateGenerator
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
    
    static func create(with dateGenerator: DateGenerator) -> CalendarView {
        return CalendarView(dateGenerator: dateGenerator)
    }
    
    
    // MARK: MakeViewLayout
    
    private func makeViewLayout() {
        self.backgroundColor = .white
        
        self.weekHeader.do {
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.safeAreaLayoutGuide.snp.top).offset(4)
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(24)
            }
        }
        
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumInteritemSpacing = 0
//        layout.minimumLineSpacing = 0
//        let itemWidth = UIScreen.main.bounds.width / 7
//        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
//        layout.scrollDirection = .vertical
        let layout = self.makeCalendarLayout()
        self.calendarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout).do {
            $0.backgroundColor = .clear
            $0.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
            $0.delegate = self
            $0.dataSource = self
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            
            self.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(self.weekHeader.snp.bottom).offset(4)
                $0.leading.trailing.bottom.equalToSuperview()
            }
        }
    }
    
    private func makeCalendarLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, environment in
            let containerWidth = environment.container.effectiveContentSize.width
            let itemLength = floor(containerWidth / 7)
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0 / 7.0),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let rowGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemLength)
            )
            let rowGroup = NSCollectionLayoutGroup.horizontal(layoutSize: rowGroupSize, subitem: item, count: 7)
            
            let daysCount = self?.days.indices.contains(sectionIndex) == true ? self?.days[sectionIndex].count : 42
            let resolvedCount = daysCount ?? 42
            let rowCount: Int
            if resolvedCount <= 28 {
                rowCount = 4
            } else if resolvedCount <= 35 {
                rowCount = 5
            } else {
                rowCount = 6
            }
            let monthGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(itemLength * CGFloat(rowCount))
            )
            let monthGroup = NSCollectionLayoutGroup.vertical(layoutSize: monthGroupSize, subitem: rowGroup, count: rowCount)
            
            let section = NSCollectionLayoutSection(group: monthGroup)
            
            return section
        }
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.scrollDirection = .horizontal
        layout.configuration = config
        return layout
    }
    
    
    // MARK: MakeViewEvents
    
    private func makeEvents() {
        
    }
    
    func displayPageInfo(_ model: [[CalendarDay]]) {
        self.days = model
        self.calendarCollectionView.collectionViewLayout.invalidateLayout()
        self.calendarCollectionView.reloadData()
        self.updateMonthTitle(forPageIndex: 0)
    }
}

extension CalendarView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.days[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        cell.displayCellInfo(with: self.days[indexPath.section][indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let previousIndexPath = selectedIndexPath,
           let previousCell = collectionView.cellForItem(at: previousIndexPath) as? DateCell {
            previousCell.displaySelectedStyle(false)
        }
        
        if let selectedCell = collectionView.cellForItem(at: indexPath) as? DateCell {
            selectedCell.displaySelectedStyle(true)
        }
        
        self.selectedIndexPath = indexPath
    }
}

extension CalendarView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateMonthTitleForScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.updateMonthTitleForScroll(scrollView)
        }
    }
}

private extension CalendarView {
    func updateMonthTitleForScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0 else { return }
        let pageIndex = Int(round(scrollView.contentOffset.x / pageWidth))
        self.updateMonthTitle(forPageIndex: pageIndex)
    }
    
    func updateMonthTitle(forPageIndex pageIndex: Int) {
        guard days.indices.contains(pageIndex),
              let currentDate = days[pageIndex].first(where: { $0.isInCurrentMonth })?.date else {
            return
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        
        let monthText = formatter.string(from: currentDate)
        self.displayMonthInfo.send(monthText)
    }
}
