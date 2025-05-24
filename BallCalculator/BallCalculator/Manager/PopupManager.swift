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
    
    var activePopup: Popup?
    var toast: Toast?
}
