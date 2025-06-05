//
//  AuthManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI
import AuthenticationServices

@Observable
class AuthManager {
    static let shared = AuthManager()
    
    var currentUser: User?
}

extension AuthManager {
    func signup(_ user: User) {
        print("sign up with \(user.id)")
        self.currentUser = user
    }
    
    func signin(id: String, password: String) {
        print("sign in with \(id)")
        self.currentUser = User(id: id, email: "email", name: "name", nickname: "nickname", lastLogin: .now)
    }
    
    func signinWithApple(credential: ASAuthorizationAppleIDCredential) {
        // Apple ID로부터 사용자 정보 추출
        let userID = credential.user
        let email = credential.email ?? ""
        let fullName = credential.fullName
        let firstName = fullName?.givenName ?? ""
        let lastName = fullName?.familyName ?? ""
        let name = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        // User 객체 생성
        let user = User(
            id: userID,
            email: email,
            name: name.isEmpty ? "Apple User" : name,
            nickname: nil,
            gender: nil,
            favoritePlayer: nil,
            racket: nil,
            lastLogin: .now
        )
        
        // 현재 사용자로 설정
        self.currentUser = user
        
        print("Apple 로그인 성공: \(user.name) (\(user.email))")
        
        // TODO: Firebase 연동 시 여기에 Firebase 인증 로직 추가
        // 예: Firebase.auth().signIn(with: firebaseCredential)
    }
    
    func logout() {
        print("로그아웃: \(currentUser?.name ?? "알 수 없는 사용자")")
        
        // 현재 사용자 정보 초기화
        self.currentUser = nil
        
        // TODO: Firebase 연동 시 여기에 Firebase 로그아웃 로직 추가
        // 예: try Auth.auth().signOut()
        
        print("로그아웃 완료")
    }
    
    func updateInfo(_ user: User) {
        self.currentUser = user
    }
}
