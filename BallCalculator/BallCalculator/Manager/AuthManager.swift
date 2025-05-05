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
