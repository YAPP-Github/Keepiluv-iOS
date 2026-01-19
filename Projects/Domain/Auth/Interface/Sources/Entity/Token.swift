//
//  Token.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import Foundation

/// 인증 토큰을 나타내는 타입입니다.
public struct Token: Equatable, Sendable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date

    public init(
        accessToken: String,
        refreshToken: String,
        expiresAt: Date
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}
