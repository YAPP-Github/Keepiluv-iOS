//
//  AuthLoginResult.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import Foundation

/// 소셜 로그인 결과를 나타내는 타입입니다.
public struct AuthLoginResult: Equatable {
    public let provider: AuthProvider
    public let identityToken: String?
    public let authorizationCode: String?

    public init(
        provider: AuthProvider,
        identityToken: String,
        authorizationCode: String? = nil
    ) {
        self.provider = provider
        self.identityToken = identityToken
        self.authorizationCode = authorizationCode
    }
}
