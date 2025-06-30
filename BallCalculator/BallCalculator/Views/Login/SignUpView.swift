//
//  SignUpView.swift
//  BallCalculator
//
//  Created by Yunki on 5/14/25.
//

import SwiftUI
import FirebaseAuth

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
                            HStack(spacing: 8) {
                                Image(.checked24)
                                    .foregroundStyle(.green)
                                Text("인증완료")
                                    .fontStyle(.caption1_R)
                                    .foregroundStyle(.green)
                            }
                        } else {
                            RoundedButton(
                                isEmailVerifying ? "인증중..." : "인증 요청",
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
                
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .fontStyle(.caption1_R)
                        .foregroundStyle(.red)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
                
                BasicButton("회원가입", type: .primary, isEnabled: isValidUser && isEmailVerified && !isLoading) {
                    performSignUp()
                }
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 56, trailing: 20))
            }
        }
        .toolbar(.hidden)
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .active && !isEmailVerified && !email.isEmpty && errorMessage.contains("인증 메일을 확인해주세요") {
                // 앱이 포그라운드로 돌아왔을 때 이메일 인증 상태 자동 확인
                Task {
                    await checkEmailVerificationAutomatically()
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
            await checkEmailVerificationAutomatically()
            
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
        
        authManager.signupWithCompletion(user) { result in
            switch result {
            case .success:
                self.popupManager.toast = .signUpComplete
                self.dismiss()
            case .failure(let error):
                self.isLoading = false
                if let authError = error as? AuthError {
                    self.errorMessage = authError.errorDescription ?? "회원가입에 실패했습니다."
                } else {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    private func requestEmailVerification() {
        isEmailVerifying = true
        errorMessage = ""
        
        // Firebase Auth의 내장 이메일 인증 기능 사용
        Task {
            do {
                // 임시 비밀번호 생성 (임시 계정용)
                let tempPassword = "Temp\(UUID().uuidString.prefix(8))"
                
                // Firebase Auth로 임시 계정 생성
                let authResult = try await Auth.auth().createUser(withEmail: email, password: tempPassword)
                
                // 이메일 인증 메일 전송
                try await authResult.user.sendEmailVerification()
                
                // 임시 계정 삭제 (이메일 인증은 유지됨)
                try await authResult.user.delete()
                
                await MainActor.run {
                    isEmailVerifying = false
                    errorMessage = "인증 메일을 확인해주세요. 이메일 링크를 클릭한 후 앱으로 돌아와주세요."
                }
                
            } catch {
                await MainActor.run {
                    isEmailVerifying = false
                    if let error = error as NSError? {
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
    
    private func checkEmailVerificationAutomatically() async {
        do {
            // 임시 비밀번호로 다시 계정 생성하여 인증 상태 확인
            let tempPassword = "Temp\(UUID().uuidString.prefix(8))"
            
            // 임시 계정 다시 생성
            let authResult = try await Auth.auth().createUser(withEmail: email, password: tempPassword)
            
            // 사용자 정보 새로고침하여 인증 상태 확인
            try await authResult.user.reload()
            
            let isVerified = authResult.user.isEmailVerified
            
            // 임시 계정 삭제
            try await authResult.user.delete()
            
            await MainActor.run {
                if isVerified {
                    isEmailVerified = true
                    errorMessage = ""
                }
            }
            
        } catch {
            await MainActor.run {
                if let error = error as NSError? {
                    switch error.code {
                    case AuthErrorCode.emailAlreadyInUse.rawValue:
                        // 이미 계정이 존재하는 경우, 인증 상태만 확인
                        Task {
                            await checkExistingAccountVerification()
                        }
                    default:
                        // 에러가 발생해도 조용히 처리 (자동 확인이므로)
                        break
                    }
                }
            }
        }
    }
    
    private func checkExistingAccountVerification() async {
        do {
            // 기존 계정이 있는 경우, 해당 계정의 인증 상태 확인
            let tempPassword = "Temp\(UUID().uuidString.prefix(8))"
            
            // 기존 계정으로 로그인 시도
            let authResult = try await Auth.auth().signIn(withEmail: email, password: tempPassword)
            
            // 사용자 정보 새로고침
            try await authResult.user.reload()
            
            let isVerified = authResult.user.isEmailVerified
            
            // 로그아웃
            try Auth.auth().signOut()
            
            await MainActor.run {
                if isVerified {
                    isEmailVerified = true
                    errorMessage = ""
                }
            }
            
        } catch {
            // 에러가 발생해도 조용히 처리 (자동 확인이므로)
        }
    }
}

#Preview {
    SignUpView()
}
