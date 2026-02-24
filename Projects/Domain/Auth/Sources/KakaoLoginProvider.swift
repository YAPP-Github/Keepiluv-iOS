//
//  KakaoLoginProvider.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import DomainAuthInterface
import Foundation
import KakaoSDKAuth
import KakaoSDKCommon
import KakaoSDKUser

/// Kakao 로그인을 수행하는 Provider입니다.
///
/// KakaoSDK를 사용하여 카카오 OAuth 로그인을 처리하고,
/// accessToken을 획득하여 AuthLoginResult로 변환합니다.
public final class KakaoLoginProvider: SocialLoginProviderProtocol {
    public var providerType: AuthProvider { .kakao }

    public init() {}

    public func performLogin() async throws -> AuthLoginResult {
        let isKakaoTalkAvailable = await MainActor.run {
            UserApi.isKakaoTalkLoginAvailable()
        }

        if isKakaoTalkAvailable {
            return try await loginWithKakaoTalk()
        }
        return try await loginWithKakaoAccount()
    }
}

// MARK: - Private Methods

private extension KakaoLoginProvider {
    @MainActor
    func loginWithKakaoTalk() async throws -> AuthLoginResult {
        let nonce = UUID().uuidString
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoTalk(nonce: nonce) { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: AuthLoginError.providerError(error))
                    return
                }

                guard let idToken = oauthToken?.idToken else {
                    continuation.resume(throwing: AuthLoginError.missingCredential)
                    return
                }

                let result = AuthLoginResult(
                    provider: .kakao,
                    code: idToken
                )

                continuation.resume(returning: result)
            }
        }
    }

    @MainActor
    func loginWithKakaoAccount() async throws -> AuthLoginResult {
        let nonce = UUID().uuidString
        return try await withCheckedThrowingContinuation { continuation in
            UserApi.shared.loginWithKakaoAccount(nonce: nonce) { oauthToken, error in
                if let error = error {
                    continuation.resume(throwing: AuthLoginError.providerError(error))
                    return
                }

                guard let idToken = oauthToken?.idToken else {
                    continuation.resume(throwing: AuthLoginError.missingCredential)
                    return
                }

                let result = AuthLoginResult(
                    provider: .kakao,
                    code: idToken
                )

                continuation.resume(returning: result)
            }
        }
    }
}
