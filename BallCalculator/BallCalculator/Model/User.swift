//
//  User.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import Foundation

struct User: Identifiable {
    var id: String
    var email: String
    var nickname: String
    var gender: Gender?
    var favoritePlayer: String?
    var racket: String?
    var lastLogin: Date
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
