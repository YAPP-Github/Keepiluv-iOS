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
///     id: "1",
///     title: "아이스크림 먹기",
///     completedGoal: []
/// )
/// ```
public struct GoalDetail: Equatable {
    public let id: Int
    public let title: String
    public let partnerNickname: String
    public var selectedIndex: Int?
    public var completedGoal: [CompletedGoal]
    
    /// 목표 상세 모델을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let detail = GoalDetail(
    ///     id: "1",
    ///     title: "아이스크림 먹기",
    ///     selectedIndex: 0,
    ///     completedGoal: []
    /// )
    /// ```
    public init(
        id: Int,
        title: String,
        partnerNickname: String,
        completedGoal: [CompletedGoal],
        selectedIndex: Int? = nil,
    ) {
        self.id = id
        self.title = title
        self.partnerNickname = partnerNickname
        self.completedGoal = completedGoal
        self.selectedIndex = selectedIndex
    }
    
    /// 목표 인증 정보를 나타내는 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let completed = GoalDetail.CompletedGoal(
    ///     owner: .mySelf,
    ///     comment: "오늘 목표 달성!",
    ///     createdAt: "방금 전"
    /// )
    /// ```
    public struct CompletedGoal: Equatable {
        public let owner: Owner
        public var imageUrl: String?
        public var comment: String?
        public let createdAt: String?
        
        /// 목표 인증 모델을 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let completed = GoalDetail.CompletedGoal(
        ///     owner: .you,
        ///     imageUrl: nil,
        ///     comment: "응원할게요!",
        ///     createdAt: nil
        /// )
        /// ```
        public init(
            owner: Owner,
            imageUrl: String?,
            comment: String?,
            createdAt: String?
        ) {
            self.owner = owner
            self.imageUrl = imageUrl
            self.comment = comment
            self.createdAt = createdAt
        }
    }
    
    /// 목표 인증 주체를 나타냅니다.
    public enum Owner: String {
        case mySelf
        case you
    }
}
