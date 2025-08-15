//
//  FindPasswordView.swift
//  BallCalculator
//
//  Created by Yunki on 5/14/25.
//

import SwiftUI
import FirebaseAuth

struct FindPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var popupManager = PopupManager.shared
    
    @State var id: String = ""
    @State var email: String = ""
    
    private var isValidEmail: Bool {
        guard email.range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil else { return false }
        return true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(
                title: "비밀번호 찾기",
                back: {
                    dismiss()
                })
            
            FormTextField(
                prompt: "아이디 입력",
                text: $id,
                title: { Text("아이디") }
            )
            
            FormTextField(
                prompt: "이메일 입력",
                text: $email,
                title: { Text("이메일") }
            )
            
            BasicButton("비밀번호 찾기", type: .primary, isEnabled: !id.isEmpty && isValidEmail) {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                    if error != nil {
                        popupManager.activePopup = .unregisteredAccount
                    } else {
                        popupManager.toast = .passwordChanged
                        dismiss()
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            Spacer()
        }
        .toolbar(.hidden)
    }
}

#Preview {
    FindPasswordView()
}
