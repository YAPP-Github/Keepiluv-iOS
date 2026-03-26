//
//  TXShadowButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/25/26.
//

import SwiftUI

/// 강조용 볼드 버튼 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXShadowButton(
///     config: .detailGoal(text: "목표 미완료"),
///     colorStyle: .black,
///     action: { }
/// )
/// ```
public struct TXShadowButton: View {
    /// 버튼의 스타일 구성을 정의합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let config = TXShadowButton.Configuration(
    ///     text: "업로드하기",
    ///     borderColor: .black,
    ///     style: .long
    /// )
    /// ```
    public struct Configuration {
        /// 버튼 사이즈 스타일입니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let style: TXShadowButton.Configuration.Style = .long
        /// ```
        public enum Style {
            case medium
            case long
        }

        let text: String
        let font: TypographyToken = .t2_16b
        let style: Style
        let buttonHeight: CGFloat = 68
        var borderColor: Color = .clear
        let borderWidth: CGFloat = 1.6
        let shadowHeight: CGFloat = 70
        let shadowTopPadding: CGFloat = 6
        let frameHeight: CGFloat = 74

        var buttonWidth: CGFloat? {
            switch style {
            case .medium: return 150
            case .long: return nil
            }
        }

        var maxWidth: CGFloat? {
            switch style {
            case .medium: return nil
            case .long: return .infinity
            }
        }
        /// 버튼 구성 값을 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let config = TXShadowButton.Configuration(
        ///     text: "업로드하기",
        ///     borderColor: .black,
        ///     style: .medium
        /// )
        /// ```
        public init(
            text: String,
            style: Style
        ) {
            self.text = text
            self.style = style
        }
    }

    private var config: Configuration
    private let colorStyle: ColorStyle
    private let action: () -> Void

    /// ShadowButton을 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXShadowButton(
    ///     config: .detailGoal(text: "목표 미완료"),
    ///     colorStyle: .black,
    ///     action: { }
    /// )
    /// ```
    public init(
        config: Configuration,
        colorStyle: ColorStyle,
        action: @escaping () -> Void
    ) {
        self.config = config
        self.colorStyle = colorStyle
        self.config.borderColor = colorStyle == .black ? .Common.white : .Gray.gray500
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(config.text)
                .typography(config.font)
                .foregroundStyle(colorStyle.foregroundColor)
                .frame(width: config.buttonWidth, height: config.buttonHeight)
                .frame(maxWidth: config.maxWidth)
                .background(colorStyle.backgroundColor, in: .capsule)
        }
        .buttonStyle(.plain)
        .insideBorder(config.borderColor, shape: .capsule, lineWidth: config.borderWidth)
        .background(
            Capsule()
                .fill(colorStyle.foregroundColor)
                .frame(width: config.buttonWidth, height: config.shadowHeight)
                .frame(maxWidth: config.maxWidth)
                .padding(.top, config.shadowTopPadding)
        )
        .frame(height: config.frameHeight)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TXShadowButton(
        config: .medium(text: "목표 미완료"),
        colorStyle: .black,
        action: { }
    )
}
