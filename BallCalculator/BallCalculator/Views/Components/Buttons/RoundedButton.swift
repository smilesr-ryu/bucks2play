//
//  RoundedButton.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI

struct RoundedButton: View {
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
        
        Text(label)
            .fontStyle(.label1_B)
            .frame(width: 84, height: 24)
            .padding(.vertical, 12)
//            .padding(.horizontal, 18)
            .foregroundColor(style.foregroundColor)
            .background(style.backgroundColor)
            .cornerRadius(48)
            .overlay(
                RoundedRectangle(cornerRadius: 48)
                    .stroke(style.borderColor ?? .clear, lineWidth: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 48))
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

extension RoundedButton {
    func buttonStyle(type: ButtonStyleType, state: ButtonVisualState) -> ButtonStyleConfiguration {
        switch (type, state) {
        case (_, .normal):
            return ButtonStyleConfiguration(backgroundColor: .black01, foregroundColor: .white01, borderColor: nil)
        case (_, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .black02, foregroundColor: .white01, borderColor: nil)
        case (_, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .black03, foregroundColor: .white01, borderColor: nil)
        }
    }

}

#Preview {
    RoundedButton("TEXT", isEnabled: true, action: {})
}
