//
//  GoalCreateRequestDTO.swift
//  DomainGoalInterface
//
//  Created by Codex on 2/6/26.
//

import Foundation

/// 목표 생성 요청 DTO입니다.
public struct GoalCreateRequestDTO: Encodable {
    public let name: String
    public let icon: String
    public let repeatCycle: String
    public let repeatCount: Int
    public let startDate: String
    public let endDate: String
    
    public init(
        name: String,
        icon: String,
        repeatCycle: String,
        repeatCount: Int,
        startDate: String,
        endDate: String
    ) {
        self.name = name
        self.icon = icon
        self.repeatCycle = repeatCycle
        self.repeatCount = repeatCount
        self.startDate = startDate
        self.endDate = endDate
    }
}
