//
//  ThemeOpenPopup.swift
//  BallCalculator
//
//  Created by Yunki on 5/23/25.
//

import SwiftUI

struct ThemeOpenPopup: View {
    @State private var popupManager = PopupManager.shared
    
    var body: some View {
        ZStack {
            Color.black01.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(alignment: .center, spacing: 0) {
                Image(.benefit)
                    .padding(.top, 30)
                    .padding(.bottom, 16)
                
                Text("테마를 열려면 benefit 항목을 작성해야해요. 작성하러 갈까요?")
                    .fontStyle(.headline1_R)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 8)
                
                HStack(spacing: 16) {
                    BasicButton("취소", type: .secondary) {
                        popupManager.activePopup = nil
                    }
                    BasicButton("작성하기", type: .primary) {
                        
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
}

#Preview {
    ThemeOpenPopup()
}
