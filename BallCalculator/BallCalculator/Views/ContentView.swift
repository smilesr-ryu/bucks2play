//
//  ContentView.swift
//  BallCalculator
//
//  Created by Juhee Lee on 2023/10/10.
//

import SwiftUI

struct ContentView: View {
    @State var popupManager: PopupManager = .shared
    
    var body: some View {
        ZStack(alignment: .top) {
            CalculatorView(currentTheme: Theme.aus, selectedButton: .one)
            
            if let popup = popupManager.activePopup {
                popupView(for: popup)
            }
            
            if let toast = popupManager.toast {
                toastView(for: toast)
                    .task {
                        try? await Task.sleep(nanoseconds: 2_000_000_000)
                        self.popupManager.toast = nil
                    }
            }
        }
    }
    
    @ViewBuilder
    func popupView(for popup: Popup) -> some View {
        switch popup {
        case .deleteAccount:
            DeleteAccountPopup()
        case .logout:
            LogoutPopup()
        case .themeOpen:
            ThemeOpenPopup()
        case .unregisteredAccount:
            UnregisteredPopup()
        }
    }
    
    @ViewBuilder
    func toastView(for toast: Toast) -> some View {
        switch toast {
        case .passwordChanged:
            PasswordChangedToast()
        case .saved:
            SavedToast()
        case .signUpComplete:
            SignUpCompletedToast()
        }
    }
}

#Preview {
    ContentView()
}
