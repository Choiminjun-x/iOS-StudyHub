//
//  ListCell.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 7/25/25.
//

import UIKit
import SnapKit

struct ListCellModel {
    var isImmutable: Bool = false
    var name: String?
}

class ListCell: UICollectionViewCell {
    
    private var contentsContainer: UIView!
    private var nameLabel: UILabel!
    private var rightImageView: UIImageView!
    
    var contentsContainerFrame: CGRect {
        return self.contentsContainer.frame
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.nameLabel.text = nil
        self.rightImageView.image = nil
    }
    
    private func configure() {
        self.contentsContainer = UIView().do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 16
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.red.cgColor
            
            self.contentView.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(6)
                $0.leading.trailing.equalToSuperview()
            }
        }
        
        UIStackView().do { hStackView in
            hStackView.axis = .horizontal
            hStackView.alignment = .center
            hStackView.spacing = 8
            
            self.contentsContainer.addSubview(hStackView)
            hStackView.snp.makeConstraints {
                $0.top.bottom.equalToSuperview().inset(20)
                $0.leading.trailing.equalToSuperview().inset(16)
            }
            
            UIStackView().do { vStackView in
                vStackView.axis = .vertical
                vStackView.spacing = 4
                
                hStackView.addArrangedSubview(vStackView)
                
                self.nameLabel = UILabel().do {
                    $0.numberOfLines = 0
                    $0.font = .systemFont(ofSize: 16, weight: .regular)
                    $0.textColor = .black
                    $0.setContentHuggingPriority(.required, for: .vertical)
                    
                    vStackView.addArrangedSubview($0)
                }
            }
            
            UIView().do { imageContainer in
                hStackView.addArrangedSubview(imageContainer)
                
                self.rightImageView = UIImageView().do {
                    $0.image = UIImage(systemName: "line.3.horizontal")
                    
                    imageContainer.addSubview($0)
                    $0.snp.makeConstraints {
                        $0.leading.equalToSuperview().inset(16)
                        $0.trailing.equalToSuperview()
                        $0.height.width.equalTo(24)
                        $0.centerY.equalToSuperview()
                    }
                }
            }
        }
    }
    
    func displayCell(cellModel: ListCellModel) {
        self.contentsContainer.do {
            $0.layer.borderColor = cellModel.isImmutable ? UIColor.blue.cgColor : UIColor.gray.cgColor
        }
        
        self.rightImageView.do {
            $0.image = UIImage(systemName: cellModel.isImmutable ? "pin.fill" : "line.3.horizontal")
            $0.snp.updateConstraints {
                $0.height.width.equalTo(cellModel.isImmutable ? 16 : 24)
            }
        }
        
        self.nameLabel.text = cellModel.name
    }
}
