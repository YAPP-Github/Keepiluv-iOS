//
//  SocialLoginProviderProtocol.swift
//  DomainAuthInterface
//
//
//  Created by Jiyong
//

import Foundation

/// 소셜 로그인 제공자(Provider)의 공통 인터페이스를 정의합니다.
///
/// Apple, Kakao 등 각 OAuth 제공자는 이 프로토콜을 구현하여
/// SDK와의 통신을 담당합니다.
///
/// ## 책임
/// - OAuth SDK를 사용하여 로그인 수행
/// - identityToken 또는 authorizationCode 획득
/// - 로그인 결과를 `AuthLoginResult`로 변환
public protocol SocialLoginProviderProtocol {
    /// 이 Provider가 지원하는 소셜 로그인 타입입니다.
    var providerType: AuthProvider { get }

    /// 소셜 로그인을 수행합니다.
    ///
    /// - Returns: 로그인 결과 (identityToken, userID 등)
    /// - Throws: 로그인 실패 시 `AuthLoginError`
    func performLogin() async throws -> AuthLoginResult
}
