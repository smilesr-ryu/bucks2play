//
//  FindAccountView.swift
//  BallCalculator
//
//  Created by Yunki on 6/5/25.
//

import SwiftUI
import FirebaseAuth

struct FindAccountView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var popupManager = PopupManager.shared
    
    @State var email: String = ""
    
    @State private var userId: String?
    @State private var isLoading: Bool = false
    
    private var isValidEmail: Bool {
        guard email.range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil else { return false }
        return true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "내 계정 찾기",
                back: {
                    dismiss()
                })
            
            if let userId {
                Text("가입한 아이디를 찾았어요!")
                    .fontStyle(.headline1_R)
                    .foregroundStyle(.black01)
                    .padding(.top, 32)
                
                Text(userId)
                    .fontStyle(.headline2_B)
                    .foregroundStyle(.black01)
                    .padding(.top, 48)
                
                BasicButton("로그인", type: .primary) {
                    dismiss()
                }
                .padding(.top, 64)
                .padding(.horizontal, 20)
                
                NavigationLink {
                    FindPasswordView()
                } label: {
                    Text("비밀번호를 잊어버렸나요?")
                        .fontStyle(.label1_R)
                        .foregroundStyle(.black01)
                        .padding(.vertical, 15)
                }
            } else {
                FormTextField(
                    prompt: "이메일 입력",
                    text: $email,
                    title: { Text("이메일") }
                )
                
                BasicButton("내 계정 찾기", type: .primary, isEnabled: isValidEmail && !isLoading) {
                    findAccount()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            Spacer()
        }
        .toolbar(.hidden)
        .onChange(of: email) { _, newEmail in
            // 이메일이 변경되면 인증 상태 초기화
            if !newEmail.isEmpty {
            }
        }
    }
    
    private func findAccount() {
        isLoading = true
        
        print("🔍 계정 찾기 시작: \(email)")
        
        Task {
            do {
                // AuthManager를 통해 이메일로 사용자 ID 찾기
                let foundUserId = try await AuthManager.shared.findUserIdByEmail(email)
                
                await MainActor.run {
                    isLoading = false
                    
                    if let foundUserId = foundUserId {
                        print("✅ 계정 찾기 성공: \(foundUserId)")
                        self.userId = foundUserId
                    } else {
                        print("❌ 계정을 찾을 수 없음")
                        popupManager.activePopup = .unregisteredAccount
                    }
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    popupManager.activePopup = .unregisteredAccount
                }
            }
        }
    }
}

#Preview {
    FindAccountView()
}
