//
//  AuthClient+Live.swift
//  DomainAuth
//
//
//  Created by Jiyong
//

import ComposableArchitecture
import CoreLogging
import CoreNetwork
import CoreNetworkInterface
import CoreStorage
import CoreStorageInterface
import DomainAuthInterface
import Foundation

extension AuthClient: @retroactive DependencyKey {
    public static let liveValue = AuthClient(
        signIn: { provider in
            try await performSignIn(with: provider)
        },
        loadToken: {
            try await TokenManager.shared.loadTokenFromStorage {
                guard let storedToken = try KeychainTokenStorage.shared.load() else {
                    return nil
                }
                return storedToken.toDomainToken()
            }
        },
        signOut: {
            await TokenManager.shared.clearToken()
            try KeychainTokenStorage.shared.delete()
        }
    )
}

// MARK: - Private Implementation
private extension AuthClient {
    static func performSignIn(with provider: AuthProvider) async throws -> Token {
        let logger = TXLogger(label: "Auth")
        let loginProvider = createLoginProvider(for: provider)
        let loginResult = try await loginProvider.performLogin()

        guard let identityToken = loginResult.identityToken else {
            throw AuthLoginError.missingCredential
        }

        logger.debug("identityToken: \(identityToken)")

        let endpoint = createAuthEndpoint(for: provider, identityToken: identityToken)
        let response: SignInResponse = try await NetworkProvider.shared.request(endpoint: endpoint)

        let token = Token(
            accessToken: response.accessToken,
            refreshToken: response.refreshToken,
            expiresAt: response.expiresAt
        )

        try KeychainTokenStorage.shared.save(token.toStoredToken())
        await TokenManager.shared.saveToken(token)

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

// MARK: - Helper Extensions

private extension Token {
    func toStoredToken() -> StoredToken {
        StoredToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
    }
}

private extension StoredToken {
    func toDomainToken() -> Token {
        Token(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
    }
}
