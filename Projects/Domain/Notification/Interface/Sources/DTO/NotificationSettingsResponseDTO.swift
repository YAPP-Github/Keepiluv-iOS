//
//  NotificationSettingsResponseDTO.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 설정 API 응답 DTO입니다.
public struct NotificationSettingsResponseDTO: Decodable, Sendable {
    public let isPushEnabled: Bool
    public let isNightPushEnabled: Bool
    public let isMarketingPushEnabled: Bool
}

// MARK: - Entity Conversion

extension NotificationSettingsResponseDTO {
    /// DTO를 NotificationSettings 엔티티로 변환합니다.
    public func toEntity() -> NotificationSettings {
        NotificationSettings(
            isPushEnabled: isPushEnabled,
            isNightEnabled: isNightPushEnabled,
            isMarketingEnabled: isMarketingPushEnabled
        )
    }
}
