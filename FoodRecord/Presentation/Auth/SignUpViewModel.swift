////
////  SignUpViewModel.swift
////  Software_Project
////
////  Created by 곽서방 on 3/24/24.
////
//
import Foundation
import SwiftUI
import Alamofire


class SignUpViewModel: ObservableObject {
//    @Published var user: User
    
    @Published var confirmPassword: String
    @Published var IscheckName: Bool = false
    @Published var IsUsername: Bool = false
    
    init(
         IscheckName: Bool = false,
         IsEmailName: Bool = false,
         confirmPassword: String = ""
    ) {
        self.IscheckName = IscheckName
        self.IsUsername = IsEmailName
        self.confirmPassword = confirmPassword
    }
    
    
}

extension SignUpViewModel {
    //모든 입력창에 입력 됐을 시 회원가입 버튼 활성화
    func checkSignUpCondition (password: String) -> Bool {
        if comparePassword(password) && IscheckName && IsUsername && password.count > 7 {
            // TODO: - 서버로 회원 정보 전송
            print("회원가입 완료")
            return true
        }
        return false
    }
    
    // Email 인증 (실패 시 x표시 애니메이션 추가)
    func checkUsername() -> Void {
        // TODO: - API 요청 후 유효할 경우 true
        IsUsername.toggle()
        print("username",IsUsername)
    }
    // 닉네임 중복체크 (실패 시 x표시 애니메이션 추가)
    func checkName() -> Void {
        //TODO: - 닉네임 중복체크 API 요청
        IscheckName.toggle()
//        print("",IscheckName)
    }
    
    // 패스워드 비교
    func comparePassword(_ password: String) -> Bool {
        print("comparePassword", password == confirmPassword)
        return password == confirmPassword
    }
    // ID 중복체크
    func usernameRequest(_ username: String) -> Void {
        print("signupRequest..")
        
        guard let url = URL(string:APIConstants.usernameURL+"/\(username)") else {
            print("Invalid URL")
            return
        }
        let header: HTTPHeaders = [
               "Content-Type" : "application/json"
           ]
        AF.request(url, method: .get,encoding: JSONEncoding.default,headers: header)
            .validate(statusCode: 200..<300) // 유효성 검사
            .responseData{ response in
                switch response.result {
                case .success(_):
                    self.IsUsername = true
                    print("유효한 ID")
                case .failure(_):
                    print("중복된 ID")
                    self.IsUsername = false
               
                }
                print("POST DEBUG : \(response)")
            }
    }
    func nicknameRequest(_ nickname: String) -> Void {
        print("signupRequest..")
        
        guard let url = URL(string:APIConstants.nicknameURL+"/\(nickname)") else {
            print("Invalid URL")
            return
        }
        let header: HTTPHeaders = [
               "Content-Type" : "application/json"
           ]
        AF.request(url, method: .get,encoding: JSONEncoding.default,headers: header)
            .validate(statusCode: 200..<300) // 유효성 검사
            .responseData{ response in
                switch response.result {
                case .success(_):
                    
                    print("유효한 닉네임")
                    self.IscheckName = true
                case .failure(_):
                    print("중복된 닉네임")
                    self.IscheckName = false
                }
                print("POST DEBUG : \(response)")
            }
    }
    
    // user Data 서버로 전송
    func signupRequest(username:String, password:String, nickname: String) -> Void {
        print("signupRequest..")
        
        guard let url = URL(string:APIConstants.signUpURL) else {
            print("Invalid URL")
            return
        }
        let header: HTTPHeaders = [
               "Content-Type" : "application/json"
           ]

        let parameters: [String: Any] = [
            "username": username,
            "password": password,
            "nickname": nickname
        ]
        print(parameters)
        AF.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header)
            .validate(statusCode: 200..<300) // 유효성 검사
//            .responseDecodable(of: Auth.SignUpResponse.self){ response in
//                switch response.result {
//        
//                case .success(_):
//                    print("회원가입 성공")
//                case .failure(_):
//                    print("회원가입 실패")
//               
//                }
//                print("POST DEBUG : \(response)")
//            }

    }

}
