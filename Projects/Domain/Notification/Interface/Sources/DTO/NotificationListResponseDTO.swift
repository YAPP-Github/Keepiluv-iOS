//
//  NotificationListResponseDTO.swift
//  DomainNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import Foundation

/// 알림 목록 API 응답 DTO입니다.
public struct NotificationListResponseDTO: Decodable, Sendable {
    public let notifications: [NotificationResponse]
    public let hasNext: Bool
    public let lastId: Int64?

    public struct NotificationResponse: Decodable, Sendable {
        public let id: Int64
        public let type: String
        public let title: String
        public let body: String
        public let deepLink: String?
        public let isRead: Bool
        public let createdAt: String
    }
}

// MARK: - Entity Conversion

extension NotificationListResponseDTO {
    /// DTO를 Notification 엔티티 배열로 변환합니다.
    public func toEntities() -> [Notification] {
        notifications.compactMap { response in
            guard let createdAt = parseDate(response.createdAt) else {
                return nil
            }

            return Notification(
                id: response.id,
                type: NotificationType(rawValue: response.type),
                title: response.title,
                body: response.body,
                deepLink: response.deepLink,
                isRead: response.isRead,
                createdAt: createdAt
            )
        }
    }

    private func parseDate(_ dateString: String) -> Date? {
        // ISO8601 with timezone + fractional seconds (e.g., "2026-02-23T00:50:18.123Z")
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }

        // ISO8601 with timezone, no fractional seconds (e.g., "2026-02-23T00:50:18Z")
        isoFormatter.formatOptions = [.withInternetDateTime]
        if let date = isoFormatter.date(from: dateString) {
            return date
        }

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        // Without timezone, with fractional seconds (e.g., "2026-02-23T00:50:18.123") - assume KST
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        if let date = dateFormatter.date(from: dateString) {
            return date
        }

        // Without timezone, no fractional seconds (e.g., "2026-02-23T00:50:18") - assume KST
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return dateFormatter.date(from: dateString)
    }
}
