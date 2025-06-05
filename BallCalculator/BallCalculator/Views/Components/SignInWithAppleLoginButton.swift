//
//  SignInWithAppleLoginButton.swift
//  BallCalculator
//
//  Created by Yunki on 4/26/25.
//

import SwiftUI
import AuthenticationServices

struct SignInWithAppleButtonView: View {
    @State private var authManager = AuthManager.shared
    @State private var sheetManager = SheetManager.shared
    
    var body: some View {
        SignInWithAppleButton(.signIn, onRequest: configure, onCompletion: handle)
            .signInWithAppleButtonStyle(.black)
            .frame(height: 45)
    }

    func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                // AuthManager를 통해 Apple 로그인 처리
                authManager.signinWithApple(credential: appleIDCredential)
                sheetManager.loginSheetIsPresented = false
            }
        case .failure(let error):
            print("Apple 로그인 실패: \(error.localizedDescription)")
        }
    }
}
