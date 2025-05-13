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
                title: "아이디",
                prompt: "아이디 입력",
                text: $id
            )
            
            FormTextField(
                title: "이메일",
                prompt: "이메일 입력",
                text: $email,
                trailing: { RoundedButton("인증요청", action: {}) }
            )
            
            FormTextField(
                title: "인증번호",
                prompt: "인증번호 입력",
                text: $password,
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
