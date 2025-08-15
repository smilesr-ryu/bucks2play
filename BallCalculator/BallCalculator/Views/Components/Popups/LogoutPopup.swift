//
//  LogoutPopup.swift
//  BallCalculator
//
//  Created by Yunki on 5/23/25.
//

import SwiftUI

struct LogoutPopup: View {
    @State private var popupManager = PopupManager.shared
    @State private var authManager = AuthManager.shared
    @State private var isLoading: Bool = false
    
    var body: some View {
        ZStack {
            Color.black01.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Image(.warning)
                    .padding(.top, 30)
                    .padding(.bottom, 16)
                
                Text("로그아웃 하시겠어요?")
                    .fontStyle(.headline1_R)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                
                HStack(spacing: 16) {
                    BasicButton("취소", type: .secondary, isEnabled: !isLoading) {
                        // popup 닫기
                        popupManager.activePopup = nil
                    }
                    BasicButton("로그아웃", type: .primary, isEnabled: !isLoading) {
                        // 로그아웃 실행
                        performLogout()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
            .background {
                RoundedRectangle(cornerRadius: 16)
                    .foregroundStyle(.white01)
            }
            .padding(.horizontal, 28)
        }
    }
    
    private func performLogout() {
        isLoading = true
        
        authManager.logoutWithCompletion { result in
            isLoading = false
            
            switch result {
            case .success:
                // popup 닫기
                popupManager.activePopup = nil
            case .failure(let error):
                print("로그아웃 실패: \(error.localizedDescription)")
                // 에러가 발생해도 popup은 닫기
                popupManager.activePopup = nil
            }
        }
    }
}

#Preview {
    LogoutPopup()
}
