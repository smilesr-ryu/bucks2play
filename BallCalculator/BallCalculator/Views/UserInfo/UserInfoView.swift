//
//  UserInfoView.swift
//  BallCalculator
//
//  Created by Yunki on 5/29/25.
//

import SwiftUI

struct UserInfoView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State var authManager: AuthManager = .shared
    var popupmanager: PopupManager = .shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                ZStack {
                    
                    VStack(spacing: 0) {
                        TopBar(
                            title: "내 정보",
                            back: {
                                dismiss()
                            })
                        
                        VStack(alignment: .leading, spacing: 0) {
                            HStack {
                                Text("회원 정보")
                                    .fontStyle(.body1_B)
                                    .foregroundStyle(.black01)
                                Spacer()
                            }
                            .frame(height: 40)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("아이디")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.id ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("이름")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.name ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("이메일")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.email ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("닉네임")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.nickname ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(authManager.currentUser?.nickname == nil ? .black02 : .black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("성별")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.gender?.description ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(authManager.currentUser?.gender == nil ? .black02 : .black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            HStack(spacing: 4) {
                                Image(.benefit)
                                Image(.themeBadge)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.top, 12)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("좋아하는 선수")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.favoritePlayer ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(authManager.currentUser?.favoritePlayer == nil ? .black02 : .black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            HStack {
                                Text("내 라켓 정보")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black02)
                                    .frame(width: 112, alignment: .leading)
                                Text(authManager.currentUser?.racket ?? "미입력")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(authManager.currentUser?.racket == nil ? .black02 : .black01)
                                    .frame(width: 112, alignment: .leading)
                                Spacer()
                            }
                            .frame(height: 44)
                            .padding(.leading, 20)
                            
                            
                            NavigationLink {
                                EditUserInfoView()
                            } label: {
                                Text("수정하기")
                                    .fontStyle(.body1_B)
                                    .frame(height: 24)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 18)
                                    .foregroundStyle(.white01)
                                    .background {
                                        Color.black01
                                    }
                                    .cornerRadius(12)
                            }
                            .padding(EdgeInsets(top: 12, leading: 20, bottom: 16, trailing: 20))
                            
                        }
                        .background {
                            Color.white01
                        }
                        
                        HStack(spacing: 36) {
                            Button {
                                popupmanager.activePopup = .deleteAccount
                            } label: {
                                Text("회원탈퇴")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black01)
                                    .underline()
                            }
                            
                            Rectangle()
                                .frame(width: 1, height: 12)
                                .foregroundStyle(.black02)
                            
                            Button {
                                popupmanager.activePopup = .logout
                            } label: {
                                Text("로그아웃")
                                    .fontStyle(.label1_R)
                                    .foregroundStyle(.black01)
                                    .underline()
                            }
                        }
                        .padding(.top, 80)
                    }
                    
                }
            }
            .background {
                Color(.black05).ignoresSafeArea(edges: .bottom)
            }
        }
    }
}

#Preview {
    UserInfoView()
}
