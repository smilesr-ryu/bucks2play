//
//  SignUpView.swift
//  BallCalculator
//
//  Created by Yunki on 5/14/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var id: String = ""
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordCheck: String = ""
    @State var nickname: String = ""
    @State var selectedGender: Gender?
    @State var favoritePlayer: String = ""
    @State var myRacket: String = ""
    
    @State var passwordSecured: Bool = true
    @State var passwordCheckSecured: Bool = true
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    @State var isEmailVerified: Bool = false
    @State var isEmailVerifying: Bool = false
    
    var authManager: AuthManager = .shared
    var popupManager: PopupManager = .shared
    
    // 앱 상태 변화 감지를 위한 변수
    @Environment(\.scenePhase) private var scenePhase
    
    private var isValidUser: Bool {
        guard !id.isEmpty else { return false }
        guard !name.isEmpty else { return false }
        guard !email.isEmpty else { return false }
        guard !password.isEmpty else { return false }
        guard !passwordCheck.isEmpty else { return false }
        return true
    }
    
    private var isValidID: Bool {
        guard id.count >= 5 else { return false }
        guard id.range(of: #"^[A-Za-z0-9]+$"#, options: .regularExpression) != nil else { return false }
        return true
    }
    
    private var isValidEmail: Bool {
        guard email.range(of: #"^[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#, options: .regularExpression) != nil else { return false }
        return true
    }
    
    private var isValidPassword: Bool {
        guard 8...20 ~= password.count else { return false }
        guard password.range(of: #"^[A-Za-z0-9]+$"#, options: .regularExpression) != nil else { return false }
        return true
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TopBar(
                    title: "회원가입",
                    back: {
                        dismiss()
                    })
                
                HStack(spacing: 0) {
                    Spacer()
                    Text("*")
                        .foregroundStyle(.red01)
                    Text("필수입력 항목")
                        .foregroundStyle(.black02)
                }
                .font(.label1_B)
                .frame(height: 24)
                .padding(.horizontal, 20)
                
                FormTextField(
                    prompt: "5자 이상의  영문 + 숫자",
                    text: $id,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("아이디")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    helper: {
                        if !id.isEmpty, !isValidID {
                            Text("5자 이상의 영문 + 숫자 조합")
                                .foregroundStyle(.red01)
                        }
                    }
                )
                
                FormTextField(
                    prompt: "이름 입력",
                    text: $name,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("이름")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                FormTextField(
                    prompt: "이메일 입력",
                    text: $email,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("이메일")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    trailing: {
                        if isEmailVerified {
                            RoundedButton(
                                "인증 완료",
                                isEnabled: false,
                                action: { }
                            )
                        } else {
                            RoundedButton(
                                isEmailVerifying
                                ? "인증중..."
                                : "인증 요청",
                                isEnabled: isValidEmail && !isEmailVerifying,
                                action: {
                                    requestEmailVerification()
                                }
                            )
                        }
                    }
                )
                
                FormTextField(
                    prompt: "8~20자 이내의 영문 + 숫자",
                    text: $password,
                    isSecure: passwordSecured,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("비밀번호")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    helper: {
                        if !password.isEmpty, !isValidPassword {
                            Text("8~20자 이내의 영문 + 숫자")
                                .foregroundStyle(.red01)
                        }
                    },
                    rightIcon: {
                        Button {
                            passwordSecured.toggle()
                        } label: {
                            if passwordSecured {
                                Image(.eyeOff18)
                            } else {
                                Image(.eye18)
                            }
                        }
                    }
                )
                
                FormTextField(
                    prompt: "비밀번호 재입력",
                    text: $passwordCheck,
                    isSecure: passwordCheckSecured,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("비밀번호 확인")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    helper: {
                        if !passwordCheck.isEmpty && password != passwordCheck {
                            Text("비밀번호가 일치하지 않습니다.")
                                .foregroundStyle(.red01)
                        }
                    },
                    rightIcon: {
                        Button {
                            passwordCheckSecured.toggle()
                        } label: {
                            if passwordCheckSecured {
                                Image(.eyeOff18)
                            } else {
                                Image(.eye18)
                            }
                        }
                    }
                )
                
                FormTextField(
                    prompt: "닉네임 2~8자로 입력",
                    text: $nickname,
                    title: {
                        HStack(spacing: 2) {
                            Text("닉네임")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                VStack(spacing: 16) {
                    HStack {
                        Text("성별")
                            .fontStyle(.label1_R)
                            .foregroundStyle(.black01)
                        Spacer()
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(Gender.allCases, id: \.rawValue) { gender in
                            HStack(spacing: 6) {
                                Button {
                                    selectedGender = gender
                                } label: {
                                    if selectedGender == gender {
                                        Image(.checked24)
                                    } else {
                                        Image(.unchecked24)
                                    }
                                }
                                
                                Text(gender.description)
                                    .fontStyle(.label1_R)
                                    .frame(height: 18)
                                    .frame(minWidth: 50, alignment: .leading)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                Rectangle()
                    .foregroundStyle(.black05)
                    .frame(height: 12)
                    .padding(.vertical, 24)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(.benefit)
                        
                        Text("해당 항목 입력시 모든 테마가 열려요!")
                            .fontStyle(.label1_B)
                            .frame(height: 18)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                FormTextField(
                    text: $favoritePlayer,
                    title: {
                        HStack(spacing: 2) {
                            Text("좋아하는 선수")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                FormTextField(
                    text: $myRacket,
                    title: {
                        HStack(spacing: 2) {
                            Text("내 라켓 정보")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                BasicButton("회원가입", type: .primary, isEnabled: isValidUser && isEmailVerified && !isLoading) {
                    performSignUp()
                }
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 56, trailing: 20))
            }
        }
        .toolbar(.hidden)
        .onChange(of: scenePhase) { _, newPhase in
            Task {
                await checkEmailVerificationManually()
            }
        }
        .onChange(of: email) { _, newEmail in
            // 이메일이 변경되면 인증 상태 초기화
            if !newEmail.isEmpty {
                isEmailVerified = false
                isEmailVerifying = false
                errorMessage = ""
            }
        }
        .onDisappear {
            // 뷰가 사라질 때 계정 정리 (회원가입이 완료되지 않은 경우)
            if !isEmailVerified {
                Task {
                    if let currentUser = Auth.auth().currentUser, currentUser.email == email {
                        try? await currentUser.delete()
                        print("🗑️ 미완료 회원가입 계정 삭제")
                    }
                }
            }
        }
    }
    
    private func performSignUp() {
        guard password == passwordCheck else {
            errorMessage = "비밀번호가 일치하지 않습니다."
            return
        }
        
        // 회원가입 전 이메일 인증 상태 재확인
        Task {
            await checkEmailVerificationManually()
            
            await MainActor.run {
                guard isEmailVerified else {
                    errorMessage = "이메일 인증이 필요합니다."
                    return
                }
                
                // 이메일 인증이 완료된 경우에만 회원가입 진행
                performSignUpAfterVerification()
            }
        }
    }
    
    private func performSignUpAfterVerification() {
        isLoading = true
        errorMessage = ""
        
        let user = User(
            id: id,
            email: email,
            password: password,
            name: name,
            nickname: nickname.isEmpty ? nil : nickname,
            gender: selectedGender,
            favoritePlayer: favoritePlayer.isEmpty ? nil : favoritePlayer,
            racket: myRacket.isEmpty ? nil : myRacket
        )
        
        // Firebase Auth 계정의 비밀번호를 실제 비밀번호로 업데이트
        Task {
            do {
                guard let currentUser = Auth.auth().currentUser else {
                    await MainActor.run {
                        isLoading = false
                        errorMessage = "인증된 계정을 찾을 수 없습니다."
                    }
                    return
                }
                
                // 비밀번호 업데이트
                try await currentUser.updatePassword(to: password)
                print("✅ 비밀번호 업데이트 완료")
                
                // Firestore에 사용자 정보 저장
                let userData: [String: Any] = [
                    "id": user.id,
                    "firebaseUID": currentUser.uid,
                    "email": user.email,
                    "name": user.name,
                    "nickname": user.nickname ?? "",
                    "gender": user.gender?.rawValue ?? "",
                    "favoritePlayer": user.favoritePlayer ?? "",
                    "racket": user.racket ?? "",
                    "lastLogin": user.lastLogin,
                    "isEmailVerified": true,
                    "createdAt": FieldValue.serverTimestamp()
                ]
                
                try await Firestore.firestore().collection("users").document(currentUser.uid).setData(userData)
                print("✅ Firestore에 사용자 정보 저장 완료")
                
                await MainActor.run {
                    self.popupManager.toast = .signUpComplete
                    self.dismiss()
                }
                
            } catch {
                await MainActor.run {
                    isLoading = false
                    if let error = error as NSError? {
                        switch error.code {
                        case AuthErrorCode.requiresRecentLogin.rawValue:
                            errorMessage = "보안을 위해 다시 로그인해주세요."
                        default:
                            errorMessage = "회원가입에 실패했습니다: \(error.localizedDescription)"
                        }
                    } else {
                        errorMessage = "회원가입에 실패했습니다: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    private func requestEmailVerification() {
        isEmailVerifying = true
        errorMessage = ""
        
        print("📧 이메일 인증 요청 시작: \(email)")
        
        // 회원가입 정보로 Firebase Auth 계정 생성
        Task {
            do {
                // 임시 비밀번호 생성 (회원가입 시 실제 비밀번호로 변경됨)
                let tempPassword = "Temp\(UUID().uuidString.prefix(8))"
                print("🔑 임시 비밀번호 생성: \(tempPassword)")
                
                // Firebase Auth로 계정 생성
                print("👤 Firebase Auth 계정 생성 시작")
                let authResult = try await Auth.auth().createUser(withEmail: email, password: tempPassword)
                print("✅ Firebase Auth 계정 생성 완료: \(authResult.user.uid)")
                
                // 이메일 인증 메일 전송
                print("📤 이메일 인증 메일 전송 시작")
                try await authResult.user.sendEmailVerification()
                print("✅ 이메일 인증 메일 전송 완료")
                
                await MainActor.run {
                    errorMessage = "인증 메일을 확인해주세요. 이메일 링크를 클릭한 후 앱으로 돌아와주세요."
                    print("📱 UI 업데이트 완료: 인증 메일 전송 성공")
                }
                
            } catch {
                print("❌ 이메일 인증 요청 실패: \(error)")
                await MainActor.run {
                    isEmailVerifying = false // 에러 발생 시에만 false로 변경
                    if let error = error as NSError? {
                        print("🔍 에러 코드: \(error.code)")
                        switch error.code {
                        case AuthErrorCode.emailAlreadyInUse.rawValue:
                            errorMessage = "이미 사용 중인 이메일입니다. 다른 이메일을 사용해주세요."
                        case AuthErrorCode.invalidEmail.rawValue:
                            errorMessage = "유효하지 않은 이메일 형식입니다."
                        default:
                            errorMessage = "이메일 인증 메일 전송에 실패했습니다: \(error.localizedDescription)"
                        }
                    } else {
                        errorMessage = "이메일 인증 메일 전송에 실패했습니다: \(error.localizedDescription)"
                    }
                }
            }
        }
    }
    
    private func checkEmailVerificationManually() async {
        print("🔍 이메일 인증 수동 확인 시작")
        
        guard let user = Auth.auth().currentUser else {
            print("❌ 현재 로그인된 사용자 없음")
            return
        }
        
        do {
            // 사용자 정보 새로고침
            print("🔄 사용자 정보 새로고침 시작")
            try await user.reload()
            print("✅ 사용자 정보 새로고침 완료")
            
            if user.isEmailVerified {
                print("✅ 이메일 인증 완료됨")
                await MainActor.run {
                    isEmailVerified = true
                    isEmailVerifying = false
                    errorMessage = ""
                }
            } else {
                print("❌ 아직 인증되지 않음")
                await MainActor.run {
                    errorMessage = "이메일 인증이 완료되지 않았습니다. 이메일을 확인해주세요."
                }
            }
        } catch {
            print("❌ 사용자 정보 새로고침 실패: \(error)")
            await MainActor.run {
                errorMessage = "인증 확인에 실패했습니다: \(error.localizedDescription)"
            }
        }
    }
}

#Preview {
    SignUpView()
}
