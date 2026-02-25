//
//  GoalUpdateRequestDTO.swift
//  DomainGoalInterface
//
//  Created by Jiyong on 2/8/26.
//

import Foundation

/// 목표 수정 요청 DTO입니다.
public struct GoalUpdateRequestDTO: Encodable {
    public let goalName: String
    public let icon: String
    public let repeatCycle: String
    public let repeatCount: Int
    public let endDate: String?

    public init(
        goalName: String,
        icon: String,
        repeatCycle: String,
        repeatCount: Int,
        endDate: String?
    ) {
        self.goalName = goalName
        self.icon = icon
        self.repeatCycle = repeatCycle
        self.repeatCount = repeatCount
        self.endDate = endDate
    }
}
