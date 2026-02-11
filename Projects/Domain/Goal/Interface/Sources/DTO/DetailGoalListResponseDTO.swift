//
//  DetailGoalListResponseDTO.swift
//  DomainGoalInterface
//
//  Created by Jihun on 2/7/26.
//

import Foundation

/// 날짜별 목표 인증 목록 응답 DTO입니다.
public struct DetailGoalListResponseDTO: Decodable {
    public let targetDate: String
    //    public let myNickname: String
    public let partnerNickname: String
    public let photologs: [PhotologItem]
    
    public struct PhotologItem: Decodable {
        public let goalId: Int64
        public let goalName: String
        public let goalIcon: String
        public let myPhotolog: Photolog?
        public let partnerPhotolog: Photolog?
    }
    
    public struct Photolog: Decodable {
        public let photologId: Int64
        public let goalId: Int64
        public let imageUrl: String
        public let comment: String?
        //        public let verificationDate: String
        //        public let uploaderName: String
        public let uploadedAt: String
        public let reaction: String?
    }
}

public extension DetailGoalListResponseDTO {
    /// 응답 DTO를 도메인 모델로 변환합니다.
    func toEntity(_ response: DetailGoalListResponseDTO) -> GoalDetail {
        return GoalDetail(
            partnerNickname: response.partnerNickname,
            completedGoals: response.photologs.map { photolog in
                GoalDetail.CompletedGoal(
                    myPhotoLog: photolog.myPhotolog.map {
                        GoalDetail.CompletedGoal.PhotoLog(
                            goalId: $0.goalId,
                            photologId: $0.photologId,
                            goalName: photolog.goalName,
                            owner: .mySelf,
                            imageUrl: $0.imageUrl,
                            comment: $0.comment,
                            reaction: $0.reaction.flatMap(Goal.Reaction.init(rawValue:)),
                            createdAt: $0.uploadedAt
                        )
                    },
                    yourPhotoLog: photolog.partnerPhotolog.map {
                        GoalDetail.CompletedGoal.PhotoLog(
                            goalId: $0.goalId,
                            photologId: $0.photologId,
                            goalName: photolog.goalName,
                            owner: .you,
                            imageUrl: $0.imageUrl,
                            comment: $0.comment,
                            reaction: $0.reaction.flatMap(Goal.Reaction.init(rawValue:)),
                            createdAt: $0.uploadedAt
                        )
                    }
                )
            }
        )
    }
}
