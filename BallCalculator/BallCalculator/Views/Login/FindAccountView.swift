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
    @State private var isEmailVerified: Bool = false
    @State private var isEmailVerifying: Bool = false
    @State private var isLoading: Bool = false
    
    // 앱 상태 변화 감지를 위한 변수
    @Environment(\.scenePhase) private var scenePhase
    
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
                
                Text("비밀번호를 잊어버렸나요?")
                    .fontStyle(.label1_R)
                    .foregroundStyle(.black01)
                    .padding(.vertical, 15)
            } else {
                FormTextField(
                    prompt: "이메일 입력",
                    text: $email,
                    title: { Text("이메일") },
                    trailing: {
                        if isEmailVerified {
                            RoundedButton(
                                "인증 완료",
                                isEnabled: false,
                                action: { }
                            )
                        } else {
                            RoundedButton(
                                isEmailVerifying
                                ? "인증중..."
                                : "인증 요청",
                                isEnabled: isValidEmail && !isEmailVerifying,
                                action: {
                                    requestEmailVerification()
                                }
                            )
                        }
                    }
                )
                
                BasicButton("내 계정 찾기", type: .primary, isEnabled: isEmailVerified && !isLoading) {
                    findAccount()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            Spacer()
        }
        .toolbar(.hidden)
        .onChange(of: scenePhase) { _, newPhase in
            Task {
                await checkEmailVerificationManually()
            }
        }
        .onChange(of: email) { _, newEmail in
            // 이메일이 변경되면 인증 상태 초기화
            if !newEmail.isEmpty {
                isEmailVerified = false
                isEmailVerifying = false
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 임시 계정 정리 (인증이 완료되지 않은 경우)
            if !isEmailVerified {
                Task {
                    if let currentUser = Auth.auth().currentUser, currentUser.email == email {
                        try? await currentUser.delete()
                        print("🗑️ 미완료 이메일 인증 계정 삭제")
                    }
                }
            }
        }
    }
    
    private func requestEmailVerification() {
        isEmailVerifying = true
        
        print("📧 이메일 인증 요청 시작: \(email)")
        
        // 임시 Firebase Auth 계정 생성
        Task {
            do {
                // 임시 비밀번호 생성
                let tempPassword = "Temp\(UUID().uuidString.prefix(8))"
                print("🔑 임시 비밀번호 생성: \(tempPassword)")
                
                // Firebase Auth로 계정 생성
                print("👤 Firebase Auth 계정 생성 시작")
                let authResult = try await Auth.auth().createUser(withEmail: email, password: tempPassword)
                print("✅ Firebase Auth 계정 생성 완료: \(authResult.user.uid)")
                
                // 이메일 인증 메일 전송
                print("📤 이메일 인증 메일 전송 시작")
                try await authResult.user.sendEmailVerification()
                print("✅ 이메일 인증 메일 전송 완료")
                
                await MainActor.run {
                    print("📱 UI 업데이트 완료: 인증 메일 전송 성공")
                }
                
            } catch {
                print("❌ 이메일 인증 요청 실패: \(error)")
                await MainActor.run {
                    isEmailVerifying = false
                    if let error = error as NSError? {
                        print("🔍 에러 코드: \(error.code)")
                        switch error.code {
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            popupManager.activePopup = .unregisteredAccount
                        case AuthErrorCode.invalidEmail.rawValue:
                            popupManager.activePopup = .unregisteredAccount
                        default:
                            popupManager.activePopup = .unregisteredAccount
                        }
                    } else {
                        popupManager.activePopup = .unregisteredAccount
                    }
                }
            }
        }
    }
    
    private func checkEmailVerificationManually() async {
        print("🔍 이메일 인증 수동 확인 시작")
        
        guard let user = Auth.auth().currentUser else {
            print("❌ 현재 로그인된 사용자 없음")
            return
        }
        
        do {
            // 사용자 정보 새로고침
            print("🔄 사용자 정보 새로고침 시작")
            try await user.reload()
            print("✅ 사용자 정보 새로고침 완료")
            
            if user.isEmailVerified {
                print("✅ 이메일 인증 완료됨")
                await MainActor.run {
                    isEmailVerified = true
                    isEmailVerifying = false
                }
            } else {
                print("❌ 아직 인증되지 않음")
            }
        } catch {
            print("❌ 사용자 정보 새로고침 실패: \(error)")
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
