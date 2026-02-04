//
//  SignInResponse.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import Foundation

/// 로그인 응답 DTO
struct SignInResponse: Decodable {
    let userId: Int
    let accessToken: String
    let refreshToken: String
    let isNewUser: Bool
}

/// 토큰 갱신 응답 DTO
struct RefreshResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
