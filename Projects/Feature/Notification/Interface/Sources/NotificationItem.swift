//
//  NotificationItem.swift
//  FeatureNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import DomainNotificationInterface
import Foundation

/// 알림 아이템 모델입니다.
public struct NotificationItem: Equatable, Identifiable, Sendable {
    public let id: Int64
    public let type: String
    public let title: String
    public let message: String
    public let deepLink: String?
    public let isRead: Bool
    public let createdAt: Date

    public init(
        id: Int64,
        type: String,
        title: String,
        message: String,
        deepLink: String?,
        isRead: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.message = message
        self.deepLink = deepLink
        self.isRead = isRead
        self.createdAt = createdAt
    }

    /// Domain Notification에서 생성합니다.
    public init(from notification: DomainNotificationInterface.Notification) {
        self.id = notification.id
        self.type = notification.type.rawValue
        self.title = notification.title
        self.message = notification.body
        self.deepLink = notification.deepLink
        self.isRead = notification.isRead
        self.createdAt = notification.createdAt
    }
}

// MARK: - Computed Properties

extension NotificationItem {
    private static var kstCalendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        return calendar
    }

    public var isNew: Bool {
        !isRead
    }

    public var isWithin14Days: Bool {
        let now = Date()
        guard let fourteenDaysAgo = Self.kstCalendar.date(byAdding: .day, value: -14, to: now) else {
            return false
        }
        return createdAt >= fourteenDaysAgo
    }
}
