//
//  TodoItemViewModel.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import UIKit

struct TodoItemViewModel {
    let title: String
    let isCompleted: Bool
    let displayTitle: String
    let checkButtonTitle: String
    let titleColor: UIColor
    let titleAlpha: CGFloat
    
    init(from todoItem: TodoItem) {
        self.title = todoItem.title
        self.isCompleted = todoItem.isCompleted
        self.displayTitle = todoItem.title
        self.checkButtonTitle = todoItem.isCompleted ? "✓" : "○"
        self.titleColor = todoItem.isCompleted ? .systemGray : .label
        self.titleAlpha = todoItem.isCompleted ? 0.6 : 1.0
    }
}
