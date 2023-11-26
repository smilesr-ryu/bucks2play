//
//  ContentView.swift
//  BallCalculator
//
//  Created by Juhee Lee on 2023/10/10.
//

import SwiftUI

struct ContentView: View {
    
    @State var display = "0"
    @State var firstNumber = 0.0
    @State var secondNumber = 0.0
    @State var currentOperation: Operation?
    @State var result: Double = 0.0
    @State var flag = false
    @State var isPresented = false
    @State var currentTheme: Theme
    @State private var buttonStates = Array(repeating: false, count: 22)
    @State var selectedButton: CalcButton
    @State var selectedImageName = ""
    let buttons: [[CalcButton]] = [
        [.clear, .seven, .four, .one, .zero],
        [.negative, .eight, .five, .two, .zerozero],
        [.percent, .nine, .six, .three, .decimal],
        [.delete, .divide, .multiply, .minus, .plus],
        [.menu, .equal]
    ]

    var body: some View {
        ZStack {
            Color(hex: currentTheme.bgColor).edgesIgnoringSafeArea(.all)
            Image("bg-asset")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Image("themelogo_"+currentTheme.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: currentTheme == .aus || currentTheme == .us ? 25 : 40)
                Spacer()
                // Text display (계산된 숫자)
                HStack {
                    Spacer()
                    // SwiftUI Text 기본 속성에 border가 없어서 shadow로 처리
                    Text(display)
                        .font(Font.custom("NotoSansKR-Bold", size: 60))
                        .shadow(color: .black, radius: 0.4)
                        .shadow(color: .black, radius: 0.4)
                        .shadow(color: .black, radius: 0.4)
                        .shadow(color: .black, radius: 0.4)
                        .shadow(color: .black, radius: 0.4)
                        .shadow(color: .black, radius: 0.4)
                        .shadow(color: .black, radius: 0.4)
                        .foregroundColor(.white)
                        .padding(20)
                        .lineLimit(1) // 텍스트를 한 줄로 제한
                        .truncationMode(.tail) // 생략 부호를 텍스트 끝에 추가
                        
                }
                .background(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                    // 내부 그림자 처리
                        .fill(
                            .shadow(.inner(color: .black.opacity(0.5), radius: 3, x: 2, y: 2))
                            .shadow(.inner(color: .black.opacity(0.5), radius: 3, x: -2, y: -2))
                        )
                        .stroke(.black, lineWidth: 1.5)
                        .foregroundColor(Color(hex: currentTheme.textBgColor))
                        .frame(height: 150)
                )
                .padding()
                
                
                // Our buttons
                HStack {
                    ForEach(buttons, id: \.self) { col in
                        VStack(spacing: 10) {
                            ForEach(col, id: \.self) { item in
                                Button(action: {
                                    if (item == .plus || item == .minus || item == .multiply || item == .divide || item == .equal) {
                                        selectedButton = item
                                    }
                                    self.didTap(button: item)
                                }, label: {
                                    if (item == .one || item == .nine || item == .plus || item == .minus || item == .divide || item == .equal || item == .zerozero || item == .negative || item == .delete || item == .menu || item == .percent || item == .multiply) {
                                        if (item == selectedButton && (item == .plus || item == .minus || item == .divide || item == .multiply)) {
                                            Image("p_"+item.imageName+"_"+currentTheme.rawValue)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: buttonWidth(item: item), height: buttonHeight(item: item))
                                                .padding(.top, item == .one ? -2: 0)
                                                .padding(.top, item == .nine ? -4: 0)
                                        } else {
                                            Image(item.imageName+"_"+currentTheme.rawValue)
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: buttonWidth(item: item), height: buttonHeight(item: item))
                                                .padding(.top, item == .one ? -2: 0)
                                                .padding(.top, item == .nine ? -4: 0)
                                        }
                                    } else {
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: buttonWidth(item: item), height: buttonHeight(item: item))
                                            .padding(.top, item == .one ? -2: 0)
                                            .padding(.top, item == .nine ? -4: 0)
                                    }
                                    
                                    
                                })
                            }
                        }
                    }
                }
                .padding(.top, 40)
                .padding(.bottom, 80)
                
            }
            
        }
        .sheet(isPresented: $isPresented) {
            ThemeSelectView(currentTheme: $currentTheme)
                .presentationDetents([.fraction(0.4)])
        }
        .onAppear {
            if let selectedThemeRawValue = UserDefaults.standard.string(forKey: "theme"),
               let selectedTheme = Theme(rawValue: selectedThemeRawValue) {
                currentTheme = selectedTheme
            } else {
                currentTheme = Theme.aus
            }
        }
    }
}
