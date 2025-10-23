//
//  TodoListRouter.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import UIKit


protocol TodoListRouting {
    var viewControllable: ViewControllable { get }
    
    func routeToAddTodo()
    func routeToDetail()
}

class TodoListRouter: TodoListRouting {
    
    private let interactor: TodoListInteractable
    var viewControllable: ViewControllable
    
    init(viewControllable: ViewControllable, interactor: TodoListInteractable) {
        self.viewControllable = viewControllable
        self.interactor = interactor
    }
    
    func routeToAddTodo() {
        let alertController = UIAlertController(title: "새 할 일", message: "할 일을 입력하세요", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "할 일 입력"
        }
        
        let addAction = UIAlertAction(title: "추가", style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let text = textField.text,
                  !text.isEmpty else { return }
            self?.interactor.addTodo(title: text)
        }
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        self.viewControllable
            .viewController
            .present(alertController, animated: true)
    }
    
    func routeToDetail() {
        
    }
}
