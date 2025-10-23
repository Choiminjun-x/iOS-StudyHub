//
//  UserProfileView.swift
//  iOS-StudyHub
//
//  Created by 최민준(Minjun Choi) on 9/1/25.
//

import SwiftUI

struct User {
    let id: Int
    let name: String
    let email: String
    let profileImageURL: String?
}

class UserViewModel: ObservableObject {
    /**
     @Published 값 변경 -> View 재렌더링
     */
    @Published var user: User?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init() {
        self.loadUserData()
    }
    
    // 실제 서버 통신이 완료된 상황을 시뮬레이션
    func loadUserData() {
        self.isLoading = true
        self.errorMessage = nil
        
        // // API 응답 시뮬레이션 (성공 케이스)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            let fetchedUser = User(
                id: 12345,
                name: "최민준",
                email: "mj.choi7180@gmail.com",
                profileImageURL: "https://example.com/profile.jpg"
            )
            
            self?.user = fetchedUser  // ← 이 순간 SwiftUI View가 사용자 정보 표시로 변경됨
            self?.isLoading = false
        }
    }
    
    // 사용자 정보 업데이트 (PUT API 호출 완료된 상황)
    func updateUserProfile(newName: String, newEmail: String) {
        guard let currentUser = user else { return }
        
        self.isLoading = true
        
        // 실제 API 업데이트 호출 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            // 서버 응답으로 업데이트된 사용자 정보 받음
            let updatedUser = User(
                id: currentUser.id,
                name: newName,
                email: newEmail,
                profileImageURL: currentUser.profileImageURL
            )
            
            self?.user = updatedUser
            self?.isLoading = false
        }
    }
    
    // 에러 상황 시뮬레이션
    func simulateNetworkError() {
        self.isLoading = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
            self?.errorMessage = "네트워크 연결을 확인해주세요."
        }
    }
}


// MARK: - SwiftUI View (데이터 통신 결과를 표시)
struct UserProfileView: View {
    /**
     StateObject -> 이 객체의 변화를 "구독"
     */
    @StateObject private var viewModel = UserViewModel()
    
    @State private var isEditMode = false
    @State private var editName = ""
    @State private var editEmail = ""
    
    var body: some View {
        VStack(spacing: 20) {
            // viewModel의 @Published 값에 따라 조건부 렌더링
            if self.viewModel.isLoading {
                // 로딩 상태
                ProgressView("사용자 정보 로딩 중...")
                    .progressViewStyle(CircularProgressViewStyle())
            } else if let errorMessage = self.viewModel.errorMessage {
                self.errorModeView(errorMessage: errorMessage)
            } else if let user = self.viewModel.user {
                // 데이터 로드 완료 상태
                if self.isEditMode {
                    self.editModeView(user: user)
                        .onAppear { print("로딩 뷰 표시됨") }
                } else {
                    self.displayModeView(user: user)
                        .onAppear { print("사용자 정보 뷰 표시됨") }
                }
            } else {
                // 초기 상태
                Text("사용자 정보가 없습니다.")
                    .foregroundColor(.gray)
                    .onAppear { print("빈 상태 뷰 표시됨") }
            }
        }
        .padding()
        .animation(.easeInOut, value: self.viewModel.isLoading) // isLoading 값이 변경될 때마다 애니메이션 효과 발생
    }
    
    // 표시 모드 뷰
    @ViewBuilder
    private func displayModeView(user: User) -> some View {
        VStack(spacing: 15) {
            // 프로필 이미지 (실제로는 AsyncImage 사용 가능)
            Image(systemName: "person.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            // 사용자 정보 표시
            Text(user.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            // 액션 버튼들
            HStack(spacing: 20) {
                Button("프로필 수정") {
                    self.editName = user.name
                    self.editEmail = user.email
                    self.isEditMode = true
                }
                .buttonStyle(.plain)
                
                Button("새로고침") {
                    self.viewModel.loadUserData()
                }
                .buttonStyle(.plain)
                
                Button("에러 테스트") {
                    self.viewModel.simulateNetworkError()
                }
                .buttonStyle(.plain)
                .foregroundColor(.red)
            }
        }
    }
    
    // 수정 모드 뷰
    @ViewBuilder
    private func editModeView(user: User) -> some View {
        VStack(spacing: 15) {
            Text("프로필 수정")
                .font(.title2)
                .fontWeight(.bold)
            
            TextField("이름", text: $editName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("이메일", text: $editEmail)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            HStack(spacing: 20) {
                Button("취소") {
                    self.isEditMode = false
                }
                .buttonStyle(.plain)
                
                Button("저장") {
                    self.viewModel.updateUserProfile(newName: self.editName, newEmail: self.editEmail)
                    self.isEditMode = false
                }
                .buttonStyle(.plain)
                .disabled(self.editName.isEmpty || self.editEmail.isEmpty)
            }
        }
    }
    
    // 에러 상태
    @ViewBuilder
    private func errorModeView(errorMessage: String) -> some View {
        VStack(spacing: 15) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            Text(errorMessage)
                .foregroundColor(.red)
            Button("다시 시도") {
                self.viewModel.loadUserData()
            }
            .buttonStyle(.plain)
        }
    }
}
