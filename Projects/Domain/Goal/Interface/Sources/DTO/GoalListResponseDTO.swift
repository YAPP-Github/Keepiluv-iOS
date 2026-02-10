//
//  FetchGoalListResponseDTO.swift
//  DomainGoal
//
//  Created by 정지훈 on 2/6/26.
//

import Foundation

/// 목표 목록 API 응답 DTO입니다.
///
/// ## 사용 예시
/// ```swift
/// let response = try JSONDecoder().decode(GoalListResponseDTO.self, from: data)
/// let goals = response.toEntity(response)
/// ```
public struct GoalListResponseDTO: Decodable {
    // let completedCount
    // let totalCount: Int
    public let goals: [GoalResponse]

    public struct GoalResponse: Decodable {
        let goalId: Int64
        let name: String
        let icon: String
        let repeatCycle: String?
        let repeatCount: Int?
        let startDate: String?
        let endDate: String?
        let myCompleted: Bool
        let partnerCompleted: Bool
        let myVerification: Verification?
        let partnerVerification: Verification?
    }

    public struct Verification: Decodable {
//        let photologId: Int64
        let imageUrl: String?
        // let comment: String
        let reaction: String?
        // let uploadedAt: String
    }
}

public extension GoalListResponseDTO {
    /// DTO를 Goal 엔티티로 변환합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let goals = response.toEntity(response)
    /// ```
    func toEntity(_ response: GoalListResponseDTO) -> [Goal] {
        return response.goals.map {
            Goal(
                id: $0.goalId,
                goalIcon: Goal.Icon(rawValue: $0.icon) ?? .default,
                title: $0.name,
                myVerification: .init(
                    isCompleted: $0.myCompleted,
                    imageURL: $0.myVerification?.imageUrl,
                    emoji: Goal.Reaction(rawValue: $0.myVerification?.reaction ?? "")
                ),
                yourVerification: .init(
                    isCompleted: $0.partnerCompleted,
                    imageURL: $0.partnerVerification?.imageUrl,
                    emoji: Goal.Reaction(rawValue: $0.partnerVerification?.reaction ?? "")
                ),
                repeatCycle: $0.repeatCycle.flatMap { Goal.RepeatCycle(rawValue: $0) },
                repeatCount: $0.repeatCount,
                startDate: $0.startDate,
                endDate: $0.endDate
            )
        }
    }
}
