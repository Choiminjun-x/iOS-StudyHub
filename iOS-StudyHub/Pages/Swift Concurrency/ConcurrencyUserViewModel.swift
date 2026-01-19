//
//  ConcurrencyUserViewModel.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 1/19/26.
//

import UIKit

@MainActor
final class ConcurrencyUserViewModel {
    
    private let userService = ConcurrencyUserService()
    private var loadTask: Task<Void, Never>?
    
    var users = [ConcurrencyUser]()
    var isLoading: Bool = false
    var errorMessage: String?
    
    func loadUsers(update: @escaping () -> Void) {
        self.isLoading = true
        update()
        
        self.loadTask?.cancel()
        self.loadTask = Task {
            do {
                let fetched = try await userService.fetchMultipleUses(ids: [1, 2, 3, 4])
                self.users = fetched
                self.errorMessage = nil
            } catch is CancellationError {
                self.errorMessage = "요청이 취소됨"
            } catch {
                self.errorMessage = error.localizedDescription
            }
            
            self.isLoading = false
            update()
        }
    }
    
    func cancelLoading(update: @escaping () -> Void) {
        self.loadTask?.cancel()
        self.errorMessage = "사용자가 요청을 취소함"
        self.isLoading = false
        update()
    }
}
