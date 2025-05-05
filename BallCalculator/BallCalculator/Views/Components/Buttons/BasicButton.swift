//
//  BasicButton.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI

struct BasicButton: View {
    let label: String
    let type: ButtonStyleType
    let isEnabled: Bool
    let action: () -> Void
    
    init(_ title: String, type: ButtonStyleType, isEnabled: Bool = true, action: @escaping () -> Void) {
        self.label = title
        self.type = type
        self.isEnabled = isEnabled
        self.action = action
    }
    
    @GestureState private var isPressed = false
    
    var body: some View {
        let state: ButtonVisualState = isEnabled
        ? (isPressed ? .pressed : .normal)
        : .disabled
        let style = buttonStyle(type: type, state: state)
        
        Text(label)
            .fontStyle(.body1_B)
            .frame(height: 24)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 18)
            .foregroundColor(style.foregroundColor)
            .background(style.backgroundColor)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(style.borderColor ?? .clear, lineWidth: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            )
            .gesture(
                DragGesture(minimumDistance: 0)
                    .updating($isPressed) { _, state, _ in
                        state = true
                    }
                    .onEnded { _ in
                        if isEnabled {
                            action()
                        }
                    }
            )
    }
}

extension BasicButton {
    func buttonStyle(type: ButtonStyleType, state: ButtonVisualState) -> ButtonStyleConfiguration {
        switch (type, state) {
        case (.primary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .black01, foregroundColor: .white01, borderColor: nil)
        case (.primary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .black02, foregroundColor: .white01, borderColor: nil)
        case (.primary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .black03, foregroundColor: .white01, borderColor: nil)

        case (.secondary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .black05, foregroundColor: .black01, borderColor: nil)
        case (.secondary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .black03, foregroundColor: .black02, borderColor: nil)
        case (.secondary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .black05, foregroundColor: .black03, borderColor: nil)

        case (.tertiary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .white01, foregroundColor: .black01, borderColor: .black03)
        case (.tertiary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .black06, foregroundColor: .black01, borderColor: .black03)
        case (.tertiary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .clear, borderColor: nil)
        }
    }

}

#Preview {
    BasicButton("test", type: .tertiary, action: {})
}
