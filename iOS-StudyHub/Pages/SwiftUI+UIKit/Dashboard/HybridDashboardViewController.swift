//
//  HybridDashboardViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 8/21/25.
//

import UIKit
import SwiftUI
import SnapKit
//import ComposableArchitecture

/// SwiftUI + UIKit 하이브리드 대시보드 뷰컨트롤러
class HybridDashboardViewController: UIViewController {
    
    // MARK: - Properties
    private var dashboardView: DashboardView!
    private var hostingController: UIHostingController<DashboardView>!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.setupSwiftUIView()
        self.setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 실시간 업데이트 시작
        if let hostingController = self.hostingController {
            // SwiftUI 뷰의 ViewModel에 접근하여 업데이트 시작
            print("대시보드 실시간 업데이트 시작")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 실시간 업데이트 중지 (메모리 절약)
        print("대시보드 실시간 업데이트 중지")
    }
    
    // MARK: - Setup Methods
    
    /// SwiftUI 뷰 설정
    private func setupSwiftUIView() {
        // SwiftUI 뷰 생성
        self.dashboardView = DashboardView()
        
        // UIHostingController로 래핑
        self.hostingController = UIHostingController(rootView: self.dashboardView)
        
        // 1. addChild() - 부모-자식 관계 설정 시작
        self.addChild(self.hostingController)
        
        // 2. addSubview() - 실제 View를 화면에 추가
        self.view.addSubview(self.hostingController.view)
        
        // 3. didMove(toParent:) - 부모-자식 관계 설정 완료
        self.hostingController.didMove(toParent: self)
        
        // Auto Layout 설정
        self.hostingController.view.snp.makeConstraints {
            $0.edges.equalTo(self.view.safeAreaLayoutGuide)
        }
    }
    
    /// 네비게이션 바 설정
    private func setupNavigationBar() {
        title = "실시간 대시보드"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "설정",
            style: .plain,
            target: self,
            action: #selector(self.settingsButtonTapped)
        )
    }
    
    // MARK: - Actions
    
    /// 새로고침 버튼 액션
    @objc private func refreshButtonTapped() {
        // SwiftUI 뷰의 ViewModel에 직접 접근해서 데이터 새로고침
        print("대시보드 데이터 새로고침 요청")
        
        // 실제로는 여기서 API 호출을 하고
        // 완료되면 SwiftUI View의 ViewModel을 업데이트
        self.simulateDataRefresh()
    }
    
    /// 설정 버튼 액션
    @objc private func settingsButtonTapped() {
        let alert = UIAlertController(
            title: "대시보드 설정",
            message: "추가 설정 옵션을 선택하세요.",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(title: "업데이트 간격 변경", style: .default) { _ in
            self.showUpdateIntervalSettings()
        })
        
        alert.addAction(UIAlertAction(title: "데이터 내보내기", style: .default) { _ in
            self.exportDashboardData()
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        // iPad에서 popover로 표시
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = self.navigationItem.leftBarButtonItem
        }
        
        self.present(alert, animated: true)
    }
    
    // MARK: - Private Methods
    
    /// 데이터 새로고침 시뮬레이션
    private func simulateDataRefresh() {
        // 로딩 인디케이터 표시
        let loadingAlert = UIAlertController(
            title: "데이터 새로고침",
            message: "최신 데이터를 가져오는 중...",
            preferredStyle: .alert
        )
        
        self.present(loadingAlert, animated: true)
        
        // 2초 후 로딩 완료
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            loadingAlert.dismiss(animated: true) {
                // 성공 알림
                let successAlert = UIAlertController(
                    title: "새로고침 완료",
                    message: "최신 데이터로 업데이트되었습니다.",
                    preferredStyle: .alert
                )
                successAlert.addAction(UIAlertAction(title: "확인", style: .default))
                self.present(successAlert, animated: true)
            }
        }
    }
    
    /// 업데이트 간격 설정
    private func showUpdateIntervalSettings() {
        let alert = UIAlertController(
            title: "업데이트 간격",
            message: "데이터 업데이트 간격을 선택하세요.",
            preferredStyle: .actionSheet
        )
        
        let intervals = [1, 2, 5, 10, 30] // 초 단위
        
        for interval in intervals {
            alert.addAction(UIAlertAction(title: "\(interval)초", style: .default) { _ in
                print("업데이트 간격을 \(interval)초로 변경")
                // 실제로는 ViewModel의 업데이트 간격을 변경
            })
        }
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        
        if let popover = alert.popoverPresentationController {
            popover.barButtonItem = self.navigationItem.leftBarButtonItem
        }
        
        self.present(alert, animated: true)
    }
    
    /// 대시보드 데이터 내보내기
    private func exportDashboardData() {
        // CSV 형태로 데이터 내보내기 시뮬레이션
        let alert = UIAlertController(
            title: "데이터 내보내기",
            message: "대시보드 데이터를 CSV 파일로 내보내시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "내보내기", style: .default) { _ in
            // 실제로는 CSV 파일 생성 및 공유
            print("대시보드 데이터 CSV 내보내기")
            
            let successAlert = UIAlertController(
                title: "내보내기 완료",
                message: "데이터가 성공적으로 내보내졌습니다.",
                preferredStyle: .alert
            )
            successAlert.addAction(UIAlertAction(title: "확인", style: .default))
            self.present(successAlert, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
}

