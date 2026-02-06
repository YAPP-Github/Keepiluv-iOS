//
//  UserMeResponse.swift
//  DomainAuth
//

import Foundation

/// 내 프로필 조회 응답 DTO
struct UserMeResponse: Decodable {
    let id: Int
    let name: String
    let email: String
    let oauthProvider: String
    let oauthProviderId: String
}

/// 회원 탈퇴 응답 DTO
struct WithdrawResponse: Decodable {
    let message: String
}
