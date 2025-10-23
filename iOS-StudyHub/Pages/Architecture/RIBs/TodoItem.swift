//
//  TodoItem.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/4/25.
//

import Foundation

// MARK: - Models

struct TodoItem {
    let id: String
    var title: String
    var isCompleted: Bool
    
    init(title: String) {
        self.id = UUID().uuidString
        self.title = title
        self.isCompleted = false
    }
}
