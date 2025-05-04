//
//  User.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import Foundation

struct User: Identifiable {
    let id: String
    let email: String
    let nickname: String
    let gender: String
    let favoritePlayer: String?
    let racket: String?
    let lastLogin: Date
}
