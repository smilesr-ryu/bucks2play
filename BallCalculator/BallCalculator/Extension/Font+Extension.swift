//
//  Font+Extension.swift
//  BallCalculator
//
//  Created by Yunki on 5/4/25.
//

import SwiftUI

struct FontStyle {
    let font: Font
    let lineHeight: CGFloat
}

extension FontStyle {
    static func notoSansRegular(size: CGFloat) -> Font {
        return Font.custom("NotoSansKR-Regular", size: size)
    }
    
    static func notoSansBold(size: CGFloat) -> Font {
        return Font.custom("NotoSansKR-Bold", size: size)
    }
    
    static var textButton1_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 15), lineHeight: 20)
    }
    
    static var caption1_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 12), lineHeight: 16)
    }
    
    static var caption1_B: FontStyle {
        FontStyle(font: notoSansBold(size: 12), lineHeight: 16)
    }
    
    static var label1_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 14), lineHeight: 18)
    }
    
    static var label1_B: FontStyle {
        FontStyle(font: notoSansBold(size: 14), lineHeight: 18)
    }
    
    static var body1_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 16), lineHeight: 20)
    }
    
    static var body1_B: FontStyle {
        FontStyle(font: notoSansBold(size: 16), lineHeight: 20)
    }
    
    static var headline1_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 18), lineHeight: 22)
    }
    
    static var headline1_B: FontStyle {
        FontStyle(font: notoSansBold(size: 18), lineHeight: 22)
    }
    
    static var headline2_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 20), lineHeight: 28)
    }
    
    static var headline2_B: FontStyle {
        FontStyle(font: notoSansBold(size: 20), lineHeight: 28)
    }
    
    static var display1_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 22), lineHeight: 26)
    }
    
    static var display1_B: FontStyle {
        FontStyle(font: notoSansBold(size: 22), lineHeight: 26)
    }
    
    static var display2_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 24), lineHeight: 28)
    }
    
    static var display2_B: FontStyle {
        FontStyle(font: notoSansBold(size: 24), lineHeight: 28)
    }
    
    static var display3_R: FontStyle {
        FontStyle(font: notoSansRegular(size: 32), lineHeight: 36)
    }
    
    static var display3_B: FontStyle {
        FontStyle(font: notoSansBold(size: 32), lineHeight: 36)
    }
}
