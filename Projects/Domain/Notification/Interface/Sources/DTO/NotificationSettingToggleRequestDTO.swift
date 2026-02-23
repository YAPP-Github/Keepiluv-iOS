//
//  NotificationSettingToggleRequestDTO.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 설정 토글 요청 DTO입니다.
public struct NotificationSettingToggleRequestDTO: Encodable, Sendable {
    public let enabled: Bool

    public init(enabled: Bool) {
        self.enabled = enabled
    }
}
