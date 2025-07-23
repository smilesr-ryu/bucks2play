//
//  LoginView.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                TopBar(close:  {
                    dismiss()
                })
                
                LottieView(name: "login", loopMode: .loop)
                    .frame(height: 146)
                    .padding(.top, 40)
                
                Spacer()
                
                SignInView()
                    .padding(.horizontal, 20)
                    .padding(.bottom, 118)
            }
        }
    }
}

#Preview {
    LoginView()
}
