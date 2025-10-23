//
//  TodoListPresenter.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import Foundation

// Presenter가 Interactor로부터 받는 데이터
protocol TodoListPresentable: AnyObject {
    func presentTodos(_ todos: [TodoItem])
}

class TodoListPresenter: TodoListPresentable {
    
    private weak var viewController: TodoListViewControllable?
    
    init(viewController: TodoListViewControllable) {
        self.viewController = viewController
    }
    
    // Interactor로부터 받은 비즈니스 데이터를 View용 ViewModel로 변환
    func presentTodos(_ todos: [TodoItem]) {
        let viewModels = todos.map { TodoItemViewModel(from: $0) }
        
        // 메인 스레드에서 View 업데이트
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.displayTodos(viewModels)
        }
    }
}
