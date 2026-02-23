//
//  Notification.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 엔티티입니다.
public struct Notification: Equatable, Identifiable, Sendable {
    public let id: Int64
    public let type: NotificationType
    public let title: String
    public let body: String
    public let deepLink: String?
    public let isRead: Bool
    public let createdAt: Date

    public init(
        id: Int64,
        type: NotificationType,
        title: String,
        body: String,
        deepLink: String?,
        isRead: Bool,
        createdAt: Date
    ) {
        self.id = id
        self.type = type
        self.title = title
        self.body = body
        self.deepLink = deepLink
        self.isRead = isRead
        self.createdAt = createdAt
    }
}

// MARK: - NotificationType

/// 알림 타입입니다.
public enum NotificationType: String, Sendable {
    /// 파트너 연결 성공
    case partnerConnected = "PARTNER_CONNECTED"
    /// 찌르기
    case poke = "POKE"
    /// 목표 완료
    case goalCompleted = "GOAL_COMPLETED"
    /// 리액션 수신
    case reaction = "REACTION"
    /// 오늘의 모든 목표 완료
    case dailyGoalAchieved = "DAILY_GOAL_ACHIEVED"
    /// 목표 종료
    case goalEnded = "GOAL_ENDED"
    /// 마케팅
    case marketing = "MARKETING"
    /// 알 수 없음
    case unknown = "UNKNOWN"

    public init(rawValue: String) {
        switch rawValue {
        case "PARTNER_CONNECTED": self = .partnerConnected
        case "POKE": self = .poke
        case "GOAL_COMPLETED": self = .goalCompleted
        case "REACTION": self = .reaction
        case "DAILY_GOAL_ACHIEVED": self = .dailyGoalAchieved
        case "GOAL_ENDED": self = .goalEnded
        case "MARKETING": self = .marketing
        default: self = .unknown
        }
    }
}

// MARK: - Computed Properties

extension Notification {
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
