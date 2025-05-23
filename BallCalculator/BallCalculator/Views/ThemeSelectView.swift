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
        VStack(spacing: 0) {
            Button {
                
            } label: {
                HStack {
                    HStack(alignment: .firstTextBaseline, spacing: 4) {
                        Text("로그인")
                            .fontStyle(.display2_B)
                        Text("하고 모든 테마를 열어보세요!")
                            .fontStyle(.body1_R)
                    }
                    
                    
                    Spacer()
                    
                    Image(.arrowRight24)
                }
                .foregroundStyle(.black01)
                .padding(.horizontal, 16)
                .padding(.vertical, 20)
            }
            
            Rectangle()
                .foregroundStyle(.black04)
                .frame(height: 1)
                .padding(.horizontal, 20)
                .padding(.top, 12)
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("자동설정")
                            .fontStyle(.body1_B)
                        
                        Text("해당기간 리그가 자동 변경됩니다.")
                            .fontStyle(.label1_R)
                            .foregroundColor(.black02)
                    }
                    
                    Spacer()
                    
                    TinyButton("기간설정", type: .secondary) {
                        
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
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("테마선택")
                            .fontStyle(.body1_B)
                        
                        Text("로그인하면 테마가 열려요!")
                            .fontStyle(.label1_R)
                            .foregroundColor(.black02)
                    }
                    
                    Spacer()
                    
                    TinyButton("작성하기", type: .secondary) {
                        
                    }
                }
                
                HStack {
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
                        
                        if Theme.allCases.last != theme {
                            Spacer()
                        }
                    }
                }
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            Spacer()
        }
        .sheet(isPresented: $isOnAutoTheme) {
            AutoThemeSelectView(isOnAutoTheme: $isOnAutoTheme, startDate: Date(), endDate: Date())
        }
    }
}

#Preview {
    ThemeSelectView(currentTheme: .constant(.aus))
}
