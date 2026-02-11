//
//  Goal.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

/// 목표 카드에 표시할 목표 데이터 모델입니다.
///
/// ## 사용 예시
/// ```swift
/// let goal = Goal(
///     id: 1,
///     goalIcon: .exercise,
///     title: "목표 1111111",
///     myVerification: .init(isCompleted: false, imageURL: nil, emoji: nil),
///     yourVerification: .init(isCompleted: false, imageURL: nil, emoji: nil)
/// )
/// ```
public struct Goal {
    /// 목표 아이콘 종류입니다.
    public enum Icon: String, Equatable, CaseIterable {
        case `default` = "ICON_DEFAULT"
        case clean = "ICON_CLEAN"
        case exercise = "ICON_EXERCISE"
        case book = "ICON_BOOK"
        case pencil = "ICON_PENCIL"
        case health = "ICON_HEALTH"
        case heartDouble = "ICON_HEART"
        case laptop = "ICON_LAPTOP"
    }
    
    /// 목표 인증 리액션 종류입니다.
    public enum Reaction: String, Equatable {
        case happy = "ICON_HAPPY"
        case trouble = "ICON_TROUBLE"
        case love = "ICON_LOVE"
        case doubt = "ICON_DOUBT"
        case fuck = "ICON_FUCK"
        case heart = "ICON_HEART"
    }
    
    public enum RepeatCycle: String, Equatable {
        case daily = "DAILY"
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
    }
    
    public let id: Int64
    public let goalIcon: Icon
    public let title: String
    public let myVerification: Verification?
    public let yourVerification: Verification?
    public let repeatCycle: RepeatCycle?
    public let repeatCount: Int?
    public let startDate: String?
    public let endDate: String?
    
    /// 목표 인증 상태를 나타내는 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let verification = Goal.Verification(
    ///     isCompleted: true,
    ///     imageURL: "https://example.com/image.png",
    ///     emoji: .love
    /// )
    /// ```
    public struct Verification {
        public let isCompleted: Bool
        public let imageURL: String?
        public let emoji: Reaction?
        
        /// 목표 인증 정보를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let verification = Goal.Verification(
        ///     isCompleted: false,
        ///     imageURL: nil,
        ///     emoji: nil
        /// )
        /// ```
        public init(
            isCompleted: Bool,
            imageURL: String?,
            emoji: Reaction?
        ) {
            self.isCompleted = isCompleted
            self.imageURL = imageURL
            self.emoji = emoji
        }
    }
    
    /// 목표 데이터를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let goal = Goal(
    ///     id: 1,
    ///     goalIcon: .exercise,
    ///     title: "목표 1111111",
    ///     myVerification: .init(isCompleted: false, imageURL: nil, emoji: nil),
    ///     yourVerification: .init(isCompleted: false, imageURL: nil, emoji: nil)
    /// )
    /// ```
    public init(
        id: Int64,
        goalIcon: Icon,
        title: String,
        myVerification: Verification?,
        yourVerification: Verification?,
        repeatCycle: RepeatCycle? = nil,
        repeatCount: Int? = nil,
        startDate: String? = nil,
        endDate: String? = nil
    ) {
        self.id = id
        self.goalIcon = goalIcon
        self.title = title
        self.myVerification = myVerification
        self.yourVerification = yourVerification
        self.repeatCycle = repeatCycle
        self.repeatCount = repeatCount
        self.startDate = startDate
        self.endDate = endDate
    }
}
