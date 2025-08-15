//
//  View+Extension.swift
//  BallCalculator
//
//  Created by Yunki on 5/4/25.
//

import SwiftUI

fileprivate struct LineHeightModifier: ViewModifier {
    let fontStyle: FontStyle

    func body(content: Content) -> some View {
        content
            .font(fontStyle.font)
            .lineSpacing(fontStyle.lineHeight - fontHeight)
            .padding(.vertical, (fontStyle.lineHeight - fontHeight) / 2)
    }

    private var fontHeight: CGFloat {
        return UIFont(name: "NotoSansKR-Regular", size: 15)?.lineHeight ?? 50
    }
}

extension View {
    func fontStyle(_ style: FontStyle) -> some View {
        self.modifier(LineHeightModifier(fontStyle: style))
    }
    
    func font(_ style: FontStyle) -> some View {
        self.fontStyle(style)
    }
}
