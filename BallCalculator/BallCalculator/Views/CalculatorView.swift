//
//  CalculatorView.swift
//  BallCalculator
//
//  Created by Yunki on 5/24/25.
//

import SwiftUI

struct CalculatorView: View {
    
    @State var display = "0"
    @State var firstNumber = 0.0
    @State var secondNumber = 0.0
    @State var currentOperation: Operation?
    @State var result: Double = 0.0
    @State var flag = false
    @State var currentTheme: Theme
    @State var selectedButton: CalcButton
    @State var selectedImageName = ""
    let buttons: [[CalcButton]] = [
        [.clear, .seven, .four, .one, .menu],
        [.negative, .eight, .five, .two, .zerozero],
        [.percent, .nine, .six, .three, .decimal],
        [.divide, .multiply, .minus, .plus, .equal]
    ]
    
    @Bindable var sheetManager: SheetManager = .shared
    
    var body: some View {
        ZStack {
            Color(hex: currentTheme.bgColor).edgesIgnoringSafeArea(.all)
            Image("bg-asset")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                //                Spacer()
                VStack(spacing: 16) {
                    Image("themelogo_"+currentTheme.rawValue)
                        .resizable()
                        .frame(width: 130, height: 40)
                        .padding(.top, 20)
                    
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
                            .frame(height: 137)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 54)
                
                Spacer()
                
                // Our buttons
                HStack(spacing: 10) {
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
                                        Image(item.imageName+"_"+currentTheme.rawValue)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .scaleEffect(item == .nine ? 1.2 : 1.0)
                                            .offset(x: item == .nine ? 2 : 0, y: item == .nine ? -8 : 0)
                                    } else {
                                        Image(item.imageName)
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
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
        .sheet(isPresented: $sheetManager.themeSelectSheetIsPresented) {
            ThemeSelectView(currentTheme: $currentTheme)
                .presentationDetents([.fraction(0.6)])
                .presentationDragIndicator(.visible)
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

#Preview {
    CalculatorView(currentTheme: .aus, selectedButton: .clear)
}
