//
//  NotificationSettings.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 설정 엔티티입니다.
public struct NotificationSettings: Equatable, Sendable {
    /// 푸시 알림 활성화 여부
    public let isPushEnabled: Bool
    /// 야간 알림 활성화 여부 (21:00 ~ 08:00)
    public let isNightEnabled: Bool
    /// 마케팅 알림 활성화 여부
    public let isMarketingEnabled: Bool

    public init(
        isPushEnabled: Bool,
        isNightEnabled: Bool,
        isMarketingEnabled: Bool
    ) {
        self.isPushEnabled = isPushEnabled
        self.isNightEnabled = isNightEnabled
        self.isMarketingEnabled = isMarketingEnabled
    }
}
