//
//  GoalCreation.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 5/14/26.
//

import Foundation

import DomainCommonInterface

public struct EditableGoal: Equatable, Identifiable {
    public let id: Int64
    public let name: String
    public let icon: String
    public let repeatCycle: RepeatCycle
    public let repeatCount: Int?
    public let startDate: String
    public let endDate: String?
    
    public init(
        id: Int64,
        name: String,
        icon: String,
        repeatCycle: RepeatCycle,
        repeatCount: Int?,
        startDate: String,
        endDate: String?
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.repeatCycle = repeatCycle
        self.repeatCount = repeatCount
        self.startDate = startDate
        self.endDate = endDate
    }
}
