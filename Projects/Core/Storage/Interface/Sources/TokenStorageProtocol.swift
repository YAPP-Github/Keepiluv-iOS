//
//  TokenStorageProtocol.swift
//  CoreStorageInterface
//
//
//  Created by Jiyong
//

import ComposableArchitecture
import Foundation

/// 저장소에 저장되는 토큰 데이터 구조입니다.
///
/// Core 계층에서 정의하여 Domain 계층에 의존하지 않도록 합니다.
public struct StoredToken: Codable, Equatable {
    public let accessToken: String
    public let refreshToken: String
    public let expiresAt: Date

    public init(
        accessToken: String,
        refreshToken: String,
        expiresAt: Date
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresAt = expiresAt
    }
}

/// Token 저장소 인터페이스를 정의합니다.
///
/// Keychain, UserDefaults 등 다양한 저장소 구현체로 교체 가능합니다.
public protocol TokenStorageProtocol {
    /// Token을 저장소에 저장합니다.
    ///
    /// - Parameter token: 저장할 토큰
    /// - Throws: 저장 실패 시 에러
    ///
    /// ## 사용 예시
    /// ```swift
    /// try tokenStorage.save(token)
    /// ```
    func save(_ token: StoredToken) throws

    /// 저장소에서 Token을 불러옵니다.
    ///
    /// - Returns: 저장된 토큰. 없으면 nil
    /// - Throws: 불러오기 실패 시 에러
    ///
    /// ## 사용 예시
    /// ```swift
    /// let token = try tokenStorage.load()
    /// ```
    func load() throws -> StoredToken?

    /// 저장소에서 Token을 삭제합니다.
    ///
    /// - Throws: 삭제 실패 시 에러
    ///
    /// ## 사용 예시
    /// ```swift
    /// try tokenStorage.delete()
    /// ```
    func delete() throws
}

/// TCA Dependency로 주입 가능한 토큰 저장소 클라이언트입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.tokenStorage) var tokenStorage
/// try tokenStorage.save(token)
/// ```
public struct TokenStorageClient: Sendable {
    private let storage: any TokenStorageProtocol

    public init(storage: any TokenStorageProtocol) {
        self.storage = storage
    }

    /// Token을 저장소에 저장합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// try tokenStorage.save(token)
    /// ```
    public func save(_ token: StoredToken) throws {
        try storage.save(token)
    }

    /// 저장소에서 Token을 불러옵니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let token = try tokenStorage.load()
    /// ```
    public func load() throws -> StoredToken? {
        try storage.load()
    }

    /// 저장소에서 Token을 삭제합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// try tokenStorage.delete()
    /// ```
    public func delete() throws {
        try storage.delete()
    }
}

private enum TokenStorageClientError: Error {
    case unimplemented
}

private struct UnimplementedTokenStorage: TokenStorageProtocol {
    func save(_ token: StoredToken) throws {
        assertionFailure("TokenStorageClient.save is unimplemented. Use withDependencies to override.")
        throw TokenStorageClientError.unimplemented
    }

    func load() throws -> StoredToken? {
        assertionFailure("TokenStorageClient.load is unimplemented. Use withDependencies to override.")
        throw TokenStorageClientError.unimplemented
    }

    func delete() throws {
        assertionFailure("TokenStorageClient.delete is unimplemented. Use withDependencies to override.")
        throw TokenStorageClientError.unimplemented
    }
}

extension TokenStorageClient: TestDependencyKey {
    public static let testValue = Self(storage: UnimplementedTokenStorage())
}

public extension DependencyValues {
    var tokenStorage: TokenStorageClient {
        get { self[TokenStorageClient.self] }
        set { self[TokenStorageClient.self] = newValue }
    }
}
