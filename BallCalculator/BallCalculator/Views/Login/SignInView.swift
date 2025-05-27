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
    
    var authManager: AuthManager = .shared
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "아이디로 시작하기",
                back: {
                    dismiss()
                })
            
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
            
            BasicButton(
                "로그인",
                type: .primary,
                isEnabled: !id.isEmpty && !password.isEmpty
            ) {
                authManager.signin(id: id, password: password)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack {
                Text("내 계정 찾기")
                    .fontStyle(.label1_R)
                    .underline()
                
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
}

#Preview {
    SignInView()
}
