//
//  GoalDetail.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

/// 목표 상세 정보를 나타내는 모델입니다.
///
/// ## 사용 예시
/// ```swift
/// let detail = GoalDetail(
///     id: 1,
///     title: "아이스크림 먹기",
///     partnerNickname: "twix",
///     completedGoal: []
/// )
/// ```
public struct GoalDetail: Equatable {
    public let partnerNickname: String
    public let completedGoals: [CompletedGoal?]
    
    /// 목표 상세 모델을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let detail = GoalDetail(
    ///     id: 1,
    ///     title: "아이스크림 먹기",
    ///     partnerNickname: "twix",
    ///     selectedIndex: 0,
    ///     completedGoal: []
    /// )
    /// ```
    public init(
        partnerNickname: String,
        completedGoals: [CompletedGoal?]
    ) {
        self.partnerNickname = partnerNickname
        self.completedGoals = completedGoals
    }
    
    /// 목표 인증 정보를 나타내는 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let completed = GoalDetail.CompletedGoal(
    ///     goalId: 1,
    ///     photologId: 10,
    ///     owner: .mySelf,
    ///     imageUrl: "https://image.example.com",
    ///     comment: "오늘 목표 달성!",
    ///     createdAt: "방금 전"
    /// )
    /// ```
    public struct CompletedGoal: Equatable {
        public let myPhotoLog: PhotoLog?
        public let yourPhotoLog: PhotoLog?
        
        public init(myPhotoLog: PhotoLog?, yourPhotoLog: PhotoLog?) {
            self.myPhotoLog = myPhotoLog
            self.yourPhotoLog = yourPhotoLog
        }
        
        public struct PhotoLog: Equatable {
            public let goalId: Int64
            public var photologId: Int64?
            public var goalName: String?
            public let owner: Owner
            public var imageUrl: String?
            public var comment: String?
            public var reaction: Goal.Reaction?
            public let createdAt: String?
            
            
            /// 목표 인증 모델을 생성합니다.
            ///
            /// ## 사용 예시
            /// ```swift
            /// let completed = GoalDetail.CompletedGoal(
            ///     goalId: 1,
            ///     photologId: nil,
            ///     owner: .you,
            ///     imageUrl: nil,
            ///     comment: "응원할게요!",
            ///     createdAt: nil
            /// )
            /// ```
            public init(
                goalId: Int64,
                photologId: Int64?,
                goalName: String?,
                owner: Owner,
                imageUrl: String?,
                comment: String?,
                reaction: Goal.Reaction?,
                createdAt: String?
            ) {
                self.goalId = goalId
                self.photologId = photologId
                self.goalName = goalName
                self.owner = owner
                self.imageUrl = imageUrl
                self.comment = comment
                self.reaction = reaction
                self.createdAt = createdAt
            }
        }
        
    }
    
    /// 목표 인증 주체를 나타냅니다.
    public enum Owner: String {
        case mySelf
        case you
    }
}
