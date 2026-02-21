//
//  Stats.swift
//  DomainStats
//
//  Created by 정지훈 on 2/18/26.
//

import Foundation

/// 통계 화면에서 사용하는 사용자별 목표 달성 통계 모델입니다.
///
/// 월간 통계와 누적 통계를 동일한 구조로 표현합니다.
///
/// ## 사용 예시
/// ```swift
/// let stats = Stats(
///     myNickname: "현수",
///     partnerNickname: "민정",
///     stats: []
/// )
/// ```
public struct Stats: Equatable {
    /// 목표 반복 주기 타입입니다.
    public enum RepeatCycle: String, Equatable {
        case daily = "DAILY"
        case weekly = "WEEKLY"
        case monthly = "MONTHLY"
    }

    public let myNickname: String
    public let partnerNickname: String
    public let stats: [StatsItem]
    
    /// 통계 모델을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let item = Stats.StatsItem(
    ///     goalId: 1,
    ///     icon: "ICON_BOOK",
    ///     goalName: "독서하기",
    ///     monthlyCount: 12,
    ///     totalCount: nil,
    ///     myCompletedCount: 6,
    ///     partnerCompletedCount: 2
    /// )
    ///
    /// let stats = Stats(
    ///     myNickname: "현수",
    ///     partnerNickname: "민정",
    ///     stats: [item]
    /// )
    /// ```
    public init(
        myNickname: String,
        partnerNickname: String,
        stats: [StatsItem]
    ) {
        self.myNickname = myNickname
        self.partnerNickname = partnerNickname
        self.stats = stats
    }
    
    /// 단일 목표의 달성 통계를 표현하는 항목 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let item = Stats.StatsItem(
    ///     goalId: 1,
    ///     icon: "ICON_BOOK",
    ///     goalName: "독서하기",
    ///     monthlyCount: 12,
    ///     totalCount: nil,
    ///     myCompletedCount: 6,
    ///     partnerCompletedCount: 2
    /// )
    /// ```
    public struct StatsItem: Equatable {
        public let goalId: Int64
        public let icon: String
        public let goalName: String
        public let monthlyCount: Int?
        public let totalCount: Int?
        public let myCompletedCount: Int
        public let partnerCompletedCount: Int
        
        /// 단일 목표 통계 항목을 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let item = Stats.StatsItem(
        ///     goalId: 1,
        ///     icon: "ICON_BOOK",
        ///     goalName: "독서하기",
        ///     monthlyCount: 12,
        ///     totalCount: nil,
        ///     myCompletedCount: 6,
        ///     partnerCompletedCount: 2
        /// )
        /// ```
        public init(
            goalId: Int64,
            icon: String,
            goalName: String,
            monthlyCount: Int?,
            totalCount: Int?,
            myCompletedCount: Int,
            partnerCompletedCount: Int
        ) {
            self.goalId = goalId
            self.icon = icon
            self.goalName = goalName
            self.monthlyCount = monthlyCount
            self.totalCount = totalCount
            self.myCompletedCount = myCompletedCount
            self.partnerCompletedCount = partnerCompletedCount
        }
    }
}
