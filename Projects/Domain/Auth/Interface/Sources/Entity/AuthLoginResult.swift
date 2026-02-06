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
    /// 서버에 전송할 토큰
    /// - Apple: identityToken
    /// - Google: serverAuthCode
    /// - Kakao: accessToken
    public let code: String
    /// Apple 로그인 시 함께 전송할 authorizationCode
    public let authorizationCode: String?

    public init(
        provider: AuthProvider,
        code: String,
        authorizationCode: String? = nil
    ) {
        self.provider = provider
        self.code = code
        self.authorizationCode = authorizationCode
    }
}
