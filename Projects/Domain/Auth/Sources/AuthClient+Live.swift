//
//  AuthClient+Live.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import ComposableArchitecture
import CoreLogging
import CoreNetworkInterface
import DomainAuthInterface
import Foundation

extension AuthClient: @retroactive DependencyKey {
    public static let liveValue = AuthClient(
        signIn: { provider in
            try await performSignIn(with: provider)
        },
        loadToken: {
            @Dependency(\.tokenManager)
            var tokenManager

            return try await tokenManager.loadTokenFromStorage()
        },
        signOut: {
            @Dependency(\.networkClient)
            var networkClient
            @Dependency(\.tokenManager)
            var tokenManager

            // 서버에 로그아웃 요청 (실패해도 로컬 토큰은 삭제)
            do {
                let _: EmptyResponse = try await networkClient.request(endpoint: AuthEndpoint.logout)
            } catch {
                // 서버 로그아웃 실패는 무시하고 로컬 토큰만 삭제
                TXLogger(label: "Auth").info("서버 로그아웃 실패 (무시됨): \(error)")
            }

            try await tokenManager.deleteTokenFromStorage()
        },
        refreshToken: {
            try await performRefreshToken()
        },
        withdraw: {
            @Dependency(\.networkClient)
            var networkClient
            @Dependency(\.tokenManager)
            var tokenManager

            let _: WithdrawResponse = try await networkClient.request(endpoint: AuthEndpoint.withdraw)
            try await tokenManager.deleteTokenFromStorage()
        },
        fetchMyProfile: {
            @Dependency(\.networkClient)
            var networkClient

            let response: UserMeResponse = try await networkClient.request(endpoint: AuthEndpoint.me)
            return UserProfile(
                id: response.id,
                name: response.name,
                email: response.email
            )
        }
    )
}

// MARK: - Private Implementation
private extension AuthClient {
    static let oneHourInSeconds: TimeInterval = 3_600

    static func performSignIn(with provider: AuthProvider) async throws -> AuthResult {
        @Dependency(\.networkClient)
        var networkClient
        @Dependency(\.tokenManager)
        var tokenManager

        let logger = TXLogger(label: "Auth")
        let loginProvider = createLoginProvider(for: provider)
        let loginResult = try await loginProvider.performLogin()

        logger.debug("loginResult: \(loginResult)")

        let endpoint = createAuthEndpoint(from: loginResult)
        let response: SignInResponse = try await networkClient.request(endpoint: endpoint)

        let token = Token(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            expiresAt: Date().addingTimeInterval(oneHourInSeconds)
        )

        try await tokenManager.saveTokenToStorage(token)

        return AuthResult(
            token: token,
            userId: response.userId,
            isNewUser: response.isNewUser
        )
    }

    static func performRefreshToken() async throws -> Token {
        @Dependency(\.networkClient)
        var networkClient
        @Dependency(\.tokenManager)
        var tokenManager

        guard let currentRefreshToken = await tokenManager.refreshToken else {
            throw AuthLoginError.tokenRefreshFailed
        }

        let endpoint = AuthEndpoint.refresh(refreshToken: currentRefreshToken)
        let response: RefreshResponse = try await networkClient.request(endpoint: endpoint)

        let token = Token(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            expiresAt: Date().addingTimeInterval(oneHourInSeconds)
        )

        try await tokenManager.saveTokenToStorage(token)

        return token
    }

    static func createLoginProvider(for provider: AuthProvider) -> SocialLoginProviderProtocol {
        switch provider {
        case .apple:
            return AppleLoginProvider()

        case .kakao:
            return KakaoLoginProvider()

        case .google:
            return GoogleLoginProvider()
        }
    }

    static func createAuthEndpoint(from loginResult: AuthLoginResult) -> AuthEndpoint {
        switch loginResult.provider {
        case .apple:
            return .signInWithApple(
                idToken: loginResult.code,
                authorizationCode: loginResult.authorizationCode ?? ""
            )

        case .kakao:
            return .signInWithKakao(idToken: loginResult.code)

        case .google:
            return .signInWithGoogle(idToken: loginResult.code)
        }
    }
}

// MARK: - Empty Response

/// 빈 응답을 위한 타입
struct EmptyResponse: Decodable {}
