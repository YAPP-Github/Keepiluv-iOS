//
//  UnreadResponseDTO.swift
//  DomainNotificationInterface
//
//  Created by Claude on 02/22/26.
//

import Foundation

/// 읽지 않은 알림 존재 여부 응답 DTO입니다.
public struct UnreadResponseDTO: Decodable, Sendable {
    public let hasUnread: Bool
}
