//
//  LoginView.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        VStack {
            TopBar(close: {})
            
            LottieView(name: "login", loopMode: .loop)
                .frame(height: 146)
                .padding(.top, 40)
            
            Spacer()
            
            VStack(spacing: 24) {
                VStack(spacing: 11) {
                    SignInWithAppleButtonView()
                }
                
                HStack {
                    Text("내 계정 찾기")
                        .fontStyle(.label1_R)
                    
                    Rectangle()
                        .frame(width: 1, height: 12)
                        .foregroundStyle(.black02)
                    
                    Text("아이디로 시작하기")
                        .fontStyle(.label1_R)
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 118)
        }
    }
}

#Preview {
    LoginView()
}
