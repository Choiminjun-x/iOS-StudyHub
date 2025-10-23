//
//  TodoListInteractor.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import Foundation

protocol TodoListInteractable {
    var presenter: TodoListPresentable? { get set }
    var router: TodoListRouting? { get set }
    
    func addTodo(title: String)
    func toggleTodo(at index: Int)
    func deleteTodo(at index: Int)
}

// 사용자 Action -> Interactor 전달
protocol TodoListPresentableListener: AnyObject {
    func didTapAddTodo()
    func didToggleTodo(at index: Int)
    func didDeleteTodo(at index: Int)
}

class TodoListInteractor: TodoListInteractable {
    
    var presenter: TodoListPresentable?
    var router: TodoListRouting?
    
    private var todos: [TodoItem] = []
    
    func addTodo(title: String) {
        let newTodo = TodoItem(title: title)
        self.todos.append(newTodo)
        self.presenter?.presentTodos(todos)
    }
    
    func toggleTodo(at index: Int) {
        guard index < todos.count else { return }
        self.todos[index].isCompleted.toggle()
        self.presenter?.presentTodos(todos)
    }
    
    func deleteTodo(at index: Int) {
        guard index < todos.count else { return }
        self.todos.remove(at: index)
        self.presenter?.presentTodos(todos)
    }
}

extension TodoListInteractor: TodoListPresentableListener {
    
    func didTapAddTodo() {
        self.router?.routeToAddTodo()
    }
    
    func didToggleTodo(at index: Int) {
        self.toggleTodo(at: index)
    }
    
    func didDeleteTodo(at index: Int) {
        self.deleteTodo(at: index)
    }
}
