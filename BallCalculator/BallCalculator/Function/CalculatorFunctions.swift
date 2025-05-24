//
//  CalculatorFunctions.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/10/15.
//


extension CalculatorView {
    func didTap(button: CalcButton) {
        
        switch button {
            // Operation +, -, *, /, %
        case .plus, .minus, .multiply, .divide, .percent:
            
            flag = true
            
            if button == .plus {
                self.currentOperation = .add
            }
            else if button == .minus {
                self.currentOperation = .subtract
            }
            else if button == .multiply {
                self.currentOperation = .multiply
            }
            else if button == .divide {
                self.currentOperation = .divide
            }
            else if button == .percent {
                self.firstNumber = Double(self.display) ?? 0
                self.display = "\(firstNumber * (1/100))"
            }
            self.firstNumber = Double(self.display) ?? 0
            
            // =
        case .equal:
            let runningValue = self.firstNumber
            var currentValue = 0.0
            if self.display.count < 8 {
                currentValue = Double(self.display) ?? 0
            }
            var result: Double = 0.0
            
            switch self.currentOperation {
            case .add:
                result = runningValue + currentValue
            case .subtract:
                result = runningValue - currentValue
            case .multiply:
                result = runningValue * currentValue
            case .divide:
                if currentValue == 0 {
                    display = "Error"
                } else {
                    result = runningValue / currentValue
                }
            default:
                result = runningValue
                break
            }
            
            // 정수면 뒤에 소수점 .0 제거
            if result - Double(Int(result)) == 0 {
                self.display = "\(Int(result))"
            } else {
                // 부동소수점 .000000 으로 나오는 것 해결
                let resultString = String(format: "%.8f", result)
                let result = resultString.replacingOccurrences(of: "\\.?0+$", with: "", options: .regularExpression)
                self.display = "\(result)"
            }
            
            // 초기화
            self.currentOperation = nil
            firstNumber = result
            secondNumber = 0
            flag = true
            
            // C
        case .clear:
            self.display = "0"
            firstNumber = 0
            secondNumber = 0
            self.currentOperation = nil
            
            // +/-
        case .negative:
            if self.display != "0" {
                if self.display.hasPrefix("-") {
                    self.display.removeFirst()
                } else {
                    self.display = "-" + self.display
                }
            }
            
            // backspace
        case .delete:
            if self.display.count > 1 {
                self.display.removeLast()
            } else {
                self.display = "0"
            }
            
            // . (소수점)
        case .decimal:
            
            if !self.display.hasPrefix(".") {
                self.display = self.display + "."
            }

        case .menu:
            isPresented = true
            break
            
        default:
            let number = button.rawValue
           
            if flag {
                self.display = ""
                flag = false
            }
            
            if self.display == "0" {
                display = number
            } else {
                if self.display.count < 8 {
                    self.display = "\(self.display)\(number)"
                } else {
                    print("display length error")
                }
            }
            
        }
    }
}
