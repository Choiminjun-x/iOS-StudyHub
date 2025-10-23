//
//  MainViewController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/2/25.
//

import UIKit
import SnapKit
//import ComposableArchitecture

class MainViewController: UIViewController {
    
    private var titleLabel: UILabel!
    private var subTitleLabel: UILabel!
    private var tableView: UITableView!
    private var headerView: UIView!
    
    // 학습 목차 데이터
    private let studyMenuItems: [StudyMenuItem] = [
        // SwiftUI + UIKit
        StudyMenuItem(
            title: "실시간 데이터 대시보드",
            description: "SwiftUI + UIKit 하이브리드 실시간 대시보드 구현",
            category: .swiftUI,
            viewController: HybridDashboardViewController()
        ),
        StudyMenuItem(
            title: "사용자 프로필 (하이브리드)",
            description: "SwiftUI + UIKit 하이브리드 사용자 프로필 화면",
            category: .swiftUI,
            viewController: HybridUserProfileViewController()
        ),
        // UIKit
        StudyMenuItem(
            title: "UICollectionView 기반 ListOrdering",
            description: "드래그 앤 드롭으로 아이템 순서 변경 및 상태 저장 기능 구현",
            category: .uikit,
            viewController: ListOrderingViewController()
        ),
        StudyMenuItem(
            title: "Carousel",
            description: "Carousel - 무한 스크롤 기능 구현",
            category: .uikit,
            viewController: UIComponentsDemoViewController()
        ),
        StudyMenuItem(
            title: "Image Cache",
            description: "Image Cache 기능 구현",
            category: .uikit,
            viewController: ImageCacheTestViewController()
        ),
        // Media & Camera
        StudyMenuItem(
            title: "AVFoundation Barcode Scanner",
            description: "실시간 카메라 스캔으로 QR코드/바코드 인식 및 데이터 처리",
            category: .media,
            viewController: BarcodeViewController()
        ),
        // Web & Browser
        StudyMenuItem(
            title: "WKWebView 기본 구현",
            description: "커스텀 웹뷰 구현과 JavaScript 상호작용",
            category: .web,
            viewController: SimpleWebViewController()
        ),
        StudyMenuItem(
            title: "SFSafariViewController 기본 구현",
            description: "인앱 브라우저 기본 구현",
            category: .web,
            viewController: SFSafariWebViewController()
        ),
        // Architecture
        StudyMenuItem(
            title: "RIBs Todo List",
            description: "RIBs 아키텍처 샘플 - Todo List",
            category: .architecture,
            viewController: TodoListBuilder().build().viewControllable.viewController
        )
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation()
        self.setupUI()
    }
    
    private func setupNavigation() {
        // 네비게이션 바를 투명하게 만들고 타이틀 숨김
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.backButtonTitle = ""
    }
    
    private func setupUI() {
        self.view.do { superView in
            superView.backgroundColor = .systemGroupedBackground
            
            self.headerView = UIView().do { headerView in
                headerView.backgroundColor = .clear
                
                superView.addSubview(headerView)
                headerView.snp.makeConstraints {
                    $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                    $0.leading.trailing.equalToSuperview()
                    $0.height.equalTo(100)
                }
                
                UIStackView().do { vStack in
                    vStack.axis = .vertical
                    vStack.spacing = 4
                    
                    headerView.addSubview(vStack)
                    vStack.snp.makeConstraints {
                        $0.top.bottom.leading.trailing.equalToSuperview().inset(20)
                    }
                    
                    self.titleLabel = UILabel().do {
                        $0.text = "iOS StudyHub"
                        $0.font = .systemFont(ofSize: 32, weight: .bold)
                        $0.textColor = .label
                        
                        vStack.addArrangedSubview($0)
                    }
                    
                    self.subTitleLabel = UILabel().do {
                        $0.text = "iOS 학습 예제"
                        $0.font = .systemFont(ofSize: 16, weight: .regular)
                        $0.textColor = .secondaryLabel
                        
                        vStack.addArrangedSubview($0)
                    }
                }
            }
            
            self.tableView = UITableView().do {
                $0.delegate = self
                $0.dataSource = self
                $0.backgroundColor = .clear
                $0.separatorStyle = .none
                $0.showsVerticalScrollIndicator = false
                // 셀 등록
                $0.register(StudyMenuTableViewCell.self, forCellReuseIdentifier: StudyMenuTableViewCell.identifier)
                
                superView.addSubview($0)
                $0.snp.makeConstraints {
                    $0.top.equalTo(headerView.snp.bottom)
                    $0.leading.trailing.bottom.equalToSuperview()
                }
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.studyMenuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StudyMenuTableViewCell.identifier, for: indexPath) as? StudyMenuTableViewCell else {
            return UITableViewCell()
        }
        
        let item = self.studyMenuItems[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.studyMenuItems[indexPath.row]
        let viewController = item.viewController
        viewController.title = item.title
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController {
    
    /// 네비게이션 컨트롤러로 감싸서 반환하는 편의 메서드
    static func withNavigationController() -> UINavigationController {
        let mainViewController = MainViewController()
        let navigationController = UINavigationController(rootViewController: mainViewController)
        
        // 네비게이션 바 스타일 설정
        navigationController.navigationBar.prefersLargeTitles = false
        navigationController.navigationBar.tintColor = .systemBlue
        
        return navigationController
    }
}
