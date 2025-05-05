//
//  TextFieldStyle.swift
//  BallCalculator
//
//  Created by Yunki on 5/6/25.
//

import SwiftUI

enum TextFieldStyleType {
    case normal
    case active
    case active2
    case complete
    case error
    case disabled
}

struct TextFieldStyleConfiguration {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color?
    let iconColor: Color = .black02
}

func textFieldStyle(type: TextFieldStyleType) -> TextFieldStyleConfiguration {
    switch type {
    case .normal:
        return TextFieldStyleConfiguration(
            backgroundColor: .white01,
            foregroundColor: .black02,
            borderColor: .black03
        )
    case .active:
        return TextFieldStyleConfiguration(
            backgroundColor: .white01,
            foregroundColor: .black01,
            borderColor: .black01
        )
    case .active2:
        return TextFieldStyleConfiguration(
            backgroundColor: .white01,
            foregroundColor: .black02,
            borderColor: .black02
        )
    case .complete:
        return TextFieldStyleConfiguration(
            backgroundColor: .white01,
            foregroundColor: .black01,
            borderColor: .black03
        )
    case .error:
        return TextFieldStyleConfiguration(
            backgroundColor: .white01,
            foregroundColor: .red01,
            borderColor: .red02
        )
    case .disabled:
        return TextFieldStyleConfiguration(
            backgroundColor: .black05,
            foregroundColor: .black02,
            borderColor: .black03
        )
    }
}
