//
//  ThemeManager.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/11/13.
//

import Foundation
import SwiftUI

class ThemeManager {
    static let shared = ThemeManager()
    private var startDates: [Theme: Date] = [:]
    private var endDates: [Theme: Date] = [:]
    
    private let userDefaults = UserDefaults.standard
    
    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        
        return dateFormatter
    }()
    
    private init() {
        for theme in Theme.allCases {
            startDates[theme] = self.dateFormatter.date(from: theme.startDate)
            endDates[theme] = self.dateFormatter.date(from: theme.endDate)
        }
        loadDatesFromUserDefaults()
    }
    
    // DatePicker와 연동
    func startDate(for theme: Theme) -> Binding<Date> {
        return Binding<Date>(
            get: { self.startDates[theme, default: self.dateFormatter.date(from: theme.startDate)!] },
            set: { self.startDates[theme] = $0; self.saveDatesToUserDefaults() }
        )
    }
    
    func endDate(for theme: Theme) -> Binding<Date> {
        return Binding<Date>(
            get: { self.endDates[theme, default: self.dateFormatter.date(from: theme.endDate)!] },
            set: { self.endDates[theme] = $0; self.saveDatesToUserDefaults() }
        )
    }
    
    // datePicker 값 바뀌면 자동으로 저장
    // TODO : 하나씩 저장하는 것으로 수정
    private func saveDatesToUserDefaults() {
        for (theme, date) in startDates {
            userDefaults.set(date, forKey: startDateKey(for: theme))
        }
        for (theme, date) in endDates {
            userDefaults.set(date, forKey: endDateKey(for: theme))
        }
    }
    
    // 앱 켜지면 자동으로 UserDefaults에서 설정해놓은 기간 불러옴
    func loadDatesFromUserDefaults() {
        for theme in Theme.allCases {
            if let startDate = userDefaults.object(forKey: startDateKey(for: theme)) as? Date {
                startDates[theme] = startDate
            }
            if let endDate = userDefaults.object(forKey: endDateKey(for: theme)) as? Date {
                endDates[theme] = endDate
            }
        }
    }
    
    // 오늘 날짜가 설정 기간 내에 있으면 테마 적용
    func themeForToday() -> Theme? {
        let currentDate = Date()
        for theme in Theme.allCases {
            if let startDate = startDates[theme], let endDate = endDates[theme] {
                if currentDate >= startDate && currentDate <= endDate {
                    return theme
                }
            }
        }
        return nil
    }
    
    // 기간을 초기화하는 함수
    func initializeDates() {
        for theme in Theme.allCases {
            if let startDate = dateFormatter.date(from: theme.startDate),
               let endDate = dateFormatter.date(from: theme.endDate) {
                startDates[theme] = startDate
                endDates[theme] = endDate
            }
        }
        saveDatesToUserDefaults() // 변경된 날짜를 UserDefaults에 저장
    }
    
    // UserDefaults Key
    private let startDateKeyPrefix = "StartDate_"
    private let endDateKeyPrefix = "EndDate_"
    
    private func startDateKey(for theme: Theme) -> String {
        return "\(startDateKeyPrefix)\(theme.rawValue)"
    }
    
    private func endDateKey(for theme: Theme) -> String {
        return "\(endDateKeyPrefix)\(theme.rawValue)"
    }
}
