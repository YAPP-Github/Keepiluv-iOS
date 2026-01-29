//
//  TXToast.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// 토스트 메시지 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// // 기본 토스트 (아이콘 + 메시지)
/// TXToast(message: "목표를 달성했어요")
///
/// // 버튼이 있는 토스트
/// TXToast(
///     message: "목표를 달성했어요",
///     showButton: true,
///     onButtonTap: { ... }
/// )
///
/// // 커스텀 아이콘
/// TXToast(
///     icon: Image.Icon.Illustration.heart,
///     message: "좋아요를 눌렀어요"
/// )
/// ```
struct TXToast: View {
    private let icon: Image?
    private let message: String
    private let showButton: Bool
    private let onButtonTap: (() -> Void)?

    init(
        message: String,
        icon: Image? = nil,
        showButton: Bool = false,
        onButtonTap: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.message = message
        self.showButton = showButton
        self.onButtonTap = onButtonTap
    }

    var body: some View {
        HStack(spacing: 0) {
            contentView

            if showButton {
                TXRoundedRectangleButton(
                    config: .small(text: "자세히", colorStyle: .gray300),
                    action: { onButtonTap?() }
                )
            }
        }
        .frame(minHeight: Constants.minContentHeight)
        .padding(.horizontal, Constants.horizontalPadding)
        .padding(.vertical, Constants.verticalPadding)
        .frame(maxWidth: Constants.maxWidth(icon: icon), alignment: Constants.alignment(icon: icon))
        .background(Constants.backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .stroke(Constants.borderColor, lineWidth: Constants.borderWidth)
        )
        .shadow(
            color: Constants.shadowColor,
            radius: Constants.shadowRadius,
            x: Constants.shadowX,
            y: Constants.shadowY
        )
    }
}

// MARK: - SubViews
private extension TXToast {
    var contentView: some View {
        HStack(spacing: Constants.iconMessageSpacing) {
            if let icon {
                icon
                    .resizable()
                    .frame(width: Constants.iconSize, height: Constants.iconSize)
            }

            Text(message)
                .typography(Constants.messageFont)
                .foregroundStyle(Constants.textColor)
                .frame(maxWidth: Constants.maxWidth(icon: icon), alignment: Constants.alignment(icon: icon))
                .padding(.vertical, 5)
                .padding(.horizontal, icon != nil ? 2 : 18)
        }
    }
}

// MARK: - Constants
private extension TXToast {
    enum Constants {
        static let minContentHeight: CGFloat = 32
        static let horizontalPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 12
        static let iconMessageSpacing: CGFloat = 8
        static let iconSize: CGFloat = 24

        static let cornerRadius: CGFloat = Radius.s
        static let borderWidth: CGFloat = LineWidth.m

        static let backgroundColor: Color = Color.Gray.gray400
        static let borderColor: Color = Color.Gray.gray500
        static let textColor: Color = Color.Common.white
        static func maxWidth(icon: Image?) -> CGFloat? { icon != nil ? .infinity : nil }
        static func alignment(icon: Image?) -> Alignment { icon != nil ? .leading : .center }

        static let shadowColor: Color = Color.black.opacity(0.5)
        static let shadowRadius: CGFloat = 10
        static let shadowX: CGFloat = 2
        static let shadowY: CGFloat = 1

        static let messageFont: TypographyToken = .b1_14b
    }
}

#Preview("With Button") {
    ZStack {
        TXToast(
            message: "목표를 달성했어요",
            showButton: true,
            onButtonTap: { print("onButtonTap") }
        )
    }
}

#Preview("Without Button") {
    ZStack {
        TXToast(message: "목표를 달성했어요")
    }
}

#Preview("Custom Icon") {
    TXToast(
        message: "좋아요를 눌렀어요",
        icon: Image.Icon.Illustration.heart
    )
}
