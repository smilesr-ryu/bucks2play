//
//  PopupManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/22/25.
//

import SwiftUI

@Observable
class PopupManager {
    static var shared = PopupManager()
    
    private var _activePopup: Popup?
    private var _toast: Toast?
    
    var activePopup: Popup? {
        get { _activePopup }
        set {
            _activePopup = newValue
            if let popup = newValue {
                showPopupInWindow(popup)
            } else {
                PopupWindowManager.shared.hidePopup()
            }
        }
    }
    
    var toast: Toast? {
        get { _toast }
        set {
            _toast = newValue
            if let toast = newValue {
                showToastInWindow(toast)
            } else {
                PopupWindowManager.shared.hideToast()
            }
        }
    }
    
    private func showPopupInWindow(_ popup: Popup) {
        PopupWindowManager.shared.showPopup {
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
    }
    
    private func showToastInWindow(_ toast: Toast) {
        PopupWindowManager.shared.showToast {
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
}
