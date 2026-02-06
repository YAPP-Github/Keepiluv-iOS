//
//  AuthClient.swift
//  DomainAuthInterface
//
//
//  Created by Jiyong
//

import ComposableArchitecture
import Foundation

/// Auth 관련 비즈니스 로직을 제공하는 Client입니다.
///
/// TCA의 Dependency 시스템을 통해 주입되며,
/// 각 함수는 closure로 구현되어 테스트 시 쉽게 mock 가능합니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.authClient) var authClient
///
/// let token = try await authClient.signIn(.apple)
/// ```
/// 로그인 결과를 나타내는 타입입니다.
public struct AuthResult: Equatable, Sendable {
    public let token: Token
    public let userId: Int
    public let isNewUser: Bool

    public init(
        token: Token,
        userId: Int,
        isNewUser: Bool
    ) {
        self.token = token
        self.userId = userId
        self.isNewUser = isNewUser
    }
}

public struct AuthClient: Sendable {
    public var signIn: @Sendable (AuthProvider) async throws -> AuthResult

    public var loadToken: @Sendable () async throws -> Token?

    public var signOut: @Sendable () async throws -> Void

    public var refreshToken: @Sendable () async throws -> Token

    public init(
        signIn: @escaping @Sendable (AuthProvider) async throws -> AuthResult,
        loadToken: @escaping @Sendable () async throws -> Token?,
        signOut: @escaping @Sendable () async throws -> Void,
        refreshToken: @escaping @Sendable () async throws -> Token
    ) {
        self.signIn = signIn
        self.loadToken = loadToken
        self.signOut = signOut
        self.refreshToken = refreshToken
    }
}

// MARK: - TestDependencyKey

extension AuthClient: TestDependencyKey {
    private static let oneHourInSeconds: TimeInterval = 3_600

    /// Preview에서 사용할 기본값입니다.
    public static var previewValue = Self(
        signIn: { _ in
            // Preview용 더미 AuthResult
            AuthResult(
                token: Token(
                    accessToken: "preview_access_token",
                    refreshToken: "preview_refresh_token",
                    expiresAt: Date().addingTimeInterval(oneHourInSeconds)
                ),
                userId: 1,
                isNewUser: true
            )
        },
        loadToken: { nil },
        signOut: { },
        refreshToken: {
            Token(
                accessToken: "preview_refreshed_token",
                refreshToken: "preview_refresh_token",
                expiresAt: Date().addingTimeInterval(oneHourInSeconds)
            )
        }
    )

    /// 테스트에서 사용할 기본값입니다.
    /// 테스트 시에는 withDependencies로 override해야 합니다.
    public static let testValue = Self(
        signIn: { _ in
            assertionFailure("AuthClient.signIn이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            throw AuthLoginError.unsupportedProvider
        },
        loadToken: {
            assertionFailure("AuthClient.loadToken이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            return nil
        },
        signOut: {
            assertionFailure("AuthClient.signOut이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
        },
        refreshToken: {
            assertionFailure("AuthClient.refreshToken이 구현되지 않았습니다. withDependencies로 mock을 주입하세요.")
            throw AuthLoginError.tokenRefreshFailed
        }
    )
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
