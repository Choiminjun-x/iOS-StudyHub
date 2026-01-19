//
//  StudyMenuTableViewCell.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/2/25.
//

import UIKit
import SnapKit

struct StudyMenuItem {
    let title: String
    let description: String
    let category: StudyCategory
    let viewController: UIViewController
    
    init(title: String, description: String, category: StudyCategory, viewController: UIViewController) {
        self.title = title
        self.description = description
        self.category = category
        self.viewController = viewController
    }
}

enum StudyCategory: String, CaseIterable {
    case uikit = "UIKit"
    case swiftUI = "SwiftUI + UIKit"
    case media = "Media & Camera"
    case web = "Web & Browser"
    case localization = "Localization & Translation"
    case architecture = "Architecture"
    case concurrency = "concurrency"
    
    var color: UIColor {
        switch self {
        case .uikit: return .systemRed
        case .swiftUI: return .systemBlue
        case .media: return .systemIndigo
        case .web: return .systemOrange
        case .localization: return .systemYellow
        case .architecture: return .systemPink
        case .concurrency: return .systemMint
        }
    }
}

class StudyMenuTableViewCell: UITableViewCell {
    
    static let identifier = "StudyMenuTableViewCell"
    
    private var categoryLabel: UILabel!
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var containerView = UIView()
    private var categoryColorView: UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        self.selectionStyle = .none
        self.backgroundColor = .clear
        
        self.contentView.do { superView in
            self.containerView.do { containerView in
                containerView.backgroundColor = .systemBackground
                containerView.layer.cornerRadius = 12
                containerView.layer.shadowColor = UIColor.black.cgColor
                containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
                containerView.layer.shadowOpacity = 0.1
                containerView.layer.shadowRadius = 4
                
                superView.addSubview(containerView)
                containerView.snp.makeConstraints {
                    $0.top.bottom.equalToSuperview().inset(8)
                    $0.leading.trailing.equalToSuperview().inset(16)
                }
                
                self.categoryColorView = UIView().do {
                    $0.layer.cornerRadius = 3
                    
                    containerView.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.width.equalTo(4)
                        $0.height.equalTo(20)
                        $0.top.leading.equalToSuperview().inset(16)
                    }
                }
                
                self.categoryLabel = UILabel().do {
                    $0.font = .systemFont(ofSize: 12, weight: .medium)
                    $0.textColor = .secondaryLabel
                    
                    containerView.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.top.equalTo(self.categoryColorView.snp.top)
                        $0.leading.equalTo(self.categoryColorView.snp.trailing).offset(12)
                    }
                }
                
                self.titleLabel = UILabel().do {
                    $0.font = .systemFont(ofSize: 16, weight: .semibold)
                    $0.textColor = .label
                    $0.numberOfLines = 1
                    
                    containerView.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.top.equalTo(self.categoryLabel.snp.bottom).offset(4)
                        $0.leading.equalTo(self.categoryLabel.snp.leading)
                        $0.trailing.equalToSuperview().inset(12)
                    }
                }
                
                self.descriptionLabel = UILabel().do {
                    $0.font = .systemFont(ofSize: 14, weight: .regular)
                    $0.textColor = .secondaryLabel
                    $0.numberOfLines = 2
                    
                    containerView.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.leading.equalTo(self.titleLabel.snp.leading)
                        $0.trailing.equalTo(self.titleLabel.snp.trailing)
                        $0.top.equalTo(self.titleLabel.snp.bottom).offset(4)
                        $0.bottom.equalToSuperview().inset(16)
                    }
                }
            }
        }
    }
    
    func configure(with item: StudyMenuItem) {
        self.categoryLabel.text = item.category.rawValue
        self.categoryColorView.backgroundColor = item.category.color
        self.titleLabel.text = item.title
        self.descriptionLabel.text = item.description
    }
}
