//
//  NotificationEndpoint.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import CoreNetworkInterface
import Foundation

/// 알림 관련 API 엔드포인트입니다.
public enum NotificationEndpoint: Endpoint {
    /// 알림 목록 조회 (커서 기반 페이지네이션)
    case fetchList(lastId: Int64?, size: Int)
    /// 특정 알림 읽음 처리
    case markAsRead(notificationId: Int64)
    /// 전체 알림 읽음 처리
    case markAllAsRead
    /// 알림 설정 조회
    case fetchSettings
    /// 찌르기 알림 설정 변경
    case updatePokeSetting(enabled: Bool)
    /// 야간 알림 설정 변경
    case updateNightSetting(enabled: Bool)
    /// 마케팅 알림 설정 변경
    case updateMarketingSetting(enabled: Bool)
    /// 알림 설정 초기화
    case initSettings(NotificationSettingsInitRequestDTO)
    /// FCM 토큰 등록
    case registerFCMToken(FCMTokenRequestDTO)
    /// FCM 토큰 삭제 (로그아웃 시)
    case deleteFCMToken(token: String)
    /// 읽지 않은 알림 존재 여부 조회
    case fetchUnread
}

extension NotificationEndpoint {
    public var path: String {
        switch self {
        case .fetchList:
            return "/api/v1/notifications"

        case let .markAsRead(notificationId):
            return "/api/v1/notifications/\(notificationId)/read"

        case .markAllAsRead:
            return "/api/v1/notifications/read-all"

        case .fetchSettings:
            return "/api/v1/notifications/settings"

        case .updatePokeSetting:
            return "/api/v1/notifications/settings/poke"

        case .updateNightSetting:
            return "/api/v1/notifications/settings/night"

        case .updateMarketingSetting:
            return "/api/v1/notifications/settings/marketing"

        case .initSettings:
            return "/api/v1/notifications/settings/init"

        case .registerFCMToken, .deleteFCMToken:
            return "/api/v1/notifications/fcm-token"

        case .fetchUnread:
            return "/api/v1/notifications/unread"
        }
    }

    public var method: HTTPMethod {
        switch self {
        case .fetchList, .fetchSettings, .fetchUnread:
            return .get

        case .markAsRead, .markAllAsRead,
             .updatePokeSetting, .updateNightSetting, .updateMarketingSetting:
            return .patch

        case .initSettings, .registerFCMToken:
            return .post

        case .deleteFCMToken:
            return .delete
        }
    }

    public var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }

    public var query: [URLQueryItem]? {
        switch self {
        case let .fetchList(lastId, size):
            var items = [URLQueryItem(name: "size", value: String(size))]
            if let lastId {
                items.append(URLQueryItem(name: "lastId", value: String(lastId)))
            }
            return items

        default:
            return nil
        }
    }

    public var body: (any Encodable)? {
        switch self {
        case .updatePokeSetting(let enabled),
             .updateNightSetting(let enabled),
             .updateMarketingSetting(let enabled):
            return NotificationSettingToggleRequestDTO(enabled: enabled)

        case let .initSettings(request):
            return request

        case let .registerFCMToken(request):
            return request

        case let .deleteFCMToken(token):
            return FCMTokenDeleteRequestDTO(token: token)

        default:
            return nil
        }
    }

    public var requiresAuth: Bool { true }
    public var featureTag: FeatureTag { .notification }
}
