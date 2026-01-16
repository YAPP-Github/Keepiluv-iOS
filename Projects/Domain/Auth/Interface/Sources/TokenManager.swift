//
//  TokenManager.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import ComposableArchitecture
import Foundation

/// 토큰 상태를 관리하는 Singleton Actor입니다.
///
/// 메모리 캐시와 영구 저장소(Keychain)를 동기화하며,
/// Actor로 구현되어 동시성 안전성을 보장합니다.
///
/// ## 사용 예시
/// ```swift
/// // 토큰 저장
/// await TokenManager.shared.saveToken(token)
///
/// // 토큰 조회
/// let token = await TokenManager.shared.currentToken
///
/// // 토큰 삭제
/// await TokenManager.shared.clearToken()
/// ```
public actor TokenManager {
    /// Singleton 인스턴스
    public static let shared = TokenManager()

    /// 메모리에 캐시된 현재 토큰
    private var cachedToken: Token?

    private init() {}

    /// 현재 토큰을 반환합니다.
    ///
    /// 메모리 캐시를 우선 확인하고, 없으면 nil을 반환합니다.
    /// 앱 시작 시에는 `loadTokenFromStorage()`를 호출해야 합니다.
    public var currentToken: Token? {
        cachedToken
    }

    /// 토큰의 AccessToken을 반환합니다.
    public var accessToken: String? {
        cachedToken?.accessToken
    }

    /// 토큰의 RefreshToken을 반환합니다.
    public var refreshToken: String? {
        cachedToken?.refreshToken
    }

    /// 토큰이 만료되었는지 확인합니다.
    public var isTokenExpired: Bool {
        guard let token = cachedToken else { return true }
        return token.expiresAt < Date()
    }

    /// 토큰을 메모리 캐시에 저장합니다.
    ///
    /// - Parameter token: 저장할 토큰
    /// - Note: Keychain 저장은 별도로 수행해야 합니다 (AuthClient에서)
    public func saveToken(_ token: Token) {
        cachedToken = token
    }

    /// 토큰을 메모리 캐시에서 삭제합니다.
    ///
    /// - Note: Keychain 삭제는 별도로 수행해야 합니다 (AuthClient에서)
    public func clearToken() {
        cachedToken = nil
    }

    /// 영구 저장소에서 토큰을 로드하여 캐시합니다.
    ///
    /// - Parameter loader: Keychain에서 토큰을 로드하는 클로저
    /// - Returns: 로드된 토큰. 없으면 nil
    public func loadTokenFromStorage(loader: () async throws -> Token?) async throws -> Token? {
        let token = try await loader()
        cachedToken = token
        return token
    }

    /// 토큰을 업데이트합니다 (Refresh Token 플로우용).
    ///
    /// - Parameters:
    ///   - accessToken: 새로운 액세스 토큰
    ///   - expiresAt: 새로운 만료 시간
    /// - Note: RefreshToken은 유지됩니다
    public func updateAccessToken(_ accessToken: String, expiresAt: Date) {
        guard let currentRefreshToken = cachedToken?.refreshToken else { return }
        cachedToken = Token(
            accessToken: accessToken,
            refreshToken: currentRefreshToken,
            expiresAt: expiresAt
        )
    }
}

// MARK: - DependencyValues

public extension DependencyValues {
    var tokenManager: TokenManager {
        get { self[TokenManagerKey.self] }
        set { self[TokenManagerKey.self] = newValue }
    }
}

private enum TokenManagerKey: DependencyKey {
    static let liveValue: TokenManager = .shared
    static let testValue: TokenManager = .shared
}
