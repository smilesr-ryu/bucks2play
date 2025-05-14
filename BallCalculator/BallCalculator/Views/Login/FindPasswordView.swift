//
//  FindPasswordView.swift
//  BallCalculator
//
//  Created by Yunki on 5/14/25.
//

import SwiftUI

struct FindPasswordView: View {
    @State var id: String = ""
    @State var email: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "비밀번호 찾기",
                back: {
                    
                })
            
            FormTextField(
                prompt: "아이디 입력",
                text: $id,
                title: { Text("아이디") }
            )
            
            FormTextField(
                prompt: "이메일 입력",
                text: $email,
                title: { Text("이메일") },
                trailing: { RoundedButton("인증요청", action: {}) }
            )
            
            FormTextField(
                prompt: "인증번호 입력",
                text: $password,
                title: { Text("인증번호") },
                rightIcon: { Image(.eye18) }
            )
            
            BasicButton("비밀번호 찾기", type: .primary, isEnabled: true) {
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Spacer()
        }
    }
}

#Preview {
    FindPasswordView()
}
