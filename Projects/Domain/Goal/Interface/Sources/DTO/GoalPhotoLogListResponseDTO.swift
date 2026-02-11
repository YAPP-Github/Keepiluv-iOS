//
//  GoalPhotoLogListResponseDTO.swift
//  DomainGoalInterface
//
//  Created by Codex on 2/7/26.
//

import Foundation

/// 목표별 인증샷 목록 응답 DTO입니다.
public struct GoalPhotoLogListResponseDTO: Decodable {
    public let goalId: Int64
//    public let myNickname: String
    public let partnerNickname: String
    public let goalTitle: String
    public let photologs: [PhotoLogResponse]

    public struct PhotoLogResponse: Decodable {
        let photologId: Int64
        let goalId: Int64
        let imageUrl: String
        let comment: String
        let verificationDate: String
        let isMine: Bool
        let uploaderName: String
        let uploadedAt: String
    }
}

public extension GoalPhotoLogListResponseDTO {
    /// 응답 DTO를 도메인 모델로 변환합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let detail = response.toEntity(response)
    /// ```
    func toEntity(_ response: GoalPhotoLogListResponseDTO) -> GoalDetail {
        let completedGoals = response.photologs.map {
            GoalDetail
                .CompletedGoal(
                    goalId: $0.goalId,
                    photologId: $0.photologId,
                    owner: $0.isMine ? .mySelf : .you,
                    imageUrl: $0.imageUrl,
                    comment: $0.comment,
                    createdAt: $0.uploadedAt
                )
        }
        
        return GoalDetail(
            id: response.goalId,
            title: response.goalTitle,
            partnerNickname: response.partnerNickname,
            completedGoal: completedGoals
        )
    }
}
