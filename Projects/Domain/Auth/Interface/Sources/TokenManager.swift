//
//  TokenManager.swift
//  DomainAuthInterface
//
//  Created by Jiyong
//

import ComposableArchitecture
import CoreStorageInterface
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
    
    public static let shared = TokenManager()

    private var cachedToken: Token?
    @Dependency(\.tokenStorage)
    var tokenStorage

    private init() {}

    /// 현재 토큰을 반환합니다.
    ///
    /// 메모리 캐시를 우선 확인하고, 없으면 nil을 반환합니다.
    /// 앱 시작 시에는 `loadTokenFromStorage()`를 호출해야 합니다.
    public var currentToken: Token? {
        cachedToken
    }

    public var accessToken: String? {
        cachedToken?.accessToken
    }

    public var refreshToken: String? {
        cachedToken?.refreshToken
    }

    public var isTokenExpired: Bool {
        guard let token = cachedToken else { return true }
        return token.expiresAt < Date()
    }

    /// 토큰을 메모리 캐시에 저장합니다.
    ///
    /// - Parameter token: 저장할 토큰
    /// - Note: 저장소 저장은 `saveTokenToStorage(_:)`에서 수행합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// await tokenManager.saveToken(token)
    /// ```
    public func saveToken(_ token: Token) {
        cachedToken = token
    }

    /// 토큰을 메모리 캐시에서 삭제합니다.
    ///
    /// - Note: 저장소 삭제는 `deleteTokenFromStorage()`에서 수행합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// await tokenManager.clearToken()
    /// ```
    public func clearToken() {
        cachedToken = nil
    }

    /// 영구 저장소에서 토큰을 로드하여 캐시합니다.
    ///
    /// - Returns: 로드된 토큰. 없으면 nil
    ///
    /// ## 사용 예시
    /// ```swift
    /// let token = try await tokenManager.loadTokenFromStorage()
    /// ```
    public func loadTokenFromStorage() async throws -> Token? {
        guard let storedToken = try tokenStorage.load() else {
            cachedToken = nil
            return nil
        }

        let token = Token(
            accessToken: storedToken.accessToken,
            refreshToken: storedToken.refreshToken,
            expiresAt: storedToken.expiresAt
        )
        cachedToken = token
        return token
    }

    /// 토큰을 저장소에 저장하고 캐시에 반영합니다.
    ///
    /// - Parameter token: 저장할 토큰
    ///
    /// ## 사용 예시
    /// ```swift
    /// try await tokenManager.saveTokenToStorage(token)
    /// ```
    public func saveTokenToStorage(_ token: Token) async throws {
        let storedToken = StoredToken(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken,
            expiresAt: token.expiresAt
        )
        try tokenStorage.save(storedToken)
        cachedToken = token
    }

    /// 토큰을 저장소에서 삭제하고 캐시를 초기화합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// try await tokenManager.deleteTokenFromStorage()
    /// ```
    public func deleteTokenFromStorage() async throws {
        try tokenStorage.delete()
        cachedToken = nil
    }

    /// 토큰을 업데이트합니다 (Refresh Token 플로우용).
    ///
    /// - Parameters:
    ///   - accessToken: 새로운 액세스 토큰
    ///   - expiresAt: 새로운 만료 시간
    /// - Note: RefreshToken은 유지됩니다
    ///
    /// ## 사용 예시
    /// ```swift
    /// await tokenManager.updateAccessToken(accessToken, expiresAt: expiresAt)
    /// ```
    public func updateAccessToken(
        _ accessToken: String,
        expiresAt: Date
    ) {
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
