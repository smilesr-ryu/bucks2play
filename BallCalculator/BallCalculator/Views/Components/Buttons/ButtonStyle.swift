//
//  ButtonStyle.swift
//  BallCalculator
//
//  Created by Yunki on 5/5/25.
//

import SwiftUI

enum ButtonStyleType {
    case primary
    case secondary
    case tertiary
}

enum ButtonVisualState {
    case normal
    case pressed
    case disabled
}

struct ButtonStyleConfiguration {
    let backgroundColor: Color
    let foregroundColor: Color
    let borderColor: Color?
}
