//
//  NotificationDeepLink.swift
//  CorePushInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 푸시 알림을 통해 전달되는 딥링크 타입입니다.
///
/// ## 사용 예시
/// ```swift
/// if let deepLink = NotificationDeepLink.parse(from: url) {
///     switch deepLink {
///     case .partnerConnected(let notificationId):
///         // 홈 화면으로 이동
///     case .poke(let notificationId, let goalId, let date):
///         // 내 인증샷 화면으로 이동
///     }
/// }
/// ```
public enum NotificationDeepLink: Equatable, Sendable {
    case partnerConnected(notificationId: String)

    case poke(notificationId: String, goalId: String, date: String)

    case goalCompleted(notificationId: String, goalId: String, date: String)

    case reaction(notificationId: String, goalId: String, date: String)

    case dailyGoalAchieved(notificationId: String)

    case goalEnded(notificationId: String)

    case marketing(notificationId: String)
}

// MARK: - Parsing

extension NotificationDeepLink {
    /// URL에서 딥링크를 파싱합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let url = URL(string: "twix://notification/poke?notificationId=123&goalId=456&date=2026-02-21")!
    /// let deepLink = NotificationDeepLink.parse(from: url)
    /// ```
    public static func parse(from url: URL) -> NotificationDeepLink? {
        guard url.scheme == "twix",
              url.host == "notification" else {
            return nil
        }

        let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems ?? []
        guard let notificationId = value(for: "notificationId", in: queryItems) else {
            return nil
        }

        let path = url.path.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        return parse(
            path: path,
            notificationId: notificationId,
            queryItems: queryItems
        )
    }

    private static func parse(
        path: String,
        notificationId: String,
        queryItems: [URLQueryItem]
    ) -> NotificationDeepLink? {
        switch path {
        case "partner-connected":
            return .partnerConnected(notificationId: notificationId)

        case "poke":
            guard let goalId = value(for: "goalId", in: queryItems),
                  let date = value(for: "date", in: queryItems) else {
                return nil
            }
            return .poke(notificationId: notificationId, goalId: goalId, date: date)

        case "goal-completed":
            guard let goalId = value(for: "goalId", in: queryItems),
                  let date = value(for: "date", in: queryItems) else {
                return nil
            }
            return .goalCompleted(notificationId: notificationId, goalId: goalId, date: date)

        case "reaction":
            guard let goalId = value(for: "goalId", in: queryItems),
                  let date = value(for: "date", in: queryItems) else {
                return nil
            }
            return .reaction(notificationId: notificationId, goalId: goalId, date: date)

        case "daily-goal-achieved":
            return .dailyGoalAchieved(notificationId: notificationId)

        case "goal-ended":
            return .goalEnded(notificationId: notificationId)

        case "marketing":
            return .marketing(notificationId: notificationId)

        default:
            return nil
        }
    }

    private static func value(
        for key: String,
        in queryItems: [URLQueryItem]
    ) -> String? {
        queryItems.first { $0.name == key }?.value
    }
}

// MARK: - Computed Properties

extension NotificationDeepLink {
    public var notificationId: String {
        switch self {
        case .partnerConnected(let id),
             .poke(let id, _, _),
             .goalCompleted(let id, _, _),
             .reaction(let id, _, _),
             .dailyGoalAchieved(let id),
             .goalEnded(let id),
             .marketing(let id):
            return id
        }
    }
}
