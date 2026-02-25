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
    ///     item: .init(
    ///         goalName: "목표 이름",
    ///         goalEmoji: .Icon.Illustration.exercise,
    ///         myCard: .init(image: nil, emoji: nil),
    ///         yourCard: .init(image: nil, emoji: nil)
    ///     ),
    ///     isMyChecked: false,
    ///     action: { }
    /// )
    /// ```
    public static func goalCheck(
        item: GoalCardItem,
        isMyChecked: Bool,
        isCoupleChecked: Bool = false,
        action: @escaping () -> Void,
        onHeaderTapped: (() -> Void)? = nil
    ) -> Self {
        let showsContent = item.myCard.isSelected || item.yourCard.isSelected
        let headerConfig: CardHeaderView.Configuration

        if showsContent {
            headerConfig = CardHeaderView.Configuration.goalCheckOpened(
                goalName: item.goalName,
                iconImage: item.goalEmoji,
                isMyChecked: isMyChecked,
                isCoupleChecked: isCoupleChecked,
                action: action,
                onHeaderTapped: onHeaderTapped
            )
        } else {
            headerConfig = CardHeaderView.Configuration.goalCheckClosed(
                goalName: item.goalName,
                iconImage: item.goalEmoji,
                isMyChecked: isMyChecked,
                isCoupleChecked: isCoupleChecked,
                action: action,
                onHeaderTapped: onHeaderTapped
            )
        }

        return Self(
            headerConfig: headerConfig,
            myItem: item.myCard,
            yourItem: item.yourCard,
            showsContent: showsContent,
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
