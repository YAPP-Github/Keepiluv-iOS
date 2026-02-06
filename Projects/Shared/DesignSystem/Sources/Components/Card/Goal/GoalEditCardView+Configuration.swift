//
//  GoalEditCardView+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

extension GoalEditCardView.Configuration {
    /// 목표 편집 카드 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = GoalEditCardView.Configuration.goalEdit(
    ///     goalName: "목표 이름",
    ///     item: .init(
    ///         repeatCycle: "매일",
    ///         startDate: "yyyy년 m월 d일",
    ///         endDate: "미설정"
    ///     ),
    ///     action: { }
    /// )
    /// ```
    public static func goalEdit(
        item: GoalEditCardItem,
        action: @escaping () -> Void
    ) -> Self {
        let headerConfig = CardHeaderView.Configuration.goalEdit(
            goalName: item.goalName,
            iconImage: item.iconImage,
            action: action
        )

        return Self(
            headerConfig: headerConfig,
            rowSpacing: 12,
            rowContentSpacing: 28,
            titleWidth: 48,
            contentPadding: 16,
            cardCornerRadius: 16,
            contentBackgroundColor: Color.Gray.gray50,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            titleTypography: .c1_12r,
            valueTypography: .b4_12b,
            item: item
        )
    }
}
