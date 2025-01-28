//
//  SplashView.swift
//  FoodRecord
//
//  Created by 곽서방 on 1/28/25.
//

//
//  LoginView.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    @StateObject private var pathModel = PathModel()
    @State var username: String = ""
    @State var password: String = ""
    var body: some View {
        NavigationStack(path: $pathModel.tabPaths){
            VStack {
                TitleView()
                    .padding(.top,40)
                Spacer()
                    .frame(height: 30)
                LoginInputView(username: $username, password: $password)
                
                LoginTabView(username: $username, password: $password)
                    .padding(.vertical,5)
            
                Spacer()
                    .frame(height: 50)
                CreateInfoBtnView()
            }
            .navigationDestination(for: PathType.self) { pathType in
                switch pathType {
                case .homeView:
                    EmptyView()
                        .navigationBarBackButtonHidden()
                // TODO: - 경로 추가 예정
                case .voteListView:
                    EmptyView()
                        
                        .environmentObject(loginViewModel)
                case .settingView:
                    EmptyView()
                        
                        
                        .environmentObject(loginViewModel)
                case .voteCreateView:
                    EmptyView()
                        
                        .environmentObject(loginViewModel)
                }
            }
        }
        .environmentObject(pathModel)
    }
}
//MARK: - 헤더 뷰
private struct TitleView: View {
    fileprivate var body: some View {
        ZStack {
            VStack{
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .foregroundColor(Color("fontColor"))
                    .padding()
                
                Text("먹은 것도 다시 보자")
                    .font(.system(size: 20,weight: .semibold))
//                    .foregroundColor(Color("mainColor"))
                HStack{
                    Text("Food")
                        .font(.system(size: 40,weight: .bold))
                        .foregroundColor(Color("fontColor"))
                    Image(systemName: "hand.thumbsup.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30)
                        .foregroundColor(Color("fontColor"))

                }
                .padding(.leading)
            }
        }
    }
}
//MARK: - 아이디 비밀번호 입력 뷰
private struct LoginInputView: View {
    @Binding var username: String
    @Binding var password: String
    
    fileprivate var body: some View {
        // ID 텍스트 필드
        VStack(spacing:15){
            TextField("아이디", text: $username)
                .frame(width: UIScreen.main.bounds.width - 50, height: 20)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .keyboardType(.default) //email 형식으로 입력 받도록
                .textCase(.lowercase)
                .autocapitalization(.none) // 대문자 설정 지우기
                .disableAutocorrection(false) // 자동 수정 설정 해제
                .textInputAutocapitalization(.never)
             
            SecureField("비밀번호", text: $password)
                .frame(width: UIScreen.main.bounds.width - 50, height: 20)
                .padding()
                .background(.thinMaterial)
                .cornerRadius(10)
                .autocapitalization(.none)
            
        }
    }
    
}
// MARK: - 로그인 탭 뷰
private struct LoginTabView: View {
    @EnvironmentObject private var pathModel: PathModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @Binding var username: String
    @Binding var password: String
    @State private var isShowingAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @State private var tag: Int? = nil
    
    fileprivate var body: some View {
        Button {
            loginViewModel.loginRequest(username: username, password: password) { isSuccess in
                if isSuccess {
                    // 로그인 성공 후 access token을 가져와서 처리
//                    let at = UserDefaultsManager.getData(type: String.self, forKey: .accessToken) ?? "사용자"
//                    print("accessToken: " + at)
                    
                    // 탭에 homeView 추가
//                    if !pathModel.tabPaths.contains(.homeView) {
                        pathModel.tabPaths.append(.homeView)
//                    }
                } else {
                    // 로그인 실패, 얼럿 표시
                    alertMessage = "로그인 실패. 다시 시도해주세요."
                    isShowingAlert = true
                }
            }
        } label: {
            HStack {
                Text("Login")
                Image(systemName: "house")
            }
        }

        .disabled((username.isEmpty || password.isEmpty) ? true : false) // 둘 다 입력 시
        .font(.system(size: 20,weight: .bold))
        .frame(width: 330,height: 20)
        .padding()
        .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.clear, lineWidth: 2) // 외곽선 둥글게
        )
        .background(Color((username.isEmpty || password.isEmpty) ? "sky_bg": "mainColor"))
        .foregroundColor(.white)
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("로그인 실패"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
        }
    }
}

// MARK: - 회원가입 뷰
private struct CreateInfoBtnView: View {
    fileprivate var body: some View {
        
        HStack{
            Text("아직 회원이 아니신가요?")
                .font(.system(size: 14))
                .foregroundColor(.gray)
            NavigationLink {
                SignUpView()
            }label: {
                Text("회원가입 >")
                    .foregroundColor(Color("mainColor"))
            }
        }
        
        Spacer()
        
    }
}
#Preview {
    LoginView()
        .environmentObject(LoginViewModel())
}
