//
//  Theme.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/10/22.
//

import Foundation

enum Theme: String, CaseIterable {
    case aus = "aus"
    case rol = "rol"
    case wim = "wim"
    case us = "us"
    
    var bgColor: String {
        switch self {
        case .aus: "#7FBCE9"
        case .rol: "E86938"
        case .wim: "753FBD"
        case .us: "A2D0A2"
        }
    }
    
    var textBgColor: String {
        switch self {
        case .aus: "#7FBCE9"
        case .rol: "E86938"
        case .wim: "753FBD"
        case .us: "86A7E4"
        }
    }
    
    var periodName: String {
        switch self {
        case .aus: "Aus open"
        case .rol: "Roland garros"
        case .wim: "Wimbledon"
        case .us: "US open"
        }
    }
    
    var startDate: String {
        switch self {
        case .aus: "2024-01-15"
        case .rol: "2024-05-26"
        case .wim: "2024-07-01"
        case .us: "2024-08-26"
        }
    }
    
    var endDate: String {
        switch self {
        case .aus: "2024-01-28"
        case .rol: "2024-06-09"
        case .wim: "2024-07-14"
        case .us: "2024-09-08"
        }
    }
}
