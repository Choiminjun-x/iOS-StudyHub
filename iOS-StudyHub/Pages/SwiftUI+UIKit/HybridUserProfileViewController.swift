//
//  HostingViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/1/25.
//

import UIKit
import SwiftUI
import SnapKit

class HybridUserProfileViewController: UIViewController {
    
    private var profileView: UserProfileView!
    private var hostingController: UIHostingController<UserProfileView>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.setupSwiftUIView()
        self.setupNavigationBar()
    }
    
    private func setupSwiftUIView() {
        self.profileView = UserProfileView()
        self.hostingController = UIHostingController(rootView: self.profileView)
        
        // 1. addChild() - 부모-자식 관계 설정 시작
        self.addChild(self.hostingController)
        /**
         - hostingController를 현재 ViewController의 자식으로 등록
         - 이 시점에서 hostingController.parent는 self(HostingViewController)가 됨
         - 메모리 관리와 생명주기 이벤트 전달을 위한 관계 설정
         - 아직 화면에는 표시되지 않음 (View hierarchy에 추가 전)
         */
        
        // 2. addSubview() - 실제 View를 화면에 추가
        self.view.addSubview(self.hostingController.view)
        /**
         - hostingController의 view를 현재 ViewController의 view에 서브뷰로 추가
         - 이제 실제로 화면에 SwiftUI 내용이 표시됨
         - 하지만 아직 부모-자식 관계 설정이 완료되지 않은 상태
         */
        
        
        // 3. didMove(toParent:) - 부모-자식 관계 설정 완료
        self.hostingController.didMove(toParent: self)
        /**
         - 자식 ViewController에게 부모로 이동 완료되었음을 알림
         - 이 메서드 호출로 정식으로 부모-자식 관계가 완성됨
         - hostingController 내부에서 필요한 초기화나 설정 작업이 수행됨
         - viewDidAppear, viewWillDisappear 등의 생명주기 이벤트가 제대로 전달됨
         */
        
        // Auto Layout 설정
        self.hostingController.view.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.view.safeAreaLayoutGuide)
            $0.height.equalTo(300)
        }
    }
    
    private func setupNavigationBar() {
        title = "사용자 프로필"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "새로고침",
            style: .plain,
            target: self,
            action: #selector(self.refreshButtonTapped)
        )
    }
    
    @objc private func refreshButtonTapped() {
        // SwiftUI의 ViewModel에 직접 접근해서 데이터 새로고침
        // 실제로는 현재 표시된 사용자 ID로 다시 로드
        self.loadSpecificUser(userId: 12345)
    }
    
    // 특정 사용자 데이터 로드 (실제 API 호출 시뮬레이션)
    private func loadSpecificUser(userId: Int) {
        // 실제로는 여기서 API 호출을 하고
        // 완료되면 SwiftUI View의 ViewModel을 업데이트
        print("사용자 ID \(userId)의 정보를 로드 중...")
        
        // API 호출 완료 후 데이터 업데이트는
        // UserViewModel의 loadUserData()에서 자동으로 처리됨
    }
}
