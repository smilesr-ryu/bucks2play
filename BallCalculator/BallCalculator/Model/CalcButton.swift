//
//  CalcButton.swift
//  BallCalculator
//
//  Created by Juhee Lee on 2023/10/14.
//

enum CalcButton: String {
    case zero = "0"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zerozero = "00"
    case clear = "C"
    case plus = "+"
    case minus = "-"
    case multiply = "x"
    case divide = "/"
    case equal = "="
    case decimal = "."
    case negative = "+/-"
    case delete = "⌫"
    case menu = "☰"
    case percent = "%"
    
    var imageName: String {
        switch self {
        case .zero:
            return "zero"
        case .one:
            return "one"
        case .two:
            return "two"
        case .three:
            return "three"
        case .four:
            return "four"
        case .five:
            return "five"
        case .six:
            return "six"
        case .seven:
            return "seven"
        case .eight:
            return "eight"
        case .nine:
            return "nine"
        case .clear:
            return "clear"
        case .plus:
            return "add"
        case .minus:
            return "minus"
        case .multiply:
            return "multiply"
        case .divide:
            return "divide"
        case .equal:
            return "equal"
        case .decimal:
            return "dot"
        case .zerozero:
            return "zerozero"
        case .negative:
            return "negative"
        case .delete:
            return "delete"
        case .menu:
            return "menu"
        case .percent:
            return "percent"
        }
    }
}
