//
//  CarouselView.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/5/25.
//

import UIKit
import SnapKit

final class CarouselView: UIView {
    
    private var collectionView: UICollectionView!
    
    private let itemSize = CGSize(width: 80, height: 80)
    private let itemSpacing: CGFloat = 10
    private let actualItemCount = 6
    private let scrollSpeed: CGFloat = 1.1
    
    private var items: [UIImage] = []

    /// Timer 대신 CADisplayLink를 사용해 화면 갱신 주기에 맞춰 스크롤을 업데이트
    private var displayLink: CADisplayLink?

    
    // MARK: instantiate
    
    deinit {
        self.displayLink?.invalidate()
    }
    
    required init() {
        super.init(frame: .zero)
        self.makeViewLayout()
        self.setupItems()
        self.setInitialContentOffset()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    // MARK: makeViewLayout
    
    private func makeViewLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = self.itemSize
        layout.minimumLineSpacing = self.itemSpacing
        
        self.collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        ).do {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
                $0.height.equalTo(itemSize.height+8)
            }
            $0.backgroundColor = .clear
            $0.register(CarouselItemCell.self, forCellWithReuseIdentifier: "CarouselItemCell")
            $0.dataSource = self
            $0.showsHorizontalScrollIndicator = false
            $0.isUserInteractionEnabled = true
            
            let horizontalInset = (bounds.width - self.itemSize.width) / 2
            $0.contentInset = UIEdgeInsets(top: 0, left: horizontalInset, bottom: 0, right: horizontalInset)
        }
    }
    
    
    // MARK: setup
    
    private func setupItems() {
        let images = [
            UIImage(systemName: "square.and.arrow.up.fill"),
            UIImage(systemName: "eraser.fill"),
            UIImage(systemName: "paperplane.fill"),
            UIImage(systemName: "pencil.and.outline"),
            UIImage(systemName: "externaldrive.fill.badge.timemachine"),
            UIImage(systemName: "book.pages"),
            UIImage(systemName: "books.vertical.fill"),
            UIImage(systemName: "graduationcap")
        ].compactMap { $0 }
        
        self.items = images + images + images // 3배로 반복
    }
    
    private func setInitialContentOffset() {
        let initialOffset = (self.itemSize.width + self.itemSpacing) * CGFloat(self.actualItemCount)
        self.collectionView.contentOffset.x = initialOffset
    }
    
    func startScrolling() {
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateScroll))
        self.displayLink?.add(to: .main, forMode: .common)
    }
    
    @objc private func updateScroll() {
        self.collectionView.contentOffset.x += self.scrollSpeed
        
        let itemWidth = self.itemSize.width + self.itemSpacing
        let threshold = itemWidth * CGFloat(self.actualItemCount)
        
        if self.collectionView.contentOffset.x >= threshold * 2 {
            self.collectionView.contentOffset.x -= threshold
        } else if self.collectionView.contentOffset.x < threshold {
            self.collectionView.contentOffset.x += threshold
        }
    }
}


extension CarouselView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CarouselItemCell", for: indexPath) as? CarouselItemCell else {
            fatalError("Unable to dequeue CarouselCell")
        }
        let image = self.items[indexPath.item]
        cell.configure(with: image)
        return cell
    }
}


// MARK: CarouselItemCell

final class CarouselItemCell: UICollectionViewCell {
    
    // MARK: instantiate
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    
    // MARK: configure
    
    func configure(with image: UIImage) {
        UIImageView().do {
            addSubview($0)
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            $0.image = image
        }
    }
}
