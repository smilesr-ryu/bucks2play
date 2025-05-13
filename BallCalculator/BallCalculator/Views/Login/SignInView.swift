//
//  SignInView.swift
//  BallCalculator
//
//  Created by Yunki on 5/13/25.
//

import SwiftUI

struct SignInView: View {
    @State var id: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "아이디로 시작하기",
                back: {
                    
                })
            
            FormTextField(
                title: "아이디",
                prompt: "아이디 입력",
                text: $id
            )
            
            FormTextField(
                title: "비밀번호",
                prompt: "비밀번호 입력",
                text: $password,
                rightIcon: { Image(.eye18) }
            )
            
            BasicButton("로그인", type: .primary, isEnabled: !id.isEmpty && !password.isEmpty) {
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack {
                Text("내 계정 찾기")
                    .fontStyle(.label1_R)
                
                Rectangle()
                    .frame(width: 1, height: 12)
                    .foregroundStyle(.black02)
                
                Text("비밀번호 찾기")
                    .fontStyle(.label1_R)
                
                Rectangle()
                    .frame(width: 1, height: 12)
                    .foregroundStyle(.black02)
                
                Text("회원가입")
                    .fontStyle(.label1_R)
            }
            
            Spacer()
        }
    }
}

#Preview {
    SignInView()
}
