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
    private enum Constants {
        static let uuidPrefixLength = 8
        static let oneHourInSeconds: TimeInterval = 3_600
    }

    let accessToken: String
    let refreshToken: String
    let expiresAt: Date

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
        case expiresAt = "expires_at"
        case url
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if let accessToken = try? container.decode(String.self, forKey: .accessToken),
           let refreshToken = try? container.decode(String.self, forKey: .refreshToken),
           let expiresAt = try? container.decode(Date.self, forKey: .expiresAt) {
            self.accessToken = accessToken
            self.refreshToken = refreshToken
            self.expiresAt = expiresAt
        } else {
            self.accessToken = "dummy_access_token_\(UUID().uuidString.prefix(Constants.uuidPrefixLength))"
            self.refreshToken = "dummy_refresh_token_\(UUID().uuidString.prefix(Constants.uuidPrefixLength))"
            self.expiresAt = Date().addingTimeInterval(Constants.oneHourInSeconds)
        }
    }
}
