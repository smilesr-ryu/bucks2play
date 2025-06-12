import SwiftUI

struct AutoThemeSelectView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var isOnAutoTheme: Bool
    let themeManager: ThemeManager = ThemeManager.shared
    @State var startDate: Date
    @State var endDate: Date
    
    var body: some View {
        VStack(spacing: 0) {
            TopBar(title: "기간 설정", close:  {
                dismiss()
            })
            
            ForEach(Theme.allCases, id: \.self) { theme in
                HStack(spacing: 14) {
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
                    
                    VStack(alignment: .leading, spacing: 14) {
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
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
            }
            
            Spacer()
            
            HStack(spacing: 16) {
                BasicButton("대회기간 초기화", type: .secondary) {
                    themeManager.initializeDates()
                    isOnAutoTheme.toggle()
                }
                BasicButton("저장하기", type: .primary) {
                    themeManager.initializeDates()
                    isOnAutoTheme.toggle()
                }
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            
        }
        .padding(10)
    }
}

#Preview {
    AutoThemeSelectView(isOnAutoTheme: .constant(true), startDate: .now, endDate: .now)
}
