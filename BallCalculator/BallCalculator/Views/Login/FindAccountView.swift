//
//  FindAccountView.swift
//  BallCalculator
//
//  Created by Yunki on 6/5/25.
//

import SwiftUI

struct FindAccountView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var id: String = ""
    @State var email: String = ""
    @State var verifyCode: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "내 계정 찾기",
                back: {
                    dismiss()
                })
            
            FormTextField(
                prompt: "이메일 입력",
                text: $email,
                title: { Text("이메일") },
                trailing: { RoundedButton("인증요청", action: {}) }
            )
            
            FormTextField(
                prompt: "인증번호 입력",
                text: $verifyCode,
                title: { Text("인증번호") }
            )
            
            BasicButton("내 계정 찾기", type: .primary, isEnabled: verifyCode.count == 6) {
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

#Preview {
    FindAccountView()
}
