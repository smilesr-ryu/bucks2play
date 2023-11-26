import SwiftUI

struct AutoThemeSelectView: View {
    @Binding var isOnAutoTheme: Bool
    let themeManager: ThemeManager = ThemeManager.shared
    @State var startDate: Date
    @State var endDate: Date
    
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            Image("ball")
                .resizable()
                .scaledToFit()
                .frame(width: 70, height: 70)
            
            ForEach(Theme.allCases, id: \.self) { theme in
                HStack {
                    Image("logo_" + theme.rawValue)
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
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(theme.periodName)
                            .font(Font.custom("NotoSansKR-Regular", size: 14))
                            .bold()
                            .padding(.leading, 7)
                        
                        HStack {
                            DatePicker("시작일", selection: themeManager.startDate(for: theme), displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact) // compact style 사용
                                .frame(maxWidth: .infinity) // 최대 폭 지정
                            
                            Text("~")
                            
                            DatePicker("종료일", selection: themeManager.endDate(for: theme), displayedComponents: .date)
                                .labelsHidden()
                                .datePickerStyle(.compact)
                                .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal, 5)
                    }
                }
                .padding(.horizontal, 5)
            }
            
            VStack(spacing: 70) {
                Button(action: {
                    themeManager.initializeDates()
                    isOnAutoTheme.toggle()
                }) {
                    Text("대회 기간으로 초기화")
                        .font(Font.custom("NotoSansKR-Regular", size: 13))
                        .bold()
                        .foregroundColor(Color(red: 0.93, green: 0.93, blue: 0.93))
                        .background(
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 350, height: 70)
                                .background(Color(red: 0.34, green: 0.34, blue: 0.34))
                                .cornerRadius(20)
                        )
                }
                
                
                Button(action: {
                    isOnAutoTheme.toggle()
                }) {
                    Text("창닫기")
                        .font(Font.custom("NotoSansKR-Regular", size: 13))
                        .bold()
                        .foregroundColor(Color(red: 0.34, green: 0.34, blue: 0.34))
                        .background(
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 350, height: 70)
                                .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                                .cornerRadius(20)
                        )
                }
            }
            .padding(.top, 40)
            
        }
        .padding(10)
    }
}
