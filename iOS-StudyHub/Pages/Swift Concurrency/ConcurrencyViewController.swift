//
//  ConcurrencyViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 1/19/26.
//

import UIKit
import SnapKit

class ConcurrencyViewController: UIViewController {
    
    private let viewModel = ConcurrencyUserViewModel()
    
    private let loadButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    private let statusLabel = UILabel()
    private let resultTextView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.makeViewLayout()
    }
    
    private func makeViewLayout() {
        self.title = "Swift Concurrency MiniApp"
        self.view.backgroundColor = .systemBackground
    
        self.loadButton.do {
            $0.setTitle("🔄 사용자 불러오기", for: .normal)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
                $0.centerX.equalToSuperview()
            }
            
            $0.addTarget(self, action: #selector(loadUsersTapped), for: .touchUpInside)
        }
        
        self.cancelButton.do {
            $0.setTitle("⛔️ 취소", for: .normal)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(loadButton.snp.bottom).offset(12)
                $0.centerX.equalToSuperview()
            }
            
            $0.addTarget(self, action: #selector(cancelTapped), for: .touchUpInside)
        }
        
        self.statusLabel.do {
            $0.textAlignment = .center
            
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(cancelButton.snp.bottom).offset(20)
                $0.centerX.equalToSuperview()
            }
        }
        
        self.resultTextView.do {
            $0.isEditable = false
            $0.font = .monospacedSystemFont(ofSize: 14, weight: .regular)
            
            self.view.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalTo(statusLabel.snp.bottom).offset(20)
                $0.leading.equalToSuperview().offset(16)
                $0.trailing.equalToSuperview().inset(16)
                $0.bottom.equalToSuperview().inset(20)
            }
        }
    }
    
    @objc private func loadUsersTapped() {
        self.viewModel.loadUsers { [weak self] in
            self?.updateUI()
        }
    }
    
    @objc private func cancelTapped() {
        self.viewModel.cancelLoading { [weak self] in
            self?.updateUI()
        }
    }
    
    private func updateUI() {
        DispatchQueue.main.async {
            if self.viewModel.isLoading {
                self.statusLabel.text = "불러오는 중..."
                self.resultTextView.text = ""
            } else if let error = self.viewModel.errorMessage {
                self.statusLabel.text = "오류 발생"
                self.resultTextView.text = error
            } else {
                self.statusLabel.text = "완료"
                let formatted = self.viewModel.users.map { "\($0.name) - \($0.email)" }.joined(separator: "\n")
                self.resultTextView.text = formatted
            }
        }
    }
}
