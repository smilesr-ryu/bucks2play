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

enum Gender: String, CaseIterable {
    case male
    case female
    case none
    
    var description: String {
        switch self {
        case .male:
            return "남성"
        case .female:
            return "여성"
        case .none:
            return "선택하지 않음"
        }
    }
}
