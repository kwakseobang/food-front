//
//  SignUpView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI

//
//  InfoRegisterView.swift
//  Software_Project
//
//  Created by 곽서방 on 3/20/24.
//

/// 정리하자면 닉네임 중복확인과 이메일 인증을 거친 후 비번까지 확인. 그 후. 회원 가입 누르면 회원가입 요청 (닉네임, 이메일, 비밀번호 입
///
struct SignUpView: View {
    @StateObject private var signUpViewModel = SignUpViewModel()
    @Environment(\.presentationMode) var mode // 화면 전환
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var nickname: String = ""
    var body: some View {
        VStack{
            ScrollView {
                HeaderView()
                ShowView(
                    signUpViewModel: signUpViewModel,
                    username: $username,
                    password: $password,
                    nickname: $nickname
                )
                SignUpBtnView(
                    signUpViewModel: signUpViewModel,
                    username: $username,
                    password: $password,
                    nickname: $nickname
                )
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitle("회원가입")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading:
                    Button{
                        mode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.bkText)
                    })
            
        }
        .transition(.scale)
    }
}
// MARK: - 헤더 뷰
private struct HeaderView: View {
    fileprivate var body: some View {
        Image(systemName: "hand.thumbsup.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100)
            .padding()
        
        Text("먹은 것도 다시 보자")
            .font(.system(size: 20,weight: .semibold))
        HStack{
            Text("Food")
                .font(.system(size: 40,weight: .bold))
            Image(systemName: "hand.thumbsup.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
                .foregroundColor(.black)
            
        }
        .padding(.leading)
    }
}
// MARK: - 바디 뷰
private struct ShowView: View {
    @ObservedObject private var signUpViewModel: SignUpViewModel
    @Binding var username: String
    @Binding var password: String
    @Binding var nickname: String
    
    fileprivate init(
        signUpViewModel: SignUpViewModel,
        username: Binding<String>,
        password: Binding<String>,
        nickname: Binding<String>
    )  {
        self.signUpViewModel = signUpViewModel
        self._username = username
        self._password = password
        self._nickname = nickname
    }
    
    fileprivate var body: some View {
        VStack(alignment: .leading,spacing: 20) {
            HStack {
                InputView(
                    text: $nickname,
                    signUpViewModel: signUpViewModel,
                    title: "닉네임",
                    placeholder: "닉네임을 입력해주세요",
                    stateCheck: signUpViewModel.IscheckName
                )
                Button {
                    //TODO: - 중복 확인 API
                    signUpViewModel.nicknameRequest(nickname);
                } label: {
                    Text("중복확인")
                }
                .buttonStyle(CheckBtnStyle())
        
            }
            
            HStack {
                InputView(
                    text: $username,
                    signUpViewModel: signUpViewModel,
                    title: "아이디",
                    placeholder: "아이디룰 입력해주세요",
                    stateCheck: signUpViewModel.IsUsername
                )
                .textInputAutocapitalization(.never)
                .autocapitalization(.none)
                
                Button {
                    //TODO: - 인증 확인 API
                    signUpViewModel.usernameRequest(username);
                } label: {
                    Text( "중복 확인")
                        
                }
                .buttonStyle(CheckBtnStyle())
            }
            
            InputView(
                text: $password,
                signUpViewModel: signUpViewModel,
                title: "비밀번호",
                placeholder: "비밀번호를 8자리 이상 입력해주세요",
                isSecureField: true
            )
            .textContentType(.oneTimeCode)
            
            InputView(
                text: $signUpViewModel.confirmPassword,
                signUpViewModel: signUpViewModel,
                title: "비밀번호 확인",
                placeholder: "다시 한번 입력해주세요",
                isSecureField: true,
                checkPassword: signUpViewModel.comparePassword(password)
            )
            .textContentType(.oneTimeCode)
        }

        .padding(.bottom)
    }
}
// MARK: - 입력 뷰
private struct InputView: View {
    @Binding var text: String
    @ObservedObject  var signUpViewModel: SignUpViewModel
    @State var isPasswordCountError: Bool = false
    var title: String
    var placeholder: String
    var isSecureField = false
    var stateCheck = false
    var checkPassword = true

    fileprivate var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(.headline)
                .foregroundColor(checkPassword ? .bkText : .red )
            
            if isSecureField {
                SecureField(placeholder,text: $text)
                    .frame(width: UIScreen.main.bounds.width - 32, height: 28)
                    .font(.system(size: 15))
                    .padding(.vertical,13)
                    .background(.thinMaterial)
                    .cornerRadius(10)
                
            } else {
                HStack {
                    TextField(placeholder,text: $text)
                        .frame(width: UIScreen.main.bounds.width - 120, height: 28)
                        .font(.system(size: 15))
                        .padding(.vertical,13)
                        .background(.thinMaterial)
                        .autocapitalization(.none) // 대문자 설정 지우기
                        .cornerRadius(10)
                        .onChange(of: text) { newValue in
                                        // 텍스트가 비어있으면 상태 초기화
                                        if newValue.isEmpty {
                                            if title == "아이디" {
                                                signUpViewModel.IsUsername = false
                                            } else {
                                                signUpViewModel.IscheckName = false
                                            }
                                        }
                                    }
                        .overlay(
                            HStack{
                                Image(systemName: stateCheck ? "checkmark.circle" :"xmark.circle")
                                    .rotation3DEffect(.degrees(stateCheck ? 360 : 0), axis: (x: 0, y: 0, z: 1))
                                    .animation(.default, value: stateCheck)
                                    .foregroundColor(text.isEmpty ? .clear : stateCheck ? .blue :.red)
                                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .trailing)
                                    .padding(.trailing, 8)
                            }
                        )
                }
            }
        }
        
    }
}

//MARK: - 회원 가입 버튼 뷰
private struct SignUpBtnView: View {
    @ObservedObject var signUpViewModel: SignUpViewModel
    @Environment(\.presentationMode) var mode
    @Binding var username: String
    @Binding var password: String
    @Binding var nickname: String
    
    fileprivate init(
        signUpViewModel: SignUpViewModel,
        username: Binding<String>,
        password: Binding<String>,
        nickname: Binding<String>
    )  {
        self.signUpViewModel = signUpViewModel
        self._username = username
        self._password = password
        self._nickname = nickname
    }
 
    
    fileprivate var body: some View {
        Button {
            signUpViewModel.signupRequest(username: username, password: password, nickname: nickname)
//            if signUpViewModel.comparePassword() {
//                //TODO: - User 데이터 서버로 전송
//                signUpViewModel.sendUserDate()
//
//                mode.wrappedValue.dismiss()
//
//
//            }else {
//                //TODO: -
//            }
        } label: {
            HStack {
                Text("회원 가입")
                    .fontWeight(.semibold)
                Image(systemName: "arrow.right")
            }
            .foregroundColor(.white)
            .frame(width: UIScreen.main.bounds.width - 32, height: 48)
        }
        .background(Color(.systemBlue))
        .cornerRadius(10)
        .padding(.top,25)
        .disabled(!signUpViewModel.checkSignUpCondition(password: password))
        .opacity(signUpViewModel.checkSignUpCondition(password: password) ? 1.0 : 0.5)
    
    }
}

#Preview {
    SignUpView()
}




#Preview {
    SignUpView()
}
