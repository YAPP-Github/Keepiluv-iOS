//
//  GoalCreateResponseDTO.swift
//  DomainGoalInterface
//
//  Created by Jihun on 2/6/26.
//

import Foundation

/// 목표 생성 응답 DTO입니다.
public struct GoalCreateResponseDTO: Decodable {
    public let goalId: Int
    public let name: String
    public let icon: String
    public let repeatCycle: String
    public let repeatCount: Int
    public let startDate: String
    public let endDate: String?
    public let goalStatus: String
    public let createdAt: String
}

public extension GoalCreateResponseDTO {
    /// 응답 DTO를 도메인 모델로 변환합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let result = response.toEntity(response)
    /// ```
    func toEntity(_ response: GoalCreateResponseDTO) -> Goal {
        Goal(
            id: response.goalId,
            goalIcon: .init(rawValue: response.icon) ?? .`default`,
            title: response.name,
            myVerification: .init(
                isCompleted: false,
                imageURL: nil,
                emoji: nil
            ),
            yourVerification: .init(
                isCompleted: false,
                imageURL: nil,
                emoji: nil
            ),
            repeatCycle: Goal.RepeatCycle(rawValue: response.repeatCycle),
            repeatCount: response.repeatCount,
            startDate: response.startDate,
            endDate: response.endDate
        )
    }
}
