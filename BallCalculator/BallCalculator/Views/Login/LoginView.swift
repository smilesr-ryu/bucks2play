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
            HStack {
                Spacer()
                Text("X")
            }
            
            LottieView(name: "login", loopMode: .loop)
                .frame(height: 146)
            
            SignInWithAppleButtonView()
            
            HStack {
                Text("내 계정 찾기")
                Text("|")
                Text("아이디로 시작하기")
            }
        }
    }
}

#Preview {
    LoginView()
}
