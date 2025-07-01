//
//  SignInView.swift
//  BallCalculator
//
//  Created by Yunki on 5/13/25.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var id: String = ""
    @State var password: String = ""
    @State var isSecured: Bool = true
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    var authManager: AuthManager = .shared
    var sheetManager: SheetManager = .shared
    
    var body: some View {
        VStack(spacing: 0) {
//            TopBar(
//                title: "아이디로 시작하기",
//                back: {
//                    dismiss()
//                })
            
            FormTextField(
                prompt: "아이디 입력",
                text: $id,
                title: { Text("아이디") }
            )
            
            FormTextField(
                prompt: "비밀번호 입력",
                text: $password,
                isSecure: isSecured,
                title: { Text("비밀번호") },
                rightIcon: {
                    Button {
                        isSecured.toggle()
                    } label: {
                        if isSecured {
                            Image(.eyeOff18)
                        } else {
                            Image(.eye18)
                        }
                    }
                }
            )
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .fontStyle(.caption1_R)
                    .foregroundStyle(.red)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
            }
            
            BasicButton(
                "로그인",
                type: .primary,
                isEnabled: !id.isEmpty && !password.isEmpty && !isLoading
            ) {
                performSignIn()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack {
                NavigationLink {
                    FindAccountView()
                } label: {
                    Text("내 계정 찾기")
                        .fontStyle(.label1_R)
                        .foregroundStyle(.black01)
                        .underline()
                }
                
                Rectangle()
                    .frame(width: 1, height: 12)
                    .foregroundStyle(.black02)
                
                NavigationLink {
                    FindPasswordView()
                } label: {
                    Text("비밀번호 찾기")
                        .fontStyle(.label1_R)
                        .foregroundStyle(.black01)
                        .underline()
                }
                
                Rectangle()
                    .frame(width: 1, height: 12)
                    .foregroundStyle(.black02)
                
                NavigationLink {
                    SignUpView()
                } label: {
                    Text("회원가입")
                        .fontStyle(.label1_R)
                        .foregroundStyle(.black01)
                        .underline()
                }
            }
            
            Spacer()
        }
        .toolbar(.hidden)
    }
    
    private func performSignIn() {
        isLoading = true
        errorMessage = ""
        
        authManager.signinWithCompletion(id: id, password: password) { result in
            isLoading = false
            
            switch result {
            case .success:
                sheetManager.loginSheetIsPresented = false
            case .failure(let error):
                if let authError = error as? AuthError {
                    errorMessage = authError.errorDescription ?? "로그인에 실패했습니다."
                } else {
                    errorMessage = error.localizedDescription
                }
            }
        }
    }
}

#Preview {
    SignInView()
}
