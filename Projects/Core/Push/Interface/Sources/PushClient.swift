//
//  PushClient.swift
//  CorePushInterface
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import Foundation

/// 푸시 알림을 관리하는 클라이언트입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.pushClient) var pushClient
///
/// // 푸시 권한 요청
/// let granted = try await pushClient.requestAuthorization()
///
/// // FCM 토큰 가져오기
/// let token = try await pushClient.getFCMToken()
/// ```
public struct PushClient: Sendable {
    /// 푸시 알림 권한을 요청합니다.
    public var requestAuthorization: @Sendable () async throws -> Bool

    /// FCM 토큰을 가져옵니다.
    public var getFCMToken: @Sendable () async throws -> String

    /// FCM 토큰 갱신 스트림을 반환합니다.
    public var tokenRefreshStream: @Sendable () -> AsyncStream<String>

    /// 원격 알림 등록을 처리합니다.
    public var registerForRemoteNotifications: @Sendable () async -> Void

    public init(
        requestAuthorization: @escaping @Sendable () async throws -> Bool,
        getFCMToken: @escaping @Sendable () async throws -> String,
        tokenRefreshStream: @escaping @Sendable () -> AsyncStream<String>,
        registerForRemoteNotifications: @escaping @Sendable () async -> Void
    ) {
        self.requestAuthorization = requestAuthorization
        self.getFCMToken = getFCMToken
        self.tokenRefreshStream = tokenRefreshStream
        self.registerForRemoteNotifications = registerForRemoteNotifications
    }
}

// MARK: - DependencyKey

extension PushClient: TestDependencyKey {
    public static let testValue = Self(
        requestAuthorization: { true },
        getFCMToken: { "test-fcm-token" },
        tokenRefreshStream: { AsyncStream { _ in } },
        registerForRemoteNotifications: { }
    )

    public static let previewValue = Self(
        requestAuthorization: { true },
        getFCMToken: { "preview-fcm-token" },
        tokenRefreshStream: { AsyncStream { _ in } },
        registerForRemoteNotifications: { }
    )
}

public extension DependencyValues {
    var pushClient: PushClient {
        get { self[PushClient.self] }
        set { self[PushClient.self] = newValue }
    }
}
