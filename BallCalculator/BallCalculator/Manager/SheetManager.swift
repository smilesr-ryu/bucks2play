//
//  SheetManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/28/25.
//

import SwiftUI

@Observable
class SheetManager {
    static var shared: SheetManager = .init()
    
    var themeSelectSheetIsPresented: Bool = false
    var autoThemeSelectSheetIsPresented: Bool = false
    
    var loginSheetIsPresented: Bool = false
    var userInfoSheetIsPresented: Bool = false
    
    /// 모든 sheet를 닫는 메서드
    func dismissAllSheets() {
        themeSelectSheetIsPresented = false
        autoThemeSelectSheetIsPresented = false
        loginSheetIsPresented = false
        userInfoSheetIsPresented = false
    }
}
