//
//  UIComponentsDemoView.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/21/25.
//

import UIKit
import SnapKit

class UIComponentsDemoView: UIView {

    private var scrollView: UIScrollView!
    private var scrollContentsView: UIStackView!
    
    private var headerView: UIView!
    private var textFieldContentsView: UIView!
    private var buttonContentsView: UIView!
    private var carouselContentsView: UIView!
    
    
    // MARK: instantiate
    
    required init() {
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
    
    static func create() -> UIComponentsDemoView {
        return UIComponentsDemoView()
    }

    
    // MARK: makeViewLayout
    
    private func makeViewLayout() {
        self.do { superView in
            superView.backgroundColor = .white
            
            self.scrollView = UIScrollView().do { scrollView in
                superView.addSubview(scrollView)
                scrollView.snp.makeConstraints {
                    $0.edges.equalToSuperview()
                }
                
                self.scrollContentsView  = UIStackView().do { scrollContentsView in
                    scrollContentsView.axis = .vertical
                    scrollContentsView.spacing = 20
                    
                    scrollView.addSubview(scrollContentsView)
                    scrollContentsView.snp.makeConstraints {
                        $0.width.edges.equalToSuperview()
                    }
                    
                    // Header
                    self.headerView = self.makeHeaderView().do {
                        scrollContentsView.addArrangedSubview($0)
                    }
                     
                    // TextField
                    self.textFieldContentsView = self.makeTextFieldContentsView().do {
                        scrollContentsView.addArrangedSubview($0)
                    }
                    
                    // Button
                    self.buttonContentsView = self.makeButtonContentsView().do {
                        scrollContentsView.addArrangedSubview($0)
                    }
                    
                    self.carouselContentsView = self.makeCarouselContentsView().do {
                        scrollContentsView.addArrangedSubview($0)
                    }
                }
            }
        }
    }
    
    
    // MARK: makeSubViewLayout
    
    private func makeHeaderView() -> UIView {
        return UIView().do { superView in
            UILabel().do { label in
                label.text = "UIComponentsDemoView Sample"
                label.textColor = .black
                label.font = .systemFont(ofSize: 20, weight: .bold)
                label.numberOfLines = 0
                
                superView.addSubview(label)
                label.snp.makeConstraints {
                    $0.edges.equalToSuperview().inset(20)
                }
                
            }
        }
    }
    
    private func makeTextFieldContentsView() -> UIView {
        return UIView().do { superView in
            UITextField().do { textField in
                textField.borderStyle = .roundedRect
                textField.placeholder = "검색어를 입력해주세요."
                textField.font = .systemFont(ofSize: 15, weight: .regular)
                
                superView.addSubview(textField)
                textField.snp.makeConstraints {
                    $0.height.equalTo(48)
                    $0.top.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
            }
        }
    }
    
    private func makeButtonContentsView() -> UIView {
        return UIView().do { superView in
            UIStackView().do { hStack in
                hStack.axis = .horizontal
                hStack.spacing = 8
                hStack.distribution = .fillEqually
                
                superView.addSubview(hStack)
                hStack.snp.makeConstraints {
                    $0.height.equalTo(56)
                    $0.top.bottom.equalToSuperview()
                    $0.leading.trailing.equalToSuperview().inset(20)
                }
                
                UIButton().do {
                    $0.layer.cornerRadius = 6
                    $0.setTitle("확인", for: .normal)
                    $0.setTitleColor(.black, for: .normal)
                    $0.backgroundColor = .gray
                    
                    hStack.addArrangedSubview($0)
                }
                
                UIButton().do {
                    $0.layer.cornerRadius = 6
                    $0.setTitle("닫기", for: .normal)
                    $0.setTitleColor(.black, for: .normal)
                    $0.backgroundColor = .gray
                    
                    hStack.addArrangedSubview($0)
                }
            }
        }
    }
    
    private func makeCarouselContentsView() -> UIView {
        return UIView().do { superView in
            superView.snp.makeConstraints {
                $0.height.equalTo(80)
            }
            
            let carouselView = CarouselView()
            superView.addSubview(carouselView)
            carouselView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            carouselView.startScrolling()
        }
    }
    
    
    // MARK: makeEvents
    
    private func makeEvents() {
     // 각종 이벤트 바인딩
    }
}
