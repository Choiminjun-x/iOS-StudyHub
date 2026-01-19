//
//  ConcurrencyUserService.swift
//  iOS-StudyHub
//
//  Created by 최민준 on 1/19/26.
//

import UIKit

final class ConcurrencyUserService {
    
    // 단일 유저 조회
    func fetchUser(id: Int)  async throws -> ConcurrencyUser {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(ConcurrencyUser.self, from: data)
    }
    
    // 다중 유저 조회
    func fetchMultipleUses(ids: [Int]) async throws -> [ConcurrencyUser] {
        try await withThrowingTaskGroup(of: ConcurrencyUser.self, body: { group in
            for id in ids {
                group.addTask {
                    if Task.isCancelled { throw CancellationError() }
                    return try await self.fetchUser(id: id)
                }
            }
            
            var results = [ConcurrencyUser]()
            for try await user in group {
                results.append(user)
            }
            
            return results
        })
    }
}
