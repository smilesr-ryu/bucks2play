//
//  AuthManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI

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
    
    func updateInfo(_ user: User) {
        self.currentUser = user
    }
}
