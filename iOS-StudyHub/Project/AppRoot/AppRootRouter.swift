//
//  AppRootRouter.swift
//  MyRIBsApp
//
//  Created by 최민준(Minjun Choi) on 9/5/25.
//

import UIKit
import RIBs

protocol AppRootInteractable: Interactable, CalendarListener {
    var router: AppRootRouting? { get set }
    var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
    func setViewControllers(_ viewControllers: [UIViewController])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
  
    private let calendar: CalendarBuildable
    
    private var calendarRouting: ViewableRouting?
    
    init(
      interactor: AppRootInteractable,
      viewController: AppRootViewControllable,
      calendar: CalendarBuildable
    ) {
        self.calendar = calendar
        
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
    
    func attachTabs() {
        let calendarRouting = calendar.build(withListener: interactor)
        
        attachChild(calendarRouting)
        
        let calendarNav = UINavigationController(rootViewController: calendarRouting.viewControllable.uiviewController)
        calendarNav.tabBarItem = UITabBarItem(title: "캘린더", image: UIImage(systemName: "calendar"), tag: 1)
        
        let viewControllers = [
            calendarNav
        ]
        
        viewController.setViewControllers(viewControllers)
    }
}
