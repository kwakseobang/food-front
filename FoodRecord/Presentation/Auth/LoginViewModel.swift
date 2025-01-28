//
//  LoginViewModel.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import Foundation
import Alamofire
class LoginViewModel: ObservableObject {
    @Published var IsLogin: Bool
    init(IsLogin: Bool = false) {
        self.IsLogin = IsLogin
    }
}

extension LoginViewModel {
    func checkLogin() -> Void {
        // TODO: - API 요청 후 유효할 경우 true
        IsLogin.toggle()
        print("username",IsLogin)
    }
    func loginRequest(username: String, password: String,completion: @escaping (Bool) -> Void){
        print(username)
        print(password)
        guard let url = URL(string:APIConstants.loginURL) else {
            print("Invalid URL")
            completion(false)
            return
        }
        let header: HTTPHeaders = [
               "Content-Type" : "application/json"
           ]

        let parameters: [String: Any] = [
            "username": username,
            "password": password
        ]
//        print(parameters)
//        AF.request(url, method: .post, parameters: parameters,encoding: JSONEncoding.default,headers: header)
//            .validate(statusCode: 200..<300) // 유효성 검사
//            .responseDecodable(of: Auth.TokenResponse.self){ response in
//                switch response.result {
//
//                case .success(let result):
//                    self.IsLogin = true
//                    print("로그인 성공")
//                    UserDefaultsManager.setData(value: result.data?.accessToken, key: .accessToken) // 토큰 저장
//                    completion(true)  // 로그인 성공 시 completion handler 호출
//                case .failure(_):
//                    self.IsLogin = false
//                    print("로그인 실패")
//                    completion(false)  // 로그인 실패 시 completion handler 호출
//               
//                }
//                
//            }
    }
}

