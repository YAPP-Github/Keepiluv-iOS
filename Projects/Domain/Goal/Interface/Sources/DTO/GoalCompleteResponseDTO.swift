//
//  GoalCompleteResponseDTO.swift
//  DomainGoalInterface
//
//  Created by Jiyong on 2/8/26.
//

import Foundation

/// 목표 완료 응답 DTO입니다.
public struct GoalCompleteResponseDTO: Decodable {
    public let goalId: Int64
    public let goalName: String
    public let goalStatus: String
    public let completedAt: String?
}
