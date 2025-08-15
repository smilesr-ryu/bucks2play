//
//  TinyButton.swift
//  BallCalculator
//
//  Created by Yunki on 5/6/25.
//

import SwiftUI

struct TinyButton: View {
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
            .frame(height: 24)
            .padding(.vertical, 4)
            .padding(.horizontal, 12)
            .foregroundColor(style.foregroundColor)
            .background(style.backgroundColor)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(style.borderColor ?? .clear, lineWidth: 2)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
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

extension TinyButton {
    func buttonStyle(type: ButtonStyleType, state: ButtonVisualState) -> ButtonStyleConfiguration {
        switch (type, state) {
        case (.primary, .normal):
            return ButtonStyleConfiguration(backgroundColor: .black01, foregroundColor: .white01, borderColor: nil)
        case (.primary, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .black02, foregroundColor: .white01, borderColor: nil)
        case (.primary, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .black03, foregroundColor: .white01, borderColor: nil)
            
        case (_, .normal):
            return ButtonStyleConfiguration(backgroundColor: .black05, foregroundColor: .black01, borderColor: nil)
        case (_, .pressed):
            return ButtonStyleConfiguration(backgroundColor: .black05, foregroundColor: .black03, borderColor: nil)
        case (_, .disabled):
            return ButtonStyleConfiguration(backgroundColor: .black03, foregroundColor: .black02, borderColor: nil)
        }
    }

}

#Preview {
    TinyButton("TEXT", isEnabled: true, action: {})
}
