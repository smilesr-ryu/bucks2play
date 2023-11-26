//
//  ButtonSize.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/10/22.
//

import Foundation
import UIKit

extension ContentView {
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .one {
            return (UIScreen.main.bounds.width - (4*15)) / 5 + 5
        } else if item == .nine {
            return (UIScreen.main.bounds.width - (4*15)) / 5 + 10
        }
        return (UIScreen.main.bounds.width - (4*15)) / 5
    }
    
    func buttonHeight(item: CalcButton) -> CGFloat {
        if item == .one {
            return (UIScreen.main.bounds.width - (4*15)) / 5 + 5
        } else if item == .nine {
            return (UIScreen.main.bounds.width - (4*15)) / 5 + 10
        }
        
        if item == .equal {
            return ((UIScreen.main.bounds.width - (4*15)) / 5) * 4 + (3*12)
        }
        
        return (UIScreen.main.bounds.width - (4*15)) / 5
    }
    
}
