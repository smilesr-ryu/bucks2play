//
//  FormTextField.swift
//  BallCalculator
//
//  Created by Yunki on 5/6/25.
//

import SwiftUI

struct FormTextField<Title: View, Helper: View, Trailing: View, LeftIcon: View, RightIcon: View>: View {
    var prompt: String?
    @Binding var text: String
    var type: TextFieldStyleType
    var isSecure: Bool

    @ViewBuilder var title: () -> Title
    @ViewBuilder var helper: () -> Helper
    @ViewBuilder var trailing: () -> Trailing
    @ViewBuilder var leftIcon: () -> LeftIcon
    @ViewBuilder var rightIcon: () -> RightIcon

    init(
        prompt: String? = nil,
        text: Binding<String>,
        type: TextFieldStyleType = .normal,
        isSecure: Bool = false,
        @ViewBuilder title: @escaping () -> Title = { EmptyView() },
        @ViewBuilder helper: @escaping () -> Helper = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() },
        @ViewBuilder leftIcon: @escaping () -> LeftIcon = { EmptyView() },
        @ViewBuilder rightIcon: @escaping () -> RightIcon = { EmptyView() }
    ) {
        self.prompt = prompt
        self._text = text
        self.type = type
        self.isSecure = isSecure
        self.title = title
        self.helper = helper
        self.trailing = trailing
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            title()
                .font(.label1_R)
                .foregroundStyle(.black01)

            HStack(spacing: 6) {
                BasicTextField(
                    prompt: prompt,
                    text: $text,
                    type: type,
                    isSecure: isSecure,
                    leftIcon: leftIcon,
                    rightIcon: rightIcon
                )

                trailing()
            }

            helper()
                .font(.caption1_R)
        }
        .padding(.horizontal, 20)
        .padding(.top, 12)
    }
}

#Preview("FormTextField") {
    VStack(spacing: 16) {
        FormTextField(
            prompt: "이메일",
            text: .constant("user@example.com"),
            type: .normal,
            title: { Text("이메일").font(.caption) },
            helper: { Text("이메일 형식을 입력하세요").font(.caption2).foregroundColor(.gray) },
            trailing: {
                RoundedButton("Text", action: {})
            },
            leftIcon: { Image(systemName: "envelope") },
            rightIcon: { Image(systemName: "xmark.circle.fill") }
        )
    }
    .padding()
}
