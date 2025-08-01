//
//  PasswordChangedToast.swift
//  BallCalculator
//
//  Created by Yunki on 5/23/25.
//

import SwiftUI

struct PasswordChangedToast: View {
    var body: some View {
        HStack {
            Text("비밀번호 변경 메일이 발송되었습니다.")
                .fontStyle(.label1_R)
                .foregroundStyle(.white01)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
            Spacer()
        }
        .background {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.black)
                .opacity(0.85)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
    }
}

#Preview {
    PasswordChangedToast()
}
