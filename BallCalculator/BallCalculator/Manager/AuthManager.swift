//
//  AuthManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth
import FirebaseFirestore

@Observable
class AuthManager {
    static let shared = AuthManager()
    
    var currentUser: User?
    private let db = Firestore.firestore()
    
    init() {
        // Firebase Auth 상태 변화 감지
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let firebaseUser = user {
                Task {
                    await self?.fetchUserFromFirestore(userId: firebaseUser.uid)
                }
            } else {
                DispatchQueue.main.async {
                    self?.currentUser = nil
                }
            }
        }
    }
}

extension AuthManager {
    func signup(_ user: User) async throws {
        print("Firebase 회원가입 시작: \(user.email)")
        
        guard let password = user.password else {
            print("비밀번호가 없음")
            throw AuthError.invalidCredential
        }
        
        // 사용자 ID 중복 확인
        let existingUser = try await findUserByID(user.id)
        if existingUser != nil {
            throw AuthError.userAlreadyExists
        }
        
        // Firebase Auth로 사용자 생성 (이메일로 생성)
        print("Firebase Auth 사용자 생성 시작")
        let authResult = try await Auth.auth().createUser(withEmail: user.email, password: password)
        print("Firebase Auth 사용자 생성 완료: \(authResult.user.uid)")
        
        // Firestore에 사용자 정보 저장 (비밀번호 제외)
        let userData: [String: Any] = [
            "id": user.id,
            "firebaseUID": authResult.user.uid,
            "email": user.email,
            "name": user.name,
            "nickname": user.nickname ?? "",
            "gender": user.gender?.value.uppercased() ?? "",
            "favoritePlayer": user.favoritePlayer ?? "",
            "racket": user.racket ?? "",
            "lastLoginDate": user.lastLogin,
            "signUpDate": FieldValue.serverTimestamp()
        ]
        
        print("Firestore에 저장할 데이터: \(userData)")
        
        do {
            print("Firestore에 사용자 데이터 저장 시작")
            try await db.collection("users").document(authResult.user.uid).setData(userData)
            print("Firestore에 사용자 데이터 저장 완료")
            
            // 현재 사용자로 설정 (비밀번호 제거, Firebase UID 추가)
            var userWithoutPassword = user
            userWithoutPassword.password = nil
            userWithoutPassword.firebaseUID = authResult.user.uid
            self.currentUser = userWithoutPassword
            
            print("Firebase 회원가입 완료: \(user.name)")
        } catch {
            print("Firestore 저장 실패: \(error)")
            // Firestore 저장 실패 시 Firebase Auth 계정도 삭제
            print("Firebase Auth 계정 삭제 시작")
            try await authResult.user.delete()
            print("Firebase Auth 계정 삭제 완료")
            throw error
        }
    }
    
    func signin(id: String, password: String) async throws {
        print("Firebase 로그인 시작: \(id)")
        
        // 사용자 ID로 Firestore에서 사용자 정보 찾기
        guard let user = try await findUserByID(id) else {
            throw AuthError.userNotFound
        }
        
        // Firebase Auth로 로그인 (이메일 사용)
        let authResult = try await Auth.auth().signIn(withEmail: user.email, password: password)
        print("Firebase Auth 로그인 완료: \(authResult.user.uid)")
        
        // Firestore에서 사용자 정보 가져오기
        await fetchUserFromFirestore(userId: authResult.user.uid)
        
        print("Firebase 로그인 완료: \(currentUser?.name ?? "알 수 없는 사용자")")
    }
    
    func logout() async throws {
        print("Firebase 로그아웃 시작: \(currentUser?.name ?? "알 수 없는 사용자")")
        
        // Firebase Auth 로그아웃
        try Auth.auth().signOut()
        
        // 현재 사용자 정보 초기화
        self.currentUser = nil
        
        // 모든 sheet 닫기
        SheetManager.shared.dismissAllSheets()
        
        print("Firebase 로그아웃 완료")
    }
    
    func deleteAccount() async throws {
        print("Firebase 회원탈퇴 시작: \(currentUser?.name ?? "알 수 없는 사용자")")
        
        guard let firebaseUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        // Firestore에서 사용자 데이터 삭제
        try await db.collection("users").document(firebaseUser.uid).delete()
        
        // Firebase Auth 계정 삭제
        try await firebaseUser.delete()
        
        // 현재 사용자 정보 초기화
        self.currentUser = nil
        
        // 모든 sheet 닫기
        SheetManager.shared.dismissAllSheets()
        
        print("Firebase 회원탈퇴 완료")
    }
    
    func updateInfo(_ user: User) async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        // Firestore 업데이트
        let userData: [String: Any] = [
            "id": user.id,
            "email": user.email,
            "name": user.name,
            "nickname": user.nickname ?? "",
            "gender": user.gender?.value.uppercased() ?? "UNKNOWN",
            "favoritePlayer": user.favoritePlayer ?? "",
            "racket": user.racket ?? "",
            "lastLoginDate": user.lastLogin,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        try await db.collection("users").document(firebaseUser.uid).updateData(userData)
        
        // 현재 사용자 정보 업데이트
        self.currentUser = user
        
        print("사용자 정보 업데이트 완료: \(user.name)")
    }
    
    // MARK: - Email Verification Methods
    
    func sendEmailVerification() async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        print("이메일 인증 메일 전송 시작: \(firebaseUser.email ?? "")")
        
        try await firebaseUser.sendEmailVerification()
        
        print("이메일 인증 메일 전송 완료")
    }
    
    func reloadUser() async throws {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        print("사용자 정보 새로고침 시작")
        
        try await firebaseUser.reload()
        
        // Firestore에서 최신 정보 가져오기
        await fetchUserFromFirestore(userId: firebaseUser.uid)
        
        print("사용자 정보 새로고침 완료")
    }
    
    func checkEmailVerificationStatus() async throws -> Bool {
        guard let firebaseUser = Auth.auth().currentUser else {
            throw AuthError.userNotFound
        }
        
        print("이메일 인증 상태 확인: \(firebaseUser.email ?? "")")
        
        // Firebase Auth에서 최신 정보 가져오기
        try await firebaseUser.reload()
        
        let isVerified = firebaseUser.isEmailVerified
        print("이메일 인증 상태: \(isVerified)")
        
        // Firestore 업데이트
        if isVerified {
            try await db.collection("users").document(firebaseUser.uid).updateData([
                "isEmailVerified": true,
                "updatedAt": FieldValue.serverTimestamp()
            ])
            
            // 현재 사용자 정보 업데이트
            if var currentUser = self.currentUser {
                self.currentUser = currentUser
            }
        }
        
        return isVerified
    }
    
    func findUserIdByEmail(_ email: String) async throws -> String? {
        print("이메일로 사용자 ID 찾기: \(email)")
        
        let query = db.collection("users").whereField("email", isEqualTo: email)
        let snapshot = try await query.getDocuments()
        
        if let document = snapshot.documents.first {
            let userId = document.data()["id"] as? String
            print("사용자 ID 찾기 완료: \(userId ?? "없음")")
            return userId
        }
        
        print("사용자 ID를 찾을 수 없음")
        return nil
    }
    
    // MARK: - UI용 래퍼 메서드들 (동기 인터페이스)
    
    func signupWithCompletion(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await signup(user)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func signinWithCompletion(id: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await signin(id: id, password: password)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func logoutWithCompletion(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await logout()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func deleteAccountWithCompletion(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await deleteAccount()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func updateInfoWithCompletion(_ user: User, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await updateInfo(user)
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func sendEmailVerificationWithCompletion(completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await sendEmailVerification()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func checkEmailVerificationStatusWithCompletion(completion: @escaping (Result<Bool, Error>) -> Void) {
        Task {
            do {
                let isVerified = try await checkEmailVerificationStatus()
                DispatchQueue.main.async {
                    completion(.success(isVerified))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func findUserIdByEmailWithCompletion(_ email: String, completion: @escaping (Result<String?, Error>) -> Void) {
        Task {
            do {
                let userId = try await findUserIdByEmail(email)
                DispatchQueue.main.async {
                    completion(.success(userId))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    // MARK: - UI Helper Methods for Existing UI
    
    /// 기존 UI의 "인증 요청" 버튼에서 사용할 메서드
    func requestEmailVerification(completion: @escaping (Result<Void, Error>) -> Void) {
        sendEmailVerificationWithCompletion(completion: completion)
    }
    
    /// 이메일 인증 상태 확인 (앱 재시작 시 또는 주기적으로 호출)
    func verifyEmailStatus(completion: @escaping (Result<Bool, Error>) -> Void) {
        checkEmailVerificationStatusWithCompletion(completion: completion)
    }
    
    /// 아이디 찾기 기능
    func findIdByEmail(_ email: String, completion: @escaping (Result<String?, Error>) -> Void) {
        findUserIdByEmailWithCompletion(email, completion: completion)
    }
    
    // MARK: - Private Methods
    
    private func findUserByID(_ userId: String) async throws -> User? {
        print("사용자 ID로 검색 시작: \(userId)")
        
        let query = db.collection("users").whereField("id", isEqualTo: userId)
        let snapshot = try await query.getDocuments()
        
        if let document = snapshot.documents.first {
            let data = document.data()
            print("사용자 ID로 검색 완료: \(data)")
            
            var gender: Gender {
                let genderString = data["gender"] as? String ?? "UNKNOWN"
                switch genderString {
                case "MALE": return .male
                case "FEMALE": return .female
                default: return .none
                }
            }
            
            let user = User(
                id: data["id"] as? String ?? userId,
                firebaseUID: data["firebaseUID"] as? String,
                email: data["email"] as? String ?? "",
                name: data["name"] as? String ?? "",
                nickname: data["nickname"] as? String,
                gender: gender,
                favoritePlayer: data["favoritePlayer"] as? String,
                racket: data["racket"] as? String,
                lastLogin: (data["lastLoginDate"] as? Timestamp)?.dateValue() ?? .now
            )
            
            return user
        }
        
        print("사용자 ID로 검색 실패: 사용자를 찾을 수 없음")
        return nil
    }
    
    private func fetchUserFromFirestore(userId: String) async {
        do {
            print("Firestore에서 사용자 정보 가져오기 시작: \(userId)")
            let document = try await db.collection("users").document(userId).getDocument()
            
            if document.exists, let data = document.data() {
                print("Firestore에서 사용자 데이터 발견: \(data)")
                var gender: Gender {
                    let genderString = data["gender"] as? String ?? "UNKNOWN"
                    switch genderString {
                    case "MALE": return .male
                    case "FEMALE": return .female
                    default: return .none
                    }
                }
                
                let user = User(
                    id: data["id"] as? String ?? userId,
                    firebaseUID: data["firebaseUID"] as? String ?? userId,
                    email: data["email"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    nickname: data["nickname"] as? String,
                    gender: gender,
                    favoritePlayer: data["favoritePlayer"] as? String,
                    racket: data["racket"] as? String,
                    lastLogin: (data["lastLoginDate"] as? Timestamp)?.dateValue() ?? .now
                )
                
                DispatchQueue.main.async {
                    self.currentUser = user
                    print("현재 사용자 설정 완료: \(user.name)")
                }
            } else {
                print("Firestore에서 사용자 데이터를 찾을 수 없음: \(userId)")
                // 사용자 데이터가 없으면 currentUser를 nil로 설정
                DispatchQueue.main.async {
                    self.currentUser = nil
                    print("사용자 데이터가 없어 currentUser를 nil로 설정")
                }
            }
        } catch {
            print("Firestore에서 사용자 정보 가져오기 실패: \(error)")
            // 에러 발생 시에도 currentUser를 nil로 설정
            DispatchQueue.main.async {
                self.currentUser = nil
                print("에러 발생으로 currentUser를 nil로 설정")
            }
        }
    }
}

// MARK: - Auth Errors

enum AuthError: Error, LocalizedError {
    case invalidCredential
    case userNotFound
    case networkError
    case unknown
    case userAlreadyExists
    
    var errorDescription: String? {
        switch self {
        case .invalidCredential:
            return "유효하지 않은 인증 정보입니다."
        case .userNotFound:
            return "사용자를 찾을 수 없습니다."
        case .networkError:
            return "네트워크 오류가 발생했습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        case .userAlreadyExists:
            return "이미 존재하는 사용자입니다."
        }
    }
}
