//
//  FormTextField.swift
//  BallCalculator
//
//  Created by Yunki on 5/6/25.
//

import SwiftUI

struct FormTextField<Helper: View, Trailing: View, LeftIcon: View, RightIcon: View>: View {
    var title: String?
    var prompt: String?
    @Binding var text: String
    var type: TextFieldStyleType

    @ViewBuilder var helper: () -> Helper
    @ViewBuilder var trailing: () -> Trailing
    @ViewBuilder var leftIcon: () -> LeftIcon
    @ViewBuilder var rightIcon: () -> RightIcon

    init(
        title: String? = nil,
        prompt: String? = nil,
        text: Binding<String>,
        type: TextFieldStyleType = .normal,
        @ViewBuilder helper: @escaping () -> Helper = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() },
        @ViewBuilder leftIcon: @escaping () -> LeftIcon = { EmptyView() },
        @ViewBuilder rightIcon: @escaping () -> RightIcon = { EmptyView() }
    ) {
        self.prompt = prompt
        self._text = text
        self.type = type
        self.title = title
        self.helper = helper
        self.trailing = trailing
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let title {
                Text(title)
                    .font(.label1_R)
                    .foregroundStyle(.black01)
            }

            HStack(spacing: 6) {
                BasicTextField(
                    prompt: prompt,
                    text: $text,
                    type: type,
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
            title: "이메일",
            prompt: "이메일",
            text: .constant("user@example.com"),
            type: .normal,
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
