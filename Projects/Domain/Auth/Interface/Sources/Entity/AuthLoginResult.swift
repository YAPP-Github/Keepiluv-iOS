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
    /// 서버에 전송할 인증 코드
    /// - Apple: authorizationCode
    /// - Google: serverAuthCode
    /// - Kakao: accessToken
    public let code: String

    public init(
        provider: AuthProvider,
        code: String
    ) {
        self.provider = provider
        self.code = code
    }
}
