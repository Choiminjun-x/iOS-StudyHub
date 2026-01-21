//
//  MainTabBarController.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 1/21/26.
//

import UIKit
import SnapKit

protocol AppRootPresentableListener: AnyObject {
}


class MainTabBarController: UITabBarController, AppRootViewControllable, AppRootPresentable {
    
    var listener: AppRootPresentableListener?
    
    private var tabBarTopLine: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.setupTabs()
        self.customizeAppearance()
        self.setupTabBarTopBorderLine()
        configureNavigationBarAppearance()
    }
    
    func setViewControllers(_ viewControllers: [UIViewController]) {
        super.setViewControllers(viewControllers, animated: false)
    }
    
//    private func setupTabs() {
//        let homeVC = HomeViewController()
////        let homeVC2 = CalendarViewController()
//        let homeVC3 = HomeViewController()
//        
//        let homeNav = UINavigationController(rootViewController: homeVC)
////        let calendarNav = UINavigationController(rootViewController: homeVC2)
//        let settingsNav = UINavigationController(rootViewController: homeVC3)
//        
//        homeNav.tabBarItem = UITabBarItem(title: "홈", image: UIImage(systemName: "house"), tag: 0)
//        calendarNav.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 1)
//        settingsNav.tabBarItem = UITabBarItem(title: "설정", image: UIImage(systemName: "gearshape"), tag: 2)
//        
//        viewControllers = [homeNav, calendarNav, settingsNav]
//    }
    
    private func setupTabBarTopBorderLine() {
        self.tabBarTopLine = UIView().do {
            $0.backgroundColor = .separator
            
            tabBar.addSubview($0)
            $0.snp.makeConstraints {
                $0.top.equalToSuperview()
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(2.0 / UIScreen.main.scale) // 1pt on any screen
            }
        }
    }
  
    private func configureNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()  // 배경을 불투명하게
        appearance.backgroundColor = .green.withAlphaComponent(0.2)          // 원하는 색상
        appearance.shadowColor = .separator          // 하단 라인 (원하는 경우)

        // Title 스타일
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]

        // 적용 대상
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().tintColor = .systemBlue // 버튼 색상
    }
    
    private func customizeAppearance() {
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.backgroundColor = .systemBackground
    }
}
