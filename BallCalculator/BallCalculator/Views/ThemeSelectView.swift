//
//  ThemeSelectView.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/10/22.
//

import SwiftUI

struct ThemeSelectView: View {
    @Binding var currentTheme: Theme
    @State var isOnAutoTheme = false
    let themeManager: ThemeManager = ThemeManager.shared
    
    let Gradients: [Color] = [Color(red: 0.46, green: 0.25, blue: 0.74).opacity(0.8),
                              Color(red: 0.91, green: 0.41, blue: 0.22).opacity(0.8),
                              Color(red: 0.64, green: 0.82, blue: 0.64).opacity(0.8),
                              Color(red: 0.47, green: 0.72, blue: 0.91).opacity(0.8),
                              Color(red: 0.46, green: 0.25, blue: 0.74).opacity(0.8)]
    
    
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading) {
                    Text("자동설정")
                        .font(Font.custom("NotoSansKR-Bold", size: 14))
                        .bold()
                    
                    
                    Text("해당기간 리그가 자동 변경됩니다.")
                        .font(Font.custom("NotoSansKR-Regular", size: 13))
                        .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                }
                
                Spacer()
                
                VStack(spacing: 10) {
                    Button(action: {
                        isOnAutoTheme.toggle()
                    }) {
                        Text("기간설정")
                            .font(Font.custom("NotoSansKR-Regular", size: 13))
                            .bold()
                            .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                            .background(
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 76, height: 28)
                                    .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                                    .cornerRadius(55)
                            )
                    }
                }
            }
            
            HStack {
                Button(action: {
                    if let todayTheme = themeManager.themeForToday() {
                        // 만약 오늘에 해당하는 테마가 있으면 그 테마로 변경
                        currentTheme = todayTheme
                        UserDefaults.standard.set(currentTheme.rawValue, forKey: "theme")
                    }
                }) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 70, height: 70)
                        .background(
                            AngularGradient(colors: Gradients, center: .center)
                        )
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .inset(by: 0.75)
                                .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1.5)
                        )
                }
                Spacer()
            }
            
            HStack {
                Text("테마선택")
                    .font(Font.custom("NotoSansKR-Bold", size: 14))
                Spacer()
            }
            
            HStack(spacing: 15) {
                ForEach(Theme.allCases, id: \.self) { theme in
                    Button {
                        currentTheme = theme
                        UserDefaults.standard.set(theme.rawValue, forKey: "theme")
                    } label: {
                        Image("logo_"+theme.rawValue)
                            .resizable()
                            .scaledToFit()
                            .padding(5)
                            .frame(width: 70, height: 70)
                            .background {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 70, height: 70)
                                    .background(.white)
                                    .cornerRadius(10)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 10)
                                            .inset(by: 0.75)
                                            .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1.5)
                                    )
                            }
                    }
                    
                    
                }
            }
        }
        .padding(.horizontal, 35)
        .sheet(isPresented: $isOnAutoTheme) {
            AutoThemeSelectView(isOnAutoTheme: $isOnAutoTheme, startDate: Date(), endDate: Date())
        }
    }
}

