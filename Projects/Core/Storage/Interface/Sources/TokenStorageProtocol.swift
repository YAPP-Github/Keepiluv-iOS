//
//  TokenStorageProtocol.swift
//  CoreStorageInterface
//
//
//  Created by Jiyong
//

import Foundation

/// 저장소에 저장되는 토큰 데이터 구조입니다.
///
/// Core 계층에서 정의하여 Domain 계층에 의존하지 않도록 합니다.
public struct StoredToken: Codable, Equatable {
    /// 액세스 토큰
    public let accessToken: String

    /// 리프레시 토큰
    public let refreshToken: String

    /// 토큰 만료 시간
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
    func save(_ token: StoredToken) throws

    /// 저장소에서 Token을 불러옵니다.
    ///
    /// - Returns: 저장된 토큰. 없으면 nil
    /// - Throws: 불러오기 실패 시 에러
    func load() throws -> StoredToken?

    /// 저장소에서 Token을 삭제합니다.
    ///
    /// - Throws: 삭제 실패 시 에러
    func delete() throws
}
