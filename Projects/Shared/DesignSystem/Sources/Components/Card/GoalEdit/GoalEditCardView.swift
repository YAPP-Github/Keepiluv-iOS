//
//  GoalEditCardView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

/// 목표 편집 카드 UI를 구성하는 뷰입니다.
///
/// ## 사용 예시
/// ```swift
/// GoalEditCardView(
///     config: .goalEdit(
///         goalName: "목표 이름",
///         item: .init(
///             repeatCycle: "매일",
///             startDate: "yyyy년 m월 d일",
///             endDate: "미설정"
///         ),
///         action: { }
///     )
/// )
/// ```
public struct GoalEditCardView: View {
    
    let item: GoalEditCardItem
    let onMenuTap: () -> Void
    
    public init(
        item: GoalEditCardItem,
        onMenuTap: @escaping () -> Void
    ) {
        self.item = item
        self.onMenuTap = onMenuTap
    }
   
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CardHeaderView(
                title: item.goalName,
                iconImage: item.iconImage,
                isBordered: false,
                onTap: nil
            ) {
                Button(action: onMenuTap) {
                    Image.Icon.Symbol.meatball
                }
            }
         
            VStack(alignment: .leading, spacing: Constants.rowSpacing) {
                rowView(title: "반복 주기", value: item.repeatCycle)
                rowView(title: "시작일", value: item.startDate)
                rowView(title: "종료일", value: item.endDate)
            }
            .padding(Constants.contentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
            .background(Constants.contentBackgroundColor)
        }
        .clipShape(RoundedRectangle(cornerRadius: Constants.cardCornerRadius))
        .outsideBorder(
            Constants.borderColor,
            shape: RoundedRectangle(cornerRadius: Constants.cardCornerRadius),
            lineWidth: Constants.borderWidth
        )
    }
}

// MARK: - SubViews
private extension GoalEditCardView {
    func rowView(title: String, value: String) -> some View {
        HStack(spacing: Constants.rowContentSpacing) {
            Text(title)
                .typography(Constants.titleTypography)
                .frame(width: Constants.titleWidth, alignment: .leading)
            
            Text(value)
                .typography(Constants.valueTypography)
        }
    }
}

private extension GoalEditCardView {
    enum Constants {
        static let rowSpacing: CGFloat = Spacing.spacing6
        static let rowContentSpacing: CGFloat = Spacing.spacing10
        static let titleWidth: CGFloat = 48
        static let contentPadding: CGFloat = Spacing.spacing7
        static let cardCornerRadius: CGFloat = Radius.s
        static let contentBackgroundColor: Color = Color.Gray.gray50
        static let borderColor: Color = Color.Gray.gray500
        static let borderWidth: CGFloat = LineWidth.m
        static let titleTypography: TypographyToken = .c1_12r
        static let valueTypography: TypographyToken = .b4_12b
    }
}
