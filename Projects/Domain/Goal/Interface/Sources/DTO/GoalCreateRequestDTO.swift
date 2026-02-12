//
//  GoalCreateRequestDTO.swift
//  DomainGoalInterface
//
//  Created by Jihun on 2/6/26.
//

import Foundation

/// 목표 생성 요청 DTO입니다.
public struct GoalCreateRequestDTO: Encodable {
    public let name: String
    public let icon: String
    public let repeatCycle: String
    public let repeatCount: Int
    public let startDate: String
    public let endDate: String?

    public init(
        name: String,
        icon: String,
        repeatCycle: String,
        repeatCount: Int,
        startDate: String,
        endDate: String?
    ) {
        self.name = name
        self.icon = icon
        self.repeatCycle = repeatCycle
        self.repeatCount = repeatCount
        self.startDate = startDate
        self.endDate = endDate
    }

    enum CodingKeys: String, CodingKey {
        case name = "goalName"
        case icon, repeatCycle, repeatCount, startDate, endDate
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(icon, forKey: .icon)
        try container.encode(repeatCycle, forKey: .repeatCycle)
        try container.encode(repeatCount, forKey: .repeatCount)
        try container.encode(startDate, forKey: .startDate)
        try container.encodeIfPresent(endDate, forKey: .endDate)
    }
}
