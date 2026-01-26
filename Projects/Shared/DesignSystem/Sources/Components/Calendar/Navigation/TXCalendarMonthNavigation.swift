//
//  TXCalendarMonthNavigation.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 월 이동 내비게이션 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXCalendarMonthNavigation(
///     title: "2026.12",
///     onTitleTap: { showDatePicker = true },
///     onPrevious: { viewModel.previousMonth() },
///     onNext: { viewModel.nextMonth() }
/// )
/// ```
public struct TXCalendarMonthNavigation: View {
    /// 월 이동 내비게이션 레이아웃 설정입니다.
    public struct Configuration {
        let height: CGFloat
        let horizontalPadding: CGFloat
        let itemSpacing: CGFloat
        let buttonSize: CGFloat
        let iconSize: CGFloat
        let titleTypography: TypographyToken
        let titleColor: Color
        let iconColor: Color
        
        public init(
            height: CGFloat = Spacing.spacing12,
            horizontalPadding: CGFloat = Spacing.spacing8,
            itemSpacing: CGFloat = Spacing.spacing6,
            buttonSize: CGFloat = Spacing.spacing12,
            iconSize: CGFloat = Spacing.spacing9,
            titleTypography: TypographyToken = .t1_18eb,
            titleColor: Color = Color.Gray.gray500,
            iconColor: Color = Color.Gray.gray500
        ) {
            self.height = height
            self.horizontalPadding = horizontalPadding
            self.itemSpacing = itemSpacing
            self.buttonSize = buttonSize
            self.iconSize = iconSize
            self.titleTypography = titleTypography
            self.titleColor = titleColor
            self.iconColor = iconColor
        }
    }
    
    private let title: String
    private let config: Configuration
    private let onTitleTap: (() -> Void)?
    private let onPrevious: () -> Void
    private let onNext: () -> Void

    public init(
        title: String,
        config: Configuration = .init(),
        onTitleTap: (() -> Void)? = nil,
        onPrevious: @escaping () -> Void = { },
        onNext: @escaping () -> Void = { }
    ) {
        self.title = title
        self.config = config
        self.onTitleTap = onTitleTap
        self.onPrevious = onPrevious
        self.onNext = onNext
    }
    
    public var body: some View {
        HStack(spacing: config.itemSpacing) {
            navigationButton(icon: .Icon.Symbol.arrow1MLeft, action: onPrevious)
            titleView
            navigationButton(icon: .Icon.Symbol.arrow1MRight, action: onNext)
        }
        .padding(.horizontal, config.horizontalPadding)
        .frame(maxWidth: .infinity)
        .frame(height: config.height)
    }
}

// MARK: - Title
private extension TXCalendarMonthNavigation {
    @ViewBuilder
    var titleView: some View {
        if let onTitleTap {
            Button(action: onTitleTap) {
                titleLabel
            }
            .buttonStyle(.plain)
        } else {
            titleLabel
        }
    }

    var titleLabel: some View {
        Text(title)
            .typography(config.titleTypography)
            .foregroundStyle(config.titleColor)
    }
}

// MARK: - SubViews
private extension TXCalendarMonthNavigation {
    func navigationButton(icon: Image, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            icon
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(config.iconColor)
                .frame(width: config.iconSize, height: config.iconSize)
        }
        .buttonStyle(.plain)
        .frame(width: config.buttonSize, height: config.buttonSize)
    }
}
