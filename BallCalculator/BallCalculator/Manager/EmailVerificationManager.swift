//
//  EmailVerificationManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/1/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@Observable
class EmailVerificationManager {
    static let shared = EmailVerificationManager()
    
    private let db = Firestore.firestore()
    
    // 현재 진행 중인 인증
    var currentVerificationEmail: String?
    var isVerifying: Bool = false
    var errorMessage: String = ""
    
    private init() {}
    
    // MARK: - Public Methods
    
    func sendVerificationEmail(to email: String) async throws {
        print("이메일 인증 메일 전송 시작: \(email)")
        
        // 이메일 형식 검증
        guard isValidEmail(email) else {
            throw EmailVerificationError.invalidEmail
        }
        
        // 기존 인증 정보가 있다면 삭제
        if let existingEmail = currentVerificationEmail {
            try await deleteVerificationData(existingEmail)
        }
        
        // 임시 Firebase Auth 계정 생성
        let tempPassword = generateTempPassword()
        let tempUser = try await Auth.auth().createUser(withEmail: email, password: tempPassword)
        
        // 이메일 인증 메일 전송
        try await tempUser.sendEmailVerification()
        
        // Firestore에 임시 인증 정보 저장
        let verificationData: [String: Any] = [
            "email": email,
            "tempUID": tempUser.uid,
            "tempPassword": tempPassword,
            "createdAt": FieldValue.serverTimestamp(),
            "expiresAt": Date().addingTimeInterval(300) // 5분 후 만료
        ]
        
        try await db.collection("emailVerifications").document(email).setData(verificationData)
        
        currentVerificationEmail = email
        print("이메일 인증 메일 전송 완료")
    }
    
    func checkVerificationStatus(for email: String) async throws -> Bool {
        print("이메일 인증 상태 확인: \(email)")
        
        // Firestore에서 임시 인증 정보 가져오기
        let document = try await db.collection("emailVerifications").document(email).getDocument()
        
        guard let data = document.data(),
              let tempUID = data["tempUID"] as? String else {
            throw EmailVerificationError.verificationNotFound
        }
        
        // 만료 확인
        if let expiresAt = data["expiresAt"] as? Timestamp,
           Date() > expiresAt.dateValue() {
            throw EmailVerificationError.verificationExpired
        }
        
        // Firebase Auth에서 인증 상태 확인
        let tempUser = try await Auth.auth().signIn(withEmail: email, password: data["tempPassword"] as? String ?? "")
        try await tempUser.user.reload()
        
        let isVerified = tempUser.user.isEmailVerified
        print("이메일 인증 상태: \(isVerified)")
        
        if isVerified {
            // 인증 완료 시 임시 데이터 삭제
            try await deleteVerificationData(email)
            currentVerificationEmail = nil
        }
        
        return isVerified
    }
    
    func cleanupVerification(for email: String) async throws {
        print("이메일 인증 데이터 정리: \(email)")
        
        // Firestore에서 임시 데이터 삭제
        try await deleteVerificationData(email)
        
        // Firebase Auth에서 임시 계정 삭제
        if let document = try? await db.collection("emailVerifications").document(email).getDocument(),
           let data = document.data(),
           let tempUID = data["tempUID"] as? String {
            // 임시 계정으로 로그인 후 삭제
            if let tempPassword = data["tempPassword"] as? String {
                let tempUser = try await Auth.auth().signIn(withEmail: email, password: tempPassword)
                try await tempUser.user.delete()
            }
        }
        
        currentVerificationEmail = nil
    }
    
    // MARK: - Private Methods
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#
        return email.range(of: emailRegex, options: .regularExpression) != nil
    }
    
    private func generateTempPassword() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<12).map { _ in characters.randomElement()! })
    }
    
    private func deleteVerificationData(_ email: String) async throws {
        try await db.collection("emailVerifications").document(email).delete()
    }
}

// MARK: - Email Verification Errors

enum EmailVerificationError: Error, LocalizedError {
    case invalidEmail
    case verificationNotFound
    case verificationExpired
    case emailSendFailed
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "유효하지 않은 이메일 주소입니다."
        case .verificationNotFound:
            return "인증 정보를 찾을 수 없습니다."
        case .verificationExpired:
            return "인증이 만료되었습니다. 다시 인증해주세요."
        case .emailSendFailed:
            return "이메일 전송에 실패했습니다."
        }
    }
} 