//
//  GoalEditListResponseDTO.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 2/9/26.
//

import Foundation

public struct GoalEditListResponseDTO: Decodable {
    public let goals: [GoalEditResponseDTO]
    
    public struct GoalEditResponseDTO: Decodable {
        public let goalId: Int64
        public let goalName: String
        public let icon: String
        public let repeatCycle: String
        public let startDate: String
        public let endDate: String?
    }
}

extension GoalEditListResponseDTO {
    public func toEntity(_ response: GoalEditListResponseDTO) -> [Goal] {
        return response.goals.map {
            Goal(
                id: $0.goalId,
                goalIcon: Goal.Icon.init(rawValue: $0.icon) ?? .default,
                title: $0.goalName,
                myVerification: nil,
                yourVerification: nil,
                repeatCycle: Goal.RepeatCycle(rawValue: $0.repeatCycle),
                startDate: $0.startDate,
                endDate: $0.endDate
            )
        }
    }
}
