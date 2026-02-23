//
//  NotificationClient.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import Foundation

/// 알림 목록 조회 결과입니다.
public struct NotificationListResult: Equatable, Sendable {
    public let notifications: [Notification]
    public let hasNext: Bool
    public let lastId: Int64?

    public init(notifications: [Notification], hasNext: Bool, lastId: Int64?) {
        self.notifications = notifications
        self.hasNext = hasNext
        self.lastId = lastId
    }
}

/// 알림 관련 API를 호출하는 Client입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.notificationClient) var notificationClient
/// let result = try await notificationClient.fetchList(nil, 20)
/// ```
public struct NotificationClient: Sendable {
    /// 알림 목록을 조회합니다.
    /// - Parameters:
    ///   - lastId: 마지막 알림 ID (커서 기반 페이지네이션)
    ///   - size: 조회할 알림 개수
    public var fetchList: @Sendable (_ lastId: Int64?, _ size: Int) async throws -> NotificationListResult

    /// 특정 알림을 읽음 처리합니다.
    public var markAsRead: @Sendable (_ notificationId: Int64) async throws -> Void

    /// 전체 알림을 읽음 처리합니다.
    public var markAllAsRead: @Sendable () async throws -> Void

    /// 알림 설정을 조회합니다.
    public var fetchSettings: @Sendable () async throws -> NotificationSettings

    /// 찌르기 알림 설정을 변경합니다.
    public var updatePokeSetting: @Sendable (_ enabled: Bool) async throws -> NotificationSettings

    /// 야간 알림 설정을 변경합니다.
    public var updateNightSetting: @Sendable (_ enabled: Bool) async throws -> NotificationSettings

    /// 마케팅 알림 설정을 변경합니다.
    public var updateMarketingSetting: @Sendable (_ enabled: Bool) async throws -> NotificationSettings

    /// 알림 설정을 초기화합니다.
    public var initSettings: @Sendable (
        _ isPushEnabled: Bool,
        _ isMarketingEnabled: Bool,
        _ isNightEnabled: Bool
    ) async throws -> NotificationSettings

    /// FCM 토큰을 등록합니다.
    public var registerFCMToken: @Sendable (_ token: String, _ deviceId: String) async throws -> Void

    /// FCM 토큰을 삭제합니다 (로그아웃 시).
    public var deleteFCMToken: @Sendable (_ token: String) async throws -> Void

    /// 읽지 않은 알림 존재 여부를 조회합니다.
    public var fetchUnread: @Sendable () async throws -> Bool

    public init(
        fetchList: @escaping @Sendable (_ lastId: Int64?, _ size: Int) async throws -> NotificationListResult,
        markAsRead: @escaping @Sendable (_ notificationId: Int64) async throws -> Void,
        markAllAsRead: @escaping @Sendable () async throws -> Void,
        fetchSettings: @escaping @Sendable () async throws -> NotificationSettings,
        updatePokeSetting: @escaping @Sendable (_ enabled: Bool) async throws -> NotificationSettings,
        updateNightSetting: @escaping @Sendable (_ enabled: Bool) async throws -> NotificationSettings,
        updateMarketingSetting: @escaping @Sendable (_ enabled: Bool) async throws -> NotificationSettings,
        initSettings: @escaping @Sendable (
            _ isPushEnabled: Bool,
            _ isMarketingEnabled: Bool,
            _ isNightEnabled: Bool
        ) async throws -> NotificationSettings,
        registerFCMToken: @escaping @Sendable (_ token: String, _ deviceId: String) async throws -> Void,
        deleteFCMToken: @escaping @Sendable (_ token: String) async throws -> Void,
        fetchUnread: @escaping @Sendable () async throws -> Bool
    ) {
        self.fetchList = fetchList
        self.markAsRead = markAsRead
        self.markAllAsRead = markAllAsRead
        self.fetchSettings = fetchSettings
        self.updatePokeSetting = updatePokeSetting
        self.updateNightSetting = updateNightSetting
        self.updateMarketingSetting = updateMarketingSetting
        self.initSettings = initSettings
        self.registerFCMToken = registerFCMToken
        self.deleteFCMToken = deleteFCMToken
        self.fetchUnread = fetchUnread
    }
}

// MARK: - DependencyKey

extension NotificationClient: TestDependencyKey {
    public static let testValue = Self(
        fetchList: { _, _ in
            assertionFailure("NotificationClient.fetchList이 구현되지 않았습니다.")
            return NotificationListResult(notifications: [], hasNext: false, lastId: nil)
        },
        markAsRead: { _ in
            assertionFailure("NotificationClient.markAsRead가 구현되지 않았습니다.")
        },
        markAllAsRead: {
            assertionFailure("NotificationClient.markAllAsRead가 구현되지 않았습니다.")
        },
        fetchSettings: {
            assertionFailure("NotificationClient.fetchSettings가 구현되지 않았습니다.")
            return NotificationSettings(
                isPushEnabled: false,
                isNightEnabled: false,
                isMarketingEnabled: false
            )
        },
        updatePokeSetting: { _ in
            assertionFailure("NotificationClient.updatePokeSetting이 구현되지 않았습니다.")
            return NotificationSettings(
                isPushEnabled: false,
                isNightEnabled: false,
                isMarketingEnabled: false
            )
        },
        updateNightSetting: { _ in
            assertionFailure("NotificationClient.updateNightSetting이 구현되지 않았습니다.")
            return NotificationSettings(
                isPushEnabled: false,
                isNightEnabled: false,
                isMarketingEnabled: false
            )
        },
        updateMarketingSetting: { _ in
            assertionFailure("NotificationClient.updateMarketingSetting이 구현되지 않았습니다.")
            return NotificationSettings(
                isPushEnabled: false,
                isNightEnabled: false,
                isMarketingEnabled: false
            )
        },
        initSettings: { _, _, _ in
            assertionFailure("NotificationClient.initSettings가 구현되지 않았습니다.")
            return NotificationSettings(
                isPushEnabled: false,
                isNightEnabled: false,
                isMarketingEnabled: false
            )
        },
        registerFCMToken: { _, _ in
            assertionFailure("NotificationClient.registerFCMToken이 구현되지 않았습니다.")
        },
        deleteFCMToken: { _ in
            assertionFailure("NotificationClient.deleteFCMToken이 구현되지 않았습니다.")
        },
        fetchUnread: {
            assertionFailure("NotificationClient.fetchUnread가 구현되지 않았습니다.")
            return false
        }
    )

    public static let previewValue = Self(
        fetchList: { _, _ in
            NotificationListResult(notifications: [], hasNext: false, lastId: nil)
        },
        markAsRead: { _ in },
        markAllAsRead: {},
        fetchSettings: {
            NotificationSettings(
                isPushEnabled: true,
                isNightEnabled: false,
                isMarketingEnabled: true
            )
        },
        updatePokeSetting: { enabled in
            NotificationSettings(
                isPushEnabled: true,
                isNightEnabled: false,
                isMarketingEnabled: true
            )
        },
        updateNightSetting: { enabled in
            NotificationSettings(
                isPushEnabled: true,
                isNightEnabled: enabled,
                isMarketingEnabled: true
            )
        },
        updateMarketingSetting: { enabled in
            NotificationSettings(
                isPushEnabled: true,
                isNightEnabled: false,
                isMarketingEnabled: enabled
            )
        },
        initSettings: { push, marketing, night in
            NotificationSettings(
                isPushEnabled: push,
                isNightEnabled: night,
                isMarketingEnabled: marketing
            )
        },
        registerFCMToken: { _, _ in },
        deleteFCMToken: { _ in },
        fetchUnread: { false }
    )
}

public extension DependencyValues {
    var notificationClient: NotificationClient {
        get { self[NotificationClient.self] }
        set { self[NotificationClient.self] = newValue }
    }
}
