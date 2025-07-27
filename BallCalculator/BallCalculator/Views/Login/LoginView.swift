//
//  LoginView.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var randomTheme: Int = .random(in: 0..<3)
    
    var body: some View {
        NavigationStack {
            VStack {
                TopBar(close:  {
                    dismiss()
                })
                
                LottieView(randomNumber: randomTheme, loopMode: .loop)
                    .frame(height: 146)
                    .padding(.top, 40)
                
                Spacer()
                
                SignInView()
                    .padding(.bottom, 118)
            }
        }
    }
}

#Preview {
    LoginView()
}
