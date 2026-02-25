//
//  CardHeaderView.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

/// 카드 헤더 영역을 구성하는 뷰입니다.
///
/// ## 사용 예시
/// ```swift
/// CardHeaderView(
///     config: .goalCheckClosed(
///         goalName: "목표 이름",
///         iconImage: .Icon.Illustration.exercise,
///         isMyChecked: isMyChecked,
///         action: { }
///     )
/// )
/// ```
public struct CardHeaderView: View {
    
    private let config: Configuration
    
    /// 스타일과 아이콘/제목을 전달해 카드 헤더를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// CardHeaderView(
    ///     config: .goalCheckClosed(
    ///         goalName: "목표 이름",
    ///         iconImage: .Icon.Illustration.exercise,
    ///         isMyChecked: false,
    ///         action: { }
    ///     )
    /// )
    /// ```
    public init(config: Configuration) {
        self.config = config
    }
    
    public var body: some View {
        if config.isBordered {
            borderCard
        } else {
            nonBorderCard
        }
    }
}

// MARK: - SubViews
private extension CardHeaderView {
    
    var borderCard: some View {
        baseContent
            .clipShape(RoundedRectangle(cornerRadius: config.radius))
            .outsideBorder(
                config.borderColor,
                shape: RoundedRectangle(cornerRadius: config.radius),
                lineWidth: config.borderWidth
            )
    }
    
    var nonBorderCard: some View {
        baseContent
    }
    
    var baseContent: some View {
        HStack(spacing: config.contentSpacing) {
            HStack(spacing: config.contentSpacing) {
                config.iconImage

                Text(config.goalName)
                    .typography(config.titleTypography)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                config.onHeaderTapped?()
            }

            Spacer()
                .contentShape(Rectangle())
                .onTapGesture {
                    config.onHeaderTapped?()
                }

            rightContent
        }
        .padding(config.padding)
        .background(Color.Common.white)
    }
    
    @ViewBuilder var rightContent: some View {
        switch config.content {
        case let .goalCheck(isMyChecked, isCoupleChecked, action):
            TXToggleButton(
                config: .goalCheck(),
                isMyChecked: isMyChecked,
                isCoupleChecked: isCoupleChecked,
                action: action
            )
            
        case let .goalAdd(action):
            TXCircleButton(config: .rightArrow()) {
                action()
            }
            
        case let .goalEdit(action):
            Button(action: action) {
                Image.Icon.Symbol.meatball
            }
            
        case let .goalStats(goalCount):
            Text("이번달 목표 \(goalCount)번")
                .typography(.b1_14b)
        }
    }
}

#Preview {
    CardHeaderPreview()
}

private struct CardHeaderPreview: View {
    @State private var isMyChecked = false

    var body: some View {
        VStack {
            CardHeaderView(
                config: .goalCheckClosed(
                    goalName: "목표 이름",
                    iconImage: .Icon.Illustration.exercise,
                    isMyChecked: isMyChecked,
                    action: { isMyChecked.toggle() }
                )
            )
            
            CardHeaderView(
                config: .goalAdd(
                    goalName: "목표 이름",
                    iconImage: .Icon.Illustration.exercise,
                    action: { }
                )
            )
        }
        .padding(.horizontal, Spacing.spacing8)
    }
}
