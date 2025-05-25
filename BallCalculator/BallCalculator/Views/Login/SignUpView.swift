//
//  SignUpView.swift
//  BallCalculator
//
//  Created by Yunki on 5/14/25.
//

import SwiftUI

struct SignUpView: View {
    @State var id: String = ""
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var passwordCheck: String = ""
    @State var nickname: String = ""
    @State var selectedGender: Gender?
    @State var favoritePlayer: String = ""
    @State var myRacket: String = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                TopBar(
                    title: "회원가입",
                    back: {
                        
                    })
                
                HStack(spacing: 0) {
                    Spacer()
                    Text("*")
                        .foregroundStyle(.red01)
                    Text("필수입력 항목")
                        .foregroundStyle(.black02)
                }
                .font(.label1_B)
                .frame(height: 24)
                .padding(.horizontal, 20)
                
                FormTextField(
                    prompt: "5자 이상의  영문 + 숫자",
                    text: $id,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("아이디")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                FormTextField(
                    prompt: "이름 입력",
                    text: $name,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("이름")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                FormTextField(
                    prompt: "이메일 입력",
                    text: $email,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("이메일")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    trailing: { RoundedButton("인증 요청", action: {}) }
                )
                
                FormTextField(
                    prompt: "8~20자 이내의 영문 + 숫자",
                    text: $password,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("비밀번호")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    rightIcon: { Image(.eye18) }
                )
                
                FormTextField(
                    prompt: "비밀번호 재입력",
                    text: $passwordCheck,
                    title: {
                        HStack(spacing: 2) {
                            Text("*")
                                .foregroundStyle(.red01)
                            Text("비밀번호 확인")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    },
                    rightIcon: { Image(.eye18) }
                )
                
                FormTextField(
                    prompt: "닉네임 2~8자로 입력",
                    text: $nickname,
                    title: {
                        HStack(spacing: 2) {
                            Text("닉네임")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                VStack(spacing: 16) {
                    HStack {
                        Text("성별")
                            .fontStyle(.label1_R)
                            .foregroundStyle(.black01)
                        Spacer()
                    }
                    
                    HStack(spacing: 10) {
                        ForEach(Gender.allCases, id: \.rawValue) { gender in
                            HStack(spacing: 6) {
                                Button {
                                    selectedGender = gender
                                } label: {
                                    if selectedGender == gender {
                                        Image(.checked24)
                                    } else {
                                        Image(.unchecked24)
                                    }
                                }
                                
                                Text(gender.description)
                                    .fontStyle(.label1_R)
                                    .frame(height: 18)
                                    .frame(minWidth: 50, alignment: .leading)
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                
                Rectangle()
                    .foregroundStyle(.black05)
                    .frame(height: 12)
                    .padding(.vertical, 24)
                
                HStack {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(.benefit)
                        
                        Text("해당 항목 입력시 모든 테마가 열려요!")
                            .fontStyle(.label1_B)
                            .frame(height: 18)
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                FormTextField(
                    text: $favoritePlayer,
                    title: {
                        HStack(spacing: 2) {
                            Text("좋아하는 선수")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                FormTextField(
                    text: $myRacket,
                    title: {
                        HStack(spacing: 2) {
                            Text("내 라켓 정보")
                                .foregroundStyle(.black01)
                            Spacer()
                        }
                    }
                )
                
                BasicButton("회원가입", type: .primary, isEnabled: true) {
                    
                }
                .padding(EdgeInsets(top: 40, leading: 20, bottom: 56, trailing: 20))
            }
        }
        .toolbar(.hidden)
    }
}

#Preview {
    SignUpView()
}
