//
//  SignInWithAppleLoginButton.swift
//  BallCalculator
//
//  Created by Yunki on 4/26/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct SignInWithAppleButtonView: View {
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
                guard let token = appleIDCredential.identityToken,
                      let tokenString = String(data: token, encoding: .utf8) else {
                    print("토큰 가져오기 실패")
                    return
                }

                let credential = OAuthProvider.credential(
                    providerID: .apple,
                    idToken: tokenString,
                    rawNonce: "",
                    accessToken: nil
                )

                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        print("Firebase 로그인 실패: \(error.localizedDescription)")
                    } else {
                        print("Apple + Firebase 로그인 성공!")
                    }
                }
            }
        case .failure(let error):
            print("Apple 로그인 실패: \(error.localizedDescription)")
        }
    }
}
