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
    
    /// GoalEditCardView에 필요한 스타일/데이터를 묶는 설정 값입니다.
    public struct Configuration {
        let headerConfig: CardHeaderView.Configuration
        let rowSpacing: CGFloat
        let rowContentSpacing: CGFloat
        let titleWidth: CGFloat
        let contentPadding: CGFloat
        let cardCornerRadius: CGFloat
        let contentBackgroundColor: Color
        let borderColor: Color
        let borderWidth: CGFloat
        let titleTypography: TypographyToken
        let valueTypography: TypographyToken
        let item: GoalEditCardItem
        
        /// 구성 값으로 GoalEditCardView.Configuration을 생성합니다.
        public init(
            headerConfig: CardHeaderView.Configuration,
            rowSpacing: CGFloat,
            rowContentSpacing: CGFloat,
            titleWidth: CGFloat,
            contentPadding: CGFloat,
            cardCornerRadius: CGFloat,
            contentBackgroundColor: Color,
            borderColor: Color,
            borderWidth: CGFloat,
            titleTypography: TypographyToken,
            valueTypography: TypographyToken,
            item: GoalEditCardItem
        ) {
            self.headerConfig = headerConfig
            self.rowSpacing = rowSpacing
            self.rowContentSpacing = rowContentSpacing
            self.titleWidth = titleWidth
            self.contentPadding = contentPadding
            self.cardCornerRadius = cardCornerRadius
            self.contentBackgroundColor = contentBackgroundColor
            self.borderColor = borderColor
            self.borderWidth = borderWidth
            self.titleTypography = titleTypography
            self.valueTypography = valueTypography
            self.item = item
        }
    }
    
    private let config: Configuration
    
    /// 구성 값으로 GoalEditCardView를 생성합니다.
    public init(config: Configuration) {
        self.config = config
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            CardHeaderView(
                config: config.headerConfig
            )
         
            VStack(alignment: .leading, spacing: config.rowSpacing) {
                rowView(title: "반복 주기", value: config.item.repeatCycle)
                rowView(title: "시작일", value: config.item.startDate)
                rowView(title: "종료일", value: config.item.endDate)
            }
            .padding(config.contentPadding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .clipShape(RoundedRectangle(cornerRadius: config.cardCornerRadius))
            .background(config.contentBackgroundColor)
            .insideBorder(
                config.borderColor,
                shape: UnevenRoundedRectangle(
                    cornerRadii: .init(
                        bottomLeading: config.cardCornerRadius,
                        bottomTrailing: config.cardCornerRadius
                    ),
                    style: .continuous
                ),
                lineWidth: config.borderWidth
            )
        }
        .clipShape(RoundedRectangle(cornerRadius: config.cardCornerRadius))
        .outsideBorder(
            config.borderColor,
            shape: RoundedRectangle(cornerRadius: config.cardCornerRadius),
            lineWidth: config.borderWidth
        )
    }
}

// MARK: - SubViews
private extension GoalEditCardView {
    func rowView(title: String, value: String) -> some View {
        HStack(spacing: config.rowContentSpacing) {
            Text(title)
                .typography(config.titleTypography)
                .frame(width: config.titleWidth, alignment: .leading)
            
            Text(value)
                .typography(config.valueTypography)
        }
    }
}

#Preview {
    GoalEditCardView(
        config: .goalEdit(
            goalName: "목표 이름",
            item: .init(
                repeatCycle: "매일",
                startDate: "yyyy년 m월 d일",
                endDate: "미설정",
            ),
            action: { }
        )
    )
    .padding(.horizontal, 20)
}
