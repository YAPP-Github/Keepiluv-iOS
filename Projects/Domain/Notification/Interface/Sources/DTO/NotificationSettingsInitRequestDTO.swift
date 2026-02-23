//
//  NotificationSettingsInitRequestDTO.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 설정 초기화 요청 DTO입니다.
public struct NotificationSettingsInitRequestDTO: Encodable, Sendable {
    public let isPushEnabled: Bool
    public let isMarketingPushEnabled: Bool
    public let isNightPushEnabled: Bool

    public init(
        isPushEnabled: Bool,
        isMarketingPushEnabled: Bool,
        isNightPushEnabled: Bool
    ) {
        self.isPushEnabled = isPushEnabled
        self.isMarketingPushEnabled = isMarketingPushEnabled
        self.isNightPushEnabled = isNightPushEnabled
    }
}
