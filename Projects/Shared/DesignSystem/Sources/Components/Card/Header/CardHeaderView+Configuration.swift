//
//  CardHeaderView+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

extension CardHeaderView {
    enum Content {
        case goalCheck(
            isMyChecked: Bool,
            isCoupleChecked: Bool,
            action: () -> Void
        )
        case goalAdd(action: () -> Void)
        case goalEdit(action: () -> Void)
        case goalStats(goalCount: Int)
    }
    
    /// CardHeaderView에 필요한 스타일/데이터를 묶는 설정 값입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = CardHeaderView.Configuration.goalAdd(
    ///     goalName: "목표 이름",
    ///     iconImage: .Icon.Illustration.exercise,
    ///     action: { }
    /// )
    /// ```
    public struct Configuration {
        let goalName: String
        let iconImage: Image
        let content: Content
        var isBordered: Bool
        let padding: CGFloat
        let contentSpacing: CGFloat
        let radius: CGFloat
        let borderColor: Color
        let borderWidth: CGFloat
        let titleTypography: TypographyToken
        let onHeaderTapped: (() -> Void)?

        init(
            goalName: String,
            iconImage: Image,
            content: Content,
            isBordered: Bool,
            padding: CGFloat,
            contentSpacing: CGFloat,
            radius: CGFloat,
            borderColor: Color,
            borderWidth: CGFloat,
            titleTypography: TypographyToken,
            onHeaderTapped: (() -> Void)? = nil
        ) {
            self.goalName = goalName
            self.iconImage = iconImage
            self.content = content
            self.isBordered = isBordered
            self.padding = padding
            self.contentSpacing = contentSpacing
            self.radius = radius
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.titleTypography = titleTypography
            self.onHeaderTapped = onHeaderTapped
        }
    }
}

extension CardHeaderView.Configuration {
    /// 체크 상태 표시가 있는 카드 헤더 구성을 생성합니다. (열림 상태)
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = CardHeaderView.Configuration.goalCheckOpened(
    ///     goalName: "목표 이름",
    ///     iconImage: .Icon.Illustration.exercise,
    ///     isMyChecked: false,
    ///     action: { }
    /// )
    /// ```
    public static func goalCheckOpened(
        goalName: String,
        iconImage: Image,
        isMyChecked: Bool,
        isCoupleChecked: Bool = false,
        action: @escaping () -> Void,
        onHeaderTapped: (() -> Void)? = nil
    ) -> Self {
        makeGoalCheck(
            goalName: goalName,
            iconImage: iconImage,
            isMyChecked: isMyChecked,
            isCoupleChecked: isCoupleChecked,
            action: action,
            isBordered: false,
            onHeaderTapped: onHeaderTapped
        )
    }

    /// 체크 상태 표시가 있는 카드 헤더 구성을 생성합니다. (닫힘 상태)
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = CardHeaderView.Configuration.goalCheckClosed(
    ///     goalName: "목표 이름",
    ///     iconImage: .Icon.Illustration.exercise,
    ///     isMyChecked: false,
    ///     action: { }
    /// )
    /// ```
    public static func goalCheckClosed(
        goalName: String,
        iconImage: Image,
        isMyChecked: Bool,
        isCoupleChecked: Bool = false,
        action: @escaping () -> Void,
        onHeaderTapped: (() -> Void)? = nil
    ) -> Self {
        makeGoalCheck(
            goalName: goalName,
            iconImage: iconImage,
            isMyChecked: isMyChecked,
            isCoupleChecked: isCoupleChecked,
            action: action,
            isBordered: true,
            onHeaderTapped: onHeaderTapped
        )
    }

    /// 추가 액션이 있는 카드 헤더 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = CardHeaderView.Configuration.goalAdd(
    ///     goalName: "목표 이름",
    ///     iconImage: .Icon.Illustration.exercise,
    ///     action: { }
    /// )
    /// ```
    public static func goalAdd(
        goalName: String,
        iconImage: Image,
        action: @escaping () -> Void
    ) -> Self {
        Self(
            goalName: goalName,
            iconImage: iconImage,
            content: .goalAdd(action: action),
            isBordered: true,
            padding: Spacing.spacing7,
            contentSpacing: Spacing.spacing6,
            radius: Radius.s,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            titleTypography: .t2_16b
        )
    }

    /// 편집 액션이 있는 카드 헤더 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = CardHeaderView.Configuration.goalEdit(
    ///     goalName: "목표 이름",
    ///     iconImage: .Icon.Illustration.exercise,
    ///     action: { }
    /// )
    /// ```
    public static func goalEdit(
        goalName: String,
        iconImage: Image,
        action: @escaping () -> Void
    ) -> Self {
        Self(
            goalName: goalName,
            iconImage: iconImage,
            content: .goalEdit(action: action),
            isBordered: false,
            padding: Spacing.spacing7,
            contentSpacing: Spacing.spacing6,
            radius: Radius.s,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            titleTypography: .t2_16b
        )
    }

    /// 목표 통계 정보가 있는 카드 헤더 구성을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = CardHeaderView.Configuration.goalStats(
    ///     goalName: "목표 이름",
    ///     iconImage: .Icon.Illustration.exercise,
    ///     goalCount: 3
    /// )
    /// ```
    public static func goalStats(
        goalName: String,
        iconImage: Image,
        goalCount: Int
    ) -> Self {
        Self(
            goalName: goalName,
            iconImage: iconImage,
            content: .goalStats(goalCount: goalCount),
            isBordered: false,
            padding: Spacing.spacing7,
            contentSpacing: Spacing.spacing6,
            radius: Radius.s,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            titleTypography: .t2_16b
        )
    }

    private static func makeGoalCheck(
        goalName: String,
        iconImage: Image,
        isMyChecked: Bool,
        isCoupleChecked: Bool,
        action: @escaping () -> Void,
        isBordered: Bool,
        onHeaderTapped: (() -> Void)? = nil
    ) -> Self {
        Self(
            goalName: goalName,
            iconImage: iconImage,
            content: .goalCheck(
                isMyChecked: isMyChecked,
                isCoupleChecked: isCoupleChecked,
                action: action
            ),
            isBordered: isBordered,
            padding: Spacing.spacing7,
            contentSpacing: Spacing.spacing6,
            radius: Radius.s,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            titleTypography: .t2_16b,
            onHeaderTapped: onHeaderTapped
        )
    }
}
