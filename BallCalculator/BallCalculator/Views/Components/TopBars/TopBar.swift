//
//  TopBar.swift
//  BallCalculator
//
//  Created by Yunki on 5/12/25.
//

import SwiftUI

struct TopBar: View {
    var title: String?
    var back: (() -> Void)?
    var close: (() -> Void)?
    
    
    var body: some View {
        HStack(alignment: .center, spacing: 2) {
            if let back {
                Button {
                    back()
                } label: {
                    Image(.back24)
                        .foregroundStyle(.black01)
                }
            }
            
            if let title {
                Text(title)
                    .fontStyle(.headline2_B)
            }
            
            Spacer()
            
            if let close {
                Button {
                    close()
                } label: {
                    Image(.close24)
                        .foregroundStyle(.black01)
                }
            }
        }
        .frame(height: 44)
        .padding(EdgeInsets(top: 12, leading: 20, bottom: 4, trailing: 20))
        .background(.white01)
    }
}

#Preview {
    TopBar(title: "타이틀을 적어주세요", back: {}, close: {})
}
