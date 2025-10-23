//
//  TodoListBuilder.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import Foundation

class TodoListBuilder {
    
    func build() -> TodoListRouting {
        let viewController = TodoListViewController()
        let presenter = TodoListPresenter(viewController: viewController)
        let interactor = TodoListInteractor()
        let router = TodoListRouter(viewControllable: viewController, interactor: interactor)
        
        // 의존성 주입
        interactor.presenter = presenter
        interactor.router = router
        viewController.listener = interactor
        
        return router
    }
}
