//
//  NotificationClient+Live.swift
//  DomainNotification
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import CoreNetworkInterface
import DomainNotificationInterface

extension NotificationClient: @retroactive DependencyKey {
    public static let liveValue: NotificationClient = .live()

    // swiftlint:disable:next function_body_length
    static func live() -> NotificationClient {
        @Dependency(\.networkClient) var networkClient

        return .init(
            fetchList: { lastId, size in
                let response: NotificationListResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.fetchList(lastId: lastId, size: size)
                )
                // API가 lastId를 반환하지 않으면 마지막 알림의 ID 사용
                let computedLastId = response.lastId ?? response.notifications.last?.id
                return NotificationListResult(
                    notifications: response.toEntities(),
                    hasNext: response.hasNext,
                    lastId: computedLastId
                )
            },
            markAsRead: { notificationId in
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: NotificationEndpoint.markAsRead(notificationId: notificationId)
                )
            },
            markAllAsRead: {
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: NotificationEndpoint.markAllAsRead
                )
            },
            fetchSettings: {
                let response: NotificationSettingsResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.fetchSettings
                )
                return response.toEntity()
            },
            updatePokeSetting: { enabled in
                let response: NotificationSettingsResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.updatePokeSetting(enabled: enabled)
                )
                return response.toEntity()
            },
            updateNightSetting: { enabled in
                let response: NotificationSettingsResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.updateNightSetting(enabled: enabled)
                )
                return response.toEntity()
            },
            updateMarketingSetting: { enabled in
                let response: NotificationSettingsResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.updateMarketingSetting(enabled: enabled)
                )
                return response.toEntity()
            },
            initSettings: { isPushEnabled, isMarketingEnabled, isNightEnabled in
                let request = NotificationSettingsInitRequestDTO(
                    isPushEnabled: isPushEnabled,
                    isMarketingPushEnabled: isMarketingEnabled,
                    isNightPushEnabled: isNightEnabled
                )
                let response: NotificationSettingsResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.initSettings(request)
                )
                return response.toEntity()
            },
            registerFCMToken: { token, deviceId in
                let request = FCMTokenRequestDTO(token: token, deviceId: deviceId)
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: NotificationEndpoint.registerFCMToken(request)
                )
            },
            deleteFCMToken: { token in
                let _: EmptyResponse = try await networkClient.request(
                    endpoint: NotificationEndpoint.deleteFCMToken(token: token)
                )
            },
            fetchUnread: {
                let response: UnreadResponseDTO = try await networkClient.request(
                    endpoint: NotificationEndpoint.fetchUnread
                )
                return response.hasUnread
            }
        )
    }
}

private struct EmptyResponse: Decodable {}
