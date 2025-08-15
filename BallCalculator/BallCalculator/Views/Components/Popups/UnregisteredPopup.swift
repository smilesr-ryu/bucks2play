//
//  UnregisteredPopup.swift
//  BallCalculator
//
//  Created by Yunki on 5/23/25.
//

import SwiftUI

struct UnregisteredPopup: View {
    @State private var popupManager = PopupManager.shared
    
    var body: some View {
        ZStack {
            Color.black01.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Image(.warning)
                    .padding(.top, 30)
                    .padding(.bottom, 16)
                
                Text("일치하는 회원 정보가 없어요.\n다시 확인하시거나 회원가입하세요.")
                    .fontStyle(.headline1_R)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                
                
                BasicButton("확인", type: .primary) {
                    popupManager.activePopup = nil
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
}

#Preview {
    UnregisteredPopup()
}
