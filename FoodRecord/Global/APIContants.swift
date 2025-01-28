//
//  APIConstants.swift
//  VoteApp
//
//  Created by 곽서방 on 12/21/24.
//

import Foundation


struct APIConstants {
    // MARK: - Base URL
    static let baseURL = "http:/localhost:8080"
    
    // MARK: - Auth
    
    // SignUp URL
    static let signUpURL = baseURL + "/auth/signup"
    
    // loginURL URL
    
    static let loginURL = baseURL + "/auth/login"
    // AT 재발급 URL
    static let reissueURL = baseURL + "/auth/reissue"
    
    //  ID 중복체크
    static let usernameURL = baseURL + "/members/username"
    //  닉네임 중복체크
    static let nicknameURL = baseURL + "/members/nickname"
    
    //MARK: - Foods
    static let foodURL = baseURL + "/foods"
    
    
    // MARK: - Members
    
    static let updateURL = baseURL + "/members"

}
