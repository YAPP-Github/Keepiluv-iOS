//
//  StatsCardItem.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/19/26.
//

import SwiftUI

/// 통계 카드 UI를 구성하기 위한 목표별 표시 모델입니다.
public struct StatsCardItem: Equatable {
    /// 통계 카드에서 사용하는 스탬프 색상 타입입니다.
    public enum StampColor: Equatable {
        case green400
        case blue400
        case yellow400
        case pink400
        case pink300
        case pink200
        case orange400
        case purple400
    }

    public let goalId: Int64
    public let goalName: String
    public let iconImage: Image
    public let stampIcon: TXVector.Icon
    public let goalCount: Int
    public let completionInfos: [CompletionInfo]
    
    /// 사용자별 완료 횟수와 스탬프 색상 정보를 표현하는 모델입니다.
    public struct CompletionInfo: Equatable {
        public let name: String
        public let count: Int
        public let stampColors: [StampColor]
        
        /// 사용자 완료 정보를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let info = StatsCardItem.CompletionInfo(
        ///     name: "민정",
        ///     count: 10,
        ///     stampColors: [.green400, .blue400]
        /// )
        /// ```
        public init(
            name: String,
            count: Int,
            stampColors: [StampColor]
        ) {
            self.name = name
            self.count = count
            self.stampColors = stampColors
        }
    }
    
    /// 통계 카드 표시 모델을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let item = StatsCardItem(
    ///     goalId: 1,
    ///     goalName: "독서하기",
    ///     iconImage: .Icon.Illustration.book,
    ///     stampIcon: .clover,
    ///     goalCount: 30,
    ///     completionInfos: []
    /// )
    /// ```
    public init(
        goalId: Int64,
        goalName: String,
        iconImage: Image,
        stampIcon: TXVector.Icon,
        goalCount: Int,
        completionInfos: [CompletionInfo]
    ) {
        self.goalId = goalId
        self.goalName = goalName
        self.iconImage = iconImage
        self.stampIcon = stampIcon
        self.goalCount = goalCount
        self.completionInfos = completionInfos
    }
}
