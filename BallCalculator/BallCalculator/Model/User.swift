//
//  User.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import Foundation

struct User: Identifiable {
    var id: String // 사용자가 입력하는 로그인 ID
    var firebaseUID: String? // Firebase Auth의 UID (내부용)
    var email: String
    var name: String
    var nickname: String?
    var gender: Gender?
    var favoritePlayer: String?
    var racket: String?
    var lastLogin: Date
    var password: String? // 비밀번호는 로컬에서만 사용
    
    // 기본 초기화 메서드
    init(id: String, firebaseUID: String? = nil, email: String, name: String, nickname: String? = nil, gender: Gender? = nil, favoritePlayer: String? = nil, racket: String? = nil, lastLogin: Date = .now, password: String? = nil) {
        self.id = id
        self.firebaseUID = firebaseUID
        self.email = email
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.favoritePlayer = favoritePlayer
        self.racket = racket
        self.lastLogin = lastLogin
        self.password = password
    }
    
    // 회원가입용 초기화 메서드
    init(id: String, email: String, password: String, name: String, nickname: String? = nil, gender: Gender? = nil, favoritePlayer: String? = nil, racket: String? = nil) {
        self.id = id
        self.firebaseUID = nil // 회원가입 시에는 아직 Firebase UID가 없음
        self.email = email
        self.password = password
        self.name = name
        self.nickname = nickname
        self.gender = gender
        self.favoritePlayer = favoritePlayer
        self.racket = racket
        self.lastLogin = .now
    }
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
    
    var value: String {
        switch self {
        case .female: return "FEMALE"
        case .male: return "MALE"
        case .none: return "UNKNOWN"
        }
    }
}
