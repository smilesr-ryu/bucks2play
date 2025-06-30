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
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(spacing: 8) {
            SignInWithAppleButton(.signIn, onRequest: configure, onCompletion: handle)
                .signInWithAppleButtonStyle(.black)
                .frame(height: 45)
            
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .fontStyle(.caption1_R)
                    .foregroundStyle(.red)
            }
        }
    }

    func configure(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }

    func handle(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            if let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential {
                // AuthManager를 통해 Apple 로그인 처리
                authManager.signinWithAppleWithCompletion(credential: appleIDCredential) { result in
                    switch result {
                    case .success:
                        sheetManager.loginSheetIsPresented = false
                    case .failure(let error):
                        if let authError = error as? AuthError {
                            errorMessage = authError.errorDescription ?? "Apple 로그인에 실패했습니다."
                        } else {
                            errorMessage = error.localizedDescription
                        }
                    }
                }
            }
        case .failure(let error):
            errorMessage = error.localizedDescription
        }
    }
}
