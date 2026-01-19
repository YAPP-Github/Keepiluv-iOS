//
//  KeychainTokenStorage.swift
//  CoreStorage
//
//
//  Created by Jiyong
//

import ComposableArchitecture
import CoreStorageInterface
import Foundation
import Security

/// Keychain을 사용하여 토큰을 저장하는 구현체입니다.
///
/// AccessToken과 RefreshToken을 별도의 키로 분리하여 저장합니다.
public final class KeychainTokenStorage: TokenStorageProtocol {
    private let service: String
    private let accessTokenKey: String
    private let refreshTokenKey: String
    private let expiresAtKey: String

    /// KeychainTokenStorage를 초기화합니다.
    ///
    /// - Parameters:
    ///   - service: Keychain 서비스 식별자 (보통 Bundle ID 사용)
    ///   - accessTokenKey: AccessToken 저장 키
    ///   - refreshTokenKey: RefreshToken 저장 키
    ///   - expiresAtKey: ExpiresAt 저장 키
    public init(
        service: String = Bundle.main.bundleIdentifier ?? "org.yapp.twix",
        accessTokenKey: String = "auth.accessToken",
        refreshTokenKey: String = "auth.refreshToken",
        expiresAtKey: String = "auth.expiresAt"
    ) {
        self.service = service
        self.accessTokenKey = accessTokenKey
        self.refreshTokenKey = refreshTokenKey
        self.expiresAtKey = expiresAtKey
    }

    public func save(_ token: StoredToken) throws {
        try saveString(token.accessToken, forKey: accessTokenKey)
        try saveString(token.refreshToken, forKey: refreshTokenKey)
        try saveDate(token.expiresAt, forKey: expiresAtKey)
    }

    public func load() throws -> StoredToken? {
        guard let accessToken = try loadString(forKey: accessTokenKey),
              let refreshToken = try loadString(forKey: refreshTokenKey),
              let expiresAt = try loadDate(forKey: expiresAtKey) else {
            return nil
        }

        return StoredToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            expiresAt: expiresAt
        )
    }

    public func delete() throws {
        try deleteItem(forKey: accessTokenKey)
        try deleteItem(forKey: refreshTokenKey)
        try deleteItem(forKey: expiresAtKey)
    }
}

// MARK: - Private Helpers

private extension KeychainTokenStorage {
    func saveString(_ value: String, forKey key: String) throws {
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.invalidData
        }

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)

        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            throw KeychainError.saveFailed(status)
        }
    }

    func saveDate(_ value: Date, forKey key: String) throws {
        let timestamp = value.timeIntervalSince1970
        try saveString(String(timestamp), forKey: key)
    }

    func loadString(forKey key: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)

        guard status != errSecItemNotFound else {
            return nil
        }

        guard status == errSecSuccess else {
            throw KeychainError.loadFailed(status)
        }

        guard let data = result as? Data,
              let string = String(data: data, encoding: .utf8) else {
            throw KeychainError.invalidData
        }

        return string
    }

    func loadDate(forKey key: String) throws -> Date? {
        guard let timestampString = try loadString(forKey: key),
              let timestamp = Double(timestampString) else {
            return nil
        }

        return Date(timeIntervalSince1970: timestamp)
    }

    func deleteItem(forKey key: String) throws {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: key
        ]

        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw KeychainError.deleteFailed(status)
        }
    }
}

/// Keychain 작업 중 발생할 수 있는 에러를 정의합니다.
public enum KeychainError: Error, LocalizedError {
    case saveFailed(OSStatus)
    case loadFailed(OSStatus)
    case deleteFailed(OSStatus)
    case invalidData

    public var errorDescription: String? {
        switch self {
        case .saveFailed(let status):
            return "Keychain 저장 실패: \(status)"
            
        case .loadFailed(let status):
            return "Keychain 불러오기 실패: \(status)"
            
        case .deleteFailed(let status):
            return "Keychain 삭제 실패: \(status)"
            
        case .invalidData:
            return "Keychain 데이터 형식 오류"
        }
    }
}

extension TokenStorageClient: DependencyKey {
    public static let liveValue = Self(storage: KeychainTokenStorage())
}
