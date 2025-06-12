//
//  ThemeSelectView.swift
//  BallCalculator
//
//  Created by 이주희 on 2023/10/22.
//

import SwiftUI

struct ThemeSelectView: View {
    @State var authManager: AuthManager = .shared
    
    @Binding var currentTheme: Theme

    let themeManager: ThemeManager = ThemeManager.shared
    let popupManager: PopupManager = PopupManager.shared
    
    @Bindable var sheetManager: SheetManager = .shared
    
    let Gradients: [Color] = [Color(red: 0.46, green: 0.25, blue: 0.74).opacity(0.8),
                              Color(red: 0.91, green: 0.41, blue: 0.22).opacity(0.8),
                              Color(red: 0.64, green: 0.82, blue: 0.64).opacity(0.8),
                              Color(red: 0.47, green: 0.72, blue: 0.91).opacity(0.8),
                              Color(red: 0.46, green: 0.25, blue: 0.74).opacity(0.8)]
    
    
    var body: some View {
        VStack(spacing: 0) {
            if let user = authManager.currentUser {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("반가워요!")
                            .fontStyle(.label1_B)
                            .foregroundStyle(.black02)
                            .frame(height: 18)
                        Text("\(user.nickname == nil || user.nickname!.isEmpty ? user.name : user.nickname!) 님")
                            .fontStyle(.display2_B)
                            .frame(height: 28)
                    }
                    
                    Spacer()
                    
                    TinyButton("내 정보", type: .primary) {
                        sheetManager.userInfoSheetIsPresented = true
                    }
                }
                .foregroundStyle(.black01)
                .padding(EdgeInsets(top: 32, leading: 16, bottom: 32, trailing: 20))
            } else {
                Button {
                    sheetManager.loginSheetIsPresented = true
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
                .padding(.vertical, 12)
            }
            
            Rectangle()
                .foregroundStyle(.black04)
                .frame(height: 1)
                .padding(.horizontal, 20)
            
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
                        sheetManager.autoThemeSelectSheetIsPresented = true
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
                        
                        if authManager.currentUser == nil {
                            Text("로그인하면 테마가 열려요!")
                                .fontStyle(.label1_R)
                                .foregroundColor(.black02)
                        } else if authManager.currentUser?.favoritePlayer == nil || authManager.currentUser?.racket == nil {
                            Text("benefit을 작성하면 테마가 열려요!")
                                .fontStyle(.label1_R)
                                .foregroundColor(.black02)
                        }
                    }
                    
                    Spacer()
                    
                    if authManager.currentUser != nil,  authManager.currentUser?.favoritePlayer == nil || authManager.currentUser?.racket == nil {
                        TinyButton("작성하기", type: .secondary) {
                            sheetManager.userInfoSheetIsPresented = true
                        }
                    }
                }
                
                HStack {
                    ForEach(Theme.allCases, id: \.self) { theme in
                        if authManager.currentUser == nil {
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
                                .overlay {
                                    if theme != .aus {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 10)
                                                .foregroundStyle(Color(hex: theme.lockedColor).opacity(0.6))
                                            Image(.lock)
                                        }
                                    }
                                }
                        } else if authManager.currentUser?.favoritePlayer == nil || authManager.currentUser?.racket == nil {
                            Button {
                                popupManager.activePopup = .themeOpen
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
                                    .overlay {
                                        if theme != .aus {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundStyle(Color(hex: theme.lockedColor).opacity(0.6))
                                                Image(.lock)
                                            }
                                        }
                                    }
                            }
                        } else {
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
        .fullScreenCover(isPresented: $sheetManager.autoThemeSelectSheetIsPresented) {
            AutoThemeSelectView(isOnAutoTheme: $sheetManager.autoThemeSelectSheetIsPresented, startDate: Date(), endDate: Date())
        }
        .fullScreenCover(isPresented: $sheetManager.loginSheetIsPresented) {
            LoginView()
        }
        .fullScreenCover(isPresented: $sheetManager.userInfoSheetIsPresented) {
            UserInfoView()
        }
    }
}

#Preview {
    ThemeSelectView(currentTheme: .constant(.aus))
}
