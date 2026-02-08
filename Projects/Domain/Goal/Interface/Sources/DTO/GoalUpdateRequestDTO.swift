//
//  GoalUpdateRequestDTO.swift
//  DomainGoalInterface
//
//  Created by Jiyong on 2/8/26.
//

import Foundation

/// 목표 수정 요청 DTO입니다.
public struct GoalUpdateRequestDTO: Encodable {
    public let name: String
    public let icon: String
    public let repeatCycle: String
    public let repeatCount: Int
    public let endDate: String?

    public init(
        name: String,
        icon: String,
        repeatCycle: String,
        repeatCount: Int,
        endDate: String?
    ) {
        self.name = name
        self.icon = icon
        self.repeatCycle = repeatCycle
        self.repeatCount = repeatCount
        self.endDate = endDate
    }

    enum CodingKeys: String, CodingKey {
        case name, icon, repeatCycle, repeatCount, endDate
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(repeatCycle, forKey: .repeatCycle)
        try container.encode(repeatCount, forKey: .repeatCount)
        try container.encodeIfPresent(endDate, forKey: .endDate)
    }
}
