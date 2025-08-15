//
//  BasicTextField.swift
//  BallCalculator
//
//  Created by Yunki on 5/6/25.
//

import SwiftUI

struct BasicTextField<LeftIcon: View, RightIcon: View>: View {
    var prompt: String?
    @Binding var text: String
    var type: TextFieldStyleType
    var isSecure: Bool
    var isEnabled: Bool

    private let leftIconBuilder: () -> LeftIcon
    private let rightIconBuilder: () -> RightIcon

    init(
        prompt: String? = nil,
        text: Binding<String>,
        type: TextFieldStyleType = .normal,
        isSecure: Bool = false,
        isEnabled: Bool = true,
        @ViewBuilder leftIcon: @escaping () -> LeftIcon = { EmptyView() },
        @ViewBuilder rightIcon: @escaping () -> RightIcon = { EmptyView() }
    ) {
        self.prompt = prompt
        self._text = text
        self.type = type
        self.isSecure = isSecure
        self.isEnabled = isEnabled
        self.leftIconBuilder = leftIcon
        self.rightIconBuilder = rightIcon
    }

    var body: some View {
        let style = BallCalculator.textFieldStyle(type: type)

        HStack(spacing: 6) {
            leftIconBuilder()
                .foregroundStyle(style.iconColor)
            
            if isSecure {
                SecureField(prompt ?? "", text: $text)
                    .lineLimit(1)
                    .fontStyle(.label1_R)
                    .foregroundColor(style.foregroundColor)
                    .frame(height: 24)
            } else {
                TextField(prompt ?? "", text: $text)
                    .lineLimit(1)
                    .fontStyle(.label1_R)
                    .foregroundColor(style.foregroundColor)
                    .frame(height: 24)
            }

            rightIconBuilder()
                .foregroundStyle(style.iconColor)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(style.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 48)
                .stroke(style.borderColor ?? .clear, lineWidth: 2)
                .clipShape(RoundedRectangle(cornerRadius: 48))
        )
        .cornerRadius(48)
    }
}

#Preview {
    VStack(spacing: 16) {
        BasicTextField(prompt: "기본 상태", text: .constant("기본 상태"), type: .disabled)
        BasicTextField(
            text: .constant("왼쪽 아이콘"),
            leftIcon: { Image(systemName: "magnifyingglass") }
        )
        BasicTextField(
            text: .constant("양쪽 아이콘"),
            leftIcon: { Image(systemName: "magnifyingglass") },
            rightIcon: { Image(systemName: "xmark.circle.fill") }
        )
    }
    .padding()
}
