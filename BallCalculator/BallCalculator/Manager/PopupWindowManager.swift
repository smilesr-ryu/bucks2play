//
//  PopupWindowManager.swift
//  BallCalculator
//
//  Created by Yunki on 5/28/25.
//

import SwiftUI
import UIKit

@Observable
class PopupWindowManager {
    static let shared = PopupWindowManager()
    
    private var popupWindow: UIWindow?
    private var toastWindow: UIWindow?
    
    private init() {}
    
    // MARK: - Popup Window Methods
    func showPopup<Content: View>(@ViewBuilder content: () -> Content) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        
        // 기존 popup window가 있다면 제거
        hidePopup()
        
        // 새로운 popup window 생성
        popupWindow = UIWindow(windowScene: windowScene)
        popupWindow?.windowLevel = UIWindow.Level.alert + 1
        popupWindow?.backgroundColor = UIColor.clear
        popupWindow?.isHidden = false
        
        // SwiftUI View를 UIHostingController로 래핑
        let hostingController = UIHostingController(rootView:
            ZStack {
                // 반투명 배경
                Color.black.opacity(0.3)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        // 배경 탭 시 popup 닫기 (PopupManager를 통해)
                        PopupManager.shared.activePopup = nil
                    }
                
                // 실제 popup 내용
                content()
            }
        )
        
        hostingController.view.backgroundColor = UIColor.clear
        popupWindow?.rootViewController = hostingController
    }
    
    func hidePopup() {
        popupWindow?.isHidden = true
        popupWindow = nil
    }
    
    // MARK: - Toast Window Methods
    func showToast<Content: View>(@ViewBuilder content: () -> Content, duration: Double = 2.0) {
        guard let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first else { return }
        
        // 기존 toast window가 있다면 제거
        hideToast()
        
        // 새로운 toast window 생성
        toastWindow = UIWindow(windowScene: windowScene)
        toastWindow?.windowLevel = UIWindow.Level.alert + 2  // popup보다도 위에
        toastWindow?.backgroundColor = UIColor.clear
        toastWindow?.isHidden = false
        
        // SwiftUI View를 UIHostingController로 래핑
        let hostingController = UIHostingController(rootView:
            VStack {
                content()
                Spacer()
            }
        )
        
        hostingController.view.backgroundColor = UIColor.clear
        toastWindow?.rootViewController = hostingController
        
        // 일정 시간 후 자동으로 숨기기
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.hideToast()
        }
    }
    
    func hideToast() {
        toastWindow?.isHidden = true
        toastWindow = nil
    }
}
