//
//  BallCalculatorApp.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/10/10.
//

import SwiftUI

@main
struct BallCalculatorApp: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView(currentTheme: Theme.aus, selectedButton: .one)
                .onAppear {
                    print("App Start-----------------------------")
                    ThemeManager.shared.loadDatesFromUserDefaults()
                }
        }
    }
}
