//
//  TXCalendarDateStyle.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 캘린더에서 사용하는 날짜 셀 스타일입니다.
///
/// ## 사용 예시
/// ```swift
/// let style = TXCalendarDateStyle()
/// ```
public struct TXCalendarDateStyle {
    let size: CGFloat
    let cornerRadius: CGFloat
    let borderWidth: CGFloat
    let typography: TypographyToken
    let defaultTextColor: Color
    let lastMonthTextColor: Color
    let selectedFilledTextColor: Color
    let selectedFilledBackgroundColor: Color
    let selectedLineTextColor: Color
    let selectedLineBackgroundColor: Color
    let selectedLineBorderColor: Color
    
    public init(
        size: CGFloat = Spacing.spacing8 + Spacing.spacing8,
        cornerRadius: CGFloat = Radius.xl,
        borderWidth: CGFloat = LineWidth.m,
        typography: TypographyToken = .b1_14b,
        defaultTextColor: Color = Color.Gray.gray500,
        lastMonthTextColor: Color = Color.Gray.gray200,
        selectedFilledTextColor: Color = Color.Common.white,
        selectedFilledBackgroundColor: Color = Color.Gray.gray500,
        selectedLineTextColor: Color = Color.Gray.gray500,
        selectedLineBackgroundColor: Color = Color.Common.white,
        selectedLineBorderColor: Color = Color.Gray.gray500
    ) {
        self.size = size
        self.cornerRadius = cornerRadius
        self.borderWidth = borderWidth
        self.typography = typography
        self.defaultTextColor = defaultTextColor
        self.lastMonthTextColor = lastMonthTextColor
        self.selectedFilledTextColor = selectedFilledTextColor
        self.selectedFilledBackgroundColor = selectedFilledBackgroundColor
        self.selectedLineTextColor = selectedLineTextColor
        self.selectedLineBackgroundColor = selectedLineBackgroundColor
        self.selectedLineBorderColor = selectedLineBorderColor
    }
}
