//
//  TextButton.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI

struct TextButton: View {
    let label: String
    let type: ButtonStyleType
    let isEnabled: Bool
    let action: () -> Void
    
    init(_ title: String, type: ButtonStyleType = .primary, isEnabled: Bool = true, action: @escaping () -> Void) {
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
        HStack(spacing: 8) {
            Text(label)
                .fontStyle(.textButton1_R)
                .fontWeight(.bold)
                .frame(height: 20)
                .foregroundColor(style.foregroundColor)
            
            if type != .tertiary {
                Image(.arrowRight16)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundColor(style.foregroundColor)
            }
        }
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

extension TextButton {
    func buttonStyle(type: ButtonStyleType, state: ButtonVisualState) -> ButtonStyleConfiguration {
        switch (type, state) {
        case (.primary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black02, borderColor: nil)
        case (.primary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black01, borderColor: nil)
        case (.primary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black03, borderColor: nil)

        case (.secondary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black01, borderColor: nil)
        case (.secondary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black02, borderColor: nil)
        case (.secondary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black03, borderColor: nil)

        case (.tertiary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black01, borderColor: nil)
        case (.tertiary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black02, borderColor: nil)
        case (.tertiary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .clear, foregroundColor: .black03, borderColor: nil)
        }
    }

}

#Preview {
    TextButton("TEXT", isEnabled: true, action: {})
}
