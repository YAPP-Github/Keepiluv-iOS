//
//  CardHeaderView+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

extension CardHeaderView {
    enum Content {
        case goalCheck(isMyChecked: Binding<Bool>, isCoupleChecked: Bool)
        case goalAdd(action: () -> Void)
        case goalEdit(action: () -> Void)
        case goalStats(goalCount: Int)
    }
    
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
            titleTypography: TypographyToken
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
        }
    }
}

extension CardHeaderView.Configuration {
    public static func goalCheckOpened(
        goalName: String,
        iconImage: Image,
        isMyChecked: Binding<Bool>,
        isCoupleChecked: Bool = false
    ) -> Self {
        makeGoalCheck(
            goalName: goalName,
            iconImage: iconImage,
            isMyChecked: isMyChecked,
            isCoupleChecked: isCoupleChecked,
            isBordered: false
        )
    }

    public static func goalCheckClosed(
        goalName: String,
        iconImage: Image,
        isMyChecked: Binding<Bool>,
        isCoupleChecked: Bool = false
    ) -> Self {
        makeGoalCheck(
            goalName: goalName,
            iconImage: iconImage,
            isMyChecked: isMyChecked,
            isCoupleChecked: isCoupleChecked,
            isBordered: true
        )
    }

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
        isMyChecked: Binding<Bool>,
        isCoupleChecked: Bool,
        isBordered: Bool
    ) -> Self {
        Self(
            goalName: goalName,
            iconImage: iconImage,
            content: .goalCheck(
                isMyChecked: isMyChecked,
                isCoupleChecked: isCoupleChecked
            ),
            isBordered: isBordered,
            padding: Spacing.spacing7,
            contentSpacing: Spacing.spacing6,
            radius: Radius.s,
            borderColor: Color.Gray.gray500,
            borderWidth: LineWidth.m,
            titleTypography: .t2_16b
        )
    }
}
