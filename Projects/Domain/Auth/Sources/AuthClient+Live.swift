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
            @Dependency(\.tokenManager)
            var tokenManager

            try await tokenManager.deleteTokenFromStorage()
        }
    )
}

// MARK: - Private Implementation
private extension AuthClient {
    static func performSignIn(with provider: AuthProvider) async throws -> Token {
        @Dependency(\.networkClient)
        var networkClient
        @Dependency(\.tokenManager)
        var tokenManager

        let logger = TXLogger(label: "Auth")
        let loginProvider = createLoginProvider(for: provider)
        let loginResult = try await loginProvider.performLogin()

        guard let identityToken = loginResult.identityToken else {
            throw AuthLoginError.missingCredential
        }

        logger.debug("identityToken: \(identityToken)")

        let endpoint = createAuthEndpoint(for: provider, identityToken: identityToken)
        let response: SignInResponse = try await networkClient.request(endpoint: endpoint)

        let token = Token(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            expiresAt: response.expiresAt
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

    static func createAuthEndpoint(for provider: AuthProvider, identityToken: String) -> AuthEndpoint {
        switch provider {
        case .apple:
            return .signInWithApple(identityToken: identityToken)
            
        case .kakao:
            return .signInWithKakao(accessToken: identityToken)
            
        case .google:
            return .signInWithGoogle(idToken: identityToken)
        }
    }
}
