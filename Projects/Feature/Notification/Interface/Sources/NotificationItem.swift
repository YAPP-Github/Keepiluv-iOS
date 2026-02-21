//
//  NotificationItem.swift
//  FeatureNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 아이템 모델입니다.
public struct NotificationItem: Equatable, Identifiable, Sendable {
    public let id: String
    public let message: String
    public let createdAt: Date

    public init(
        id: String,
        message: String,
        createdAt: Date
    ) {
        self.id = id
        self.message = message
        self.createdAt = createdAt
    }
}

// MARK: - Computed Properties

extension NotificationItem {
    /// KST 기준 Calendar
    private static var kstCalendar: Calendar {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul") ?? .current
        return calendar
    }

    /// 오늘 생성된 알림인지 여부 (KST 기준)
    public var isNew: Bool {
        Self.kstCalendar.isDateInToday(createdAt)
    }

    /// 최근 14일 이내 알림인지 여부 (KST 기준)
    public var isWithin14Days: Bool {
        let now = Date()
        guard let fourteenDaysAgo = Self.kstCalendar.date(byAdding: .day, value: -14, to: now) else {
            return false
        }
        return createdAt >= fourteenDaysAgo
    }
}
