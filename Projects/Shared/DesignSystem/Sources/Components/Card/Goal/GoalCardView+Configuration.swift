//
//  GoalCardView+Config.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

extension GoalCardView.Configuration {
    /// 목표 체크형 카드 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = GoalCardView.Configuration.goalCheck(
    ///     goalName: "목표 이름",
    ///     myItem: .empty,
    ///     yourItem: .empty,
    ///     isMyChecked: .constant(false)
    /// )
    /// ```
    public static func goalCheck(
        goalName: String,
        myItem: GoalCardItem,
        yourItem: GoalCardItem,
        isMyChecked: Binding<Bool>
    ) -> Self {
        let headerConfig = CardHeaderView.Configuration.goalCheckOpened(
            goalName: goalName,
            iconImage: .Icon.Illustration.exercise,
            isMyChecked: isMyChecked
        )

        return Self(
            headerConfig: headerConfig,
            myItem: myItem,
            yourItem: yourItem,
            contentBackgroundColor: Color.Gray.gray50,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            cornerRadius: 16,
            imageHeight: 136,
            emojiSize: CGSize(width: 32, height: 32),
            emojiPadding: Spacing.spacing4
        )
    }
}
