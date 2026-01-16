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
@preconcurrency
public struct AuthClient: Sendable {
    /// 소셜 로그인을 수행하고 Token을 반환합니다.
    ///
    /// - Parameter provider: 로그인 제공자 (apple, kakao, google)
    /// - Returns: 발급받은 Token
    /// - Throws: AuthLoginError
    public var signIn: @Sendable (AuthProvider) async throws -> Token

    /// 저장된 Token을 불러옵니다.
    ///
    /// - Returns: 저장된 Token (없으면 nil)
    /// - Throws: KeychainError
    public var loadToken: @Sendable () async throws -> Token?

    /// 로그아웃 (Token 삭제)을 수행합니다.
    ///
    /// - Throws: KeychainError
    public var signOut: @Sendable () async throws -> Void

    public init(
        signIn: @escaping @Sendable (AuthProvider) async throws -> Token,
        loadToken: @escaping @Sendable () async throws -> Token?,
        signOut: @escaping @Sendable () async throws -> Void
    ) {
        self.signIn = signIn
        self.loadToken = loadToken
        self.signOut = signOut
    }
}

// MARK: - TestDependencyKey

extension AuthClient: TestDependencyKey {
    /// Preview에서 사용할 기본값입니다.
    public static var previewValue = Self(
        signIn: { _ in
            // Preview용 더미 Token
            Token(
                accessToken: "preview_access_token",
                refreshToken: "preview_refresh_token",
                expiresAt: Date().addingTimeInterval(3600)
            )
        },
        loadToken: { nil },
        signOut: { }
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
        }
    )
}

// MARK: - DependencyValues Extension

extension DependencyValues {
    /// AuthClient에 접근하기 위한 DependencyValues extension입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @Dependency(\.authClient) var authClient
    /// ```
    public var authClient: AuthClient {
        get { self[AuthClient.self] }
        set { self[AuthClient.self] = newValue }
    }
}
