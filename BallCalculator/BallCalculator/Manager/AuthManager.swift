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
            "gender": user.gender?.rawValue ?? "",
            "favoritePlayer": user.favoritePlayer ?? "",
            "racket": user.racket ?? "",
            "lastLogin": user.lastLogin,
            "createdAt": FieldValue.serverTimestamp()
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
    
    func signinWithApple(credential: ASAuthorizationAppleIDCredential) async throws {
        // Apple ID로부터 사용자 정보 추출
        let userID = credential.user
        let email = credential.email ?? ""
        let fullName = credential.fullName
        let firstName = fullName?.givenName ?? ""
        let lastName = fullName?.familyName ?? ""
        let name = "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
        
        // Apple ID 토큰을 Firebase 크레덴셜로 변환
        guard let appleIDToken = credential.identityToken,
              let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            throw AuthError.invalidCredential
        }
        
        let nonce = randomNonceString()
        let firebaseCredential = OAuthProvider.credential(
            withProviderID: "apple.com",
            idToken: idTokenString,
            rawNonce: nonce
        )
        
        // Firebase Auth로 로그인
        let authResult = try await Auth.auth().signIn(with: firebaseCredential)
        
        // Firestore에서 사용자 정보 확인
        let userDoc = try await db.collection("users").document(authResult.user.uid).getDocument()
        
        if userDoc.exists {
            // 기존 사용자: 정보 업데이트
            await fetchUserFromFirestore(userId: authResult.user.uid)
        } else {
            // 새 사용자: Firestore에 저장
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
            
            let userData: [String: Any] = [
                "id": user.id,
                "email": user.email,
                "name": user.name,
                "nickname": user.nickname ?? "",
                "gender": user.gender?.rawValue ?? "",
                "favoritePlayer": user.favoritePlayer ?? "",
                "racket": user.racket ?? "",
                "lastLogin": user.lastLogin,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            try await db.collection("users").document(authResult.user.uid).setData(userData)
            self.currentUser = user
        }
        
        print("Apple 로그인 성공: \(currentUser?.name ?? "알 수 없는 사용자") (\(currentUser?.email ?? ""))")
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
            "gender": user.gender?.rawValue ?? "",
            "favoritePlayer": user.favoritePlayer ?? "",
            "racket": user.racket ?? "",
            "lastLogin": user.lastLogin,
            "updatedAt": FieldValue.serverTimestamp()
        ]
        
        try await db.collection("users").document(firebaseUser.uid).updateData(userData)
        
        // 현재 사용자 정보 업데이트
        self.currentUser = user
        
        print("사용자 정보 업데이트 완료: \(user.name)")
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
    
    func signinWithAppleWithCompletion(credential: ASAuthorizationAppleIDCredential, completion: @escaping (Result<Void, Error>) -> Void) {
        Task {
            do {
                try await signinWithApple(credential: credential)
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
    
    // MARK: - Private Methods
    
    private func findUserByID(_ userId: String) async throws -> User? {
        print("사용자 ID로 검색 시작: \(userId)")
        
        let query = db.collection("users").whereField("id", isEqualTo: userId)
        let snapshot = try await query.getDocuments()
        
        if let document = snapshot.documents.first {
            let data = document.data()
            print("사용자 ID로 검색 완료: \(data)")
            
            let user = User(
                id: data["id"] as? String ?? userId,
                firebaseUID: data["firebaseUID"] as? String,
                email: data["email"] as? String ?? "",
                name: data["name"] as? String ?? "",
                nickname: data["nickname"] as? String,
                gender: Gender(rawValue: data["gender"] as? String ?? ""),
                favoritePlayer: data["favoritePlayer"] as? String,
                racket: data["racket"] as? String,
                lastLogin: (data["lastLogin"] as? Timestamp)?.dateValue() ?? .now
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
                
                let user = User(
                    id: data["id"] as? String ?? userId,
                    firebaseUID: data["firebaseUID"] as? String ?? userId,
                    email: data["email"] as? String ?? "",
                    name: data["name"] as? String ?? "",
                    nickname: data["nickname"] as? String,
                    gender: Gender(rawValue: data["gender"] as? String ?? ""),
                    favoritePlayer: data["favoritePlayer"] as? String,
                    racket: data["racket"] as? String,
                    lastLogin: (data["lastLogin"] as? Timestamp)?.dateValue() ?? .now
                )
                
                DispatchQueue.main.async {
                    self.currentUser = user
                    print("현재 사용자 설정 완료: \(user.name)")
                }
            } else {
                print("Firestore에서 사용자 데이터를 찾을 수 없음: \(userId)")
                // 사용자 데이터가 없으면 기본 정보로 생성
                await createDefaultUserData(userId: userId)
            }
        } catch {
            print("Firestore에서 사용자 정보 가져오기 실패: \(error)")
            // 에러 발생 시에도 기본 정보로 생성 시도
            await createDefaultUserData(userId: userId)
        }
    }
    
    private func createDefaultUserData(userId: String) async {
        do {
            print("기본 사용자 데이터 생성 시작: \(userId)")
            
            guard let firebaseUser = Auth.auth().currentUser else {
                print("Firebase Auth 사용자 정보 없음")
                return
            }
            
            let defaultUser = User(
                id: "user_\(userId.prefix(8))", // 임시 ID 생성
                firebaseUID: userId,
                email: firebaseUser.email ?? "",
                name: firebaseUser.displayName ?? "사용자",
                nickname: nil,
                gender: nil,
                favoritePlayer: nil,
                racket: nil,
                lastLogin: .now
            )
            
            let userData: [String: Any] = [
                "id": defaultUser.id,
                "firebaseUID": defaultUser.firebaseUID ?? "",
                "email": defaultUser.email,
                "name": defaultUser.name,
                "nickname": defaultUser.nickname ?? "",
                "gender": defaultUser.gender?.rawValue ?? "",
                "favoritePlayer": defaultUser.favoritePlayer ?? "",
                "racket": defaultUser.racket ?? "",
                "lastLogin": defaultUser.lastLogin,
                "createdAt": FieldValue.serverTimestamp()
            ]
            
            try await db.collection("users").document(userId).setData(userData)
            
            DispatchQueue.main.async {
                self.currentUser = defaultUser
                print("기본 사용자 데이터 생성 완료: \(defaultUser.name)")
            }
        } catch {
            print("기본 사용자 데이터 생성 실패: \(error)")
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
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
