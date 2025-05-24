//
//  ContentView.swift
//  BallCalculator
//
//  Created by Juhee Lee on 2023/10/10.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        CalculatorView(currentTheme: Theme.aus, selectedButton: .one)
    }
}
