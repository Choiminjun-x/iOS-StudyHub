//
//  BannerViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 4/1/25.
//

import UIKit

class BannerViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    private var timer: Timer?
    
    private let bannerItems = ["0", "1", "2"]
    private var collectionViewItems = [String]()
    
    private var currentIndex: Int = 0
    
    private var itemWidth = UIScreen.main.bounds.width - 40
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.collectionViewItems.append(self.bannerItems.last!)
        self.collectionViewItems.append(contentsOf: self.bannerItems)
        self.collectionViewItems.append(self.bannerItems.first!)
        
        self.setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollToMiddle()
        self.setTimer()
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.itemSize = CGSize(width: itemWidth, height: 200)
        
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        self.collectionView.isPagingEnabled = true
        self.collectionView.bounces = false
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.collectionView.heightAnchor.constraint(equalToConstant: 200),
            self.collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            self.collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            self.collectionView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func scrollToMiddle() {
        self.currentIndex = 1
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: [0, self.currentIndex], at: .left, animated: false) // [0, last] -> section, row
        }
    }
    
    func setTimer() {
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.rollingBanner), userInfo: nil, repeats: true)
    }
    
    func delTimer() {
        if(self.timer != nil) {
            self.timer?.invalidate()
            self.timer = nil
        }
    }
    
    @objc func rollingBanner() {
        self.currentIndex += 1
        self.collectionView.scrollToItem(at: [0, self.currentIndex], at: .left, animated: true) // [0, last] -> section, row
    }
    
    deinit {
        self.timer?.invalidate()
    }
    
}

extension BannerViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.collectionViewItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.configure(with: collectionViewItems[indexPath.item])
        return cell
    }
}

extension BannerViewController : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.delTimer()
    }
    
    // 스크롤 멈춘 뒤, 감속(=deceleration)이 끝나고 스크롤이 멈췄을 때 호출
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("🔁 scrollViewDidEndDecelerating: Call")
        
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        switch Int(round(value)) {
        case 0:
            let last = self.collectionViewItems.count - 2
            self.collectionView.scrollToItem(at: [0, last], at: .left, animated: false) // [0, last] -> section, row
        case self.collectionViewItems.count - 1:
            self.collectionView.scrollToItem(at: [0, 1], at: .left, animated: false) // [0, 1] -> section, row
        default:
            break
        }
        
        if timer == nil {
            self.setTimer()
        }
    }
    
    // 프로그래밍적으로 scrollToItem, setContentOffset(animated: true) 같은 걸 호출했을 때, 그 애니메이션이 완료되었을 때 호출
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        print("🔁 scrollViewDidEndScrollingAnimation: Call")
        let value = (scrollView.contentOffset.x / scrollView.frame.width)
        switch Int(round(value)) {
        case 0:
            let last = self.collectionViewItems.count - 2
            self.currentIndex = last
            self.collectionView.scrollToItem(at: [0, last], at: .left, animated: false) // [0, last] -> section, row
        case self.collectionViewItems.count - 1:
            self.currentIndex = 1
            self.collectionView.scrollToItem(at: [0, 1], at: .left, animated: false) // [0, 1] -> section, row
        default:
            self.currentIndex = Int(value)
            self.collectionView.scrollToItem(at: [0, self.currentIndex], at: .left, animated: true)
        }
    }
}


// MARK: - BannerCell

final class BannerCell: UICollectionViewCell {
    
    private let label = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.label.textAlignment = .center
        self.label.font = .boldSystemFont(ofSize: 40)
        contentView.addSubview(self.label)
        self.label.frame = contentView.bounds
        self.label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        contentView.backgroundColor = .systemBlue.withAlphaComponent(0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with text: String) {
        self.label.text = "배너 \(text)"
    }
}

