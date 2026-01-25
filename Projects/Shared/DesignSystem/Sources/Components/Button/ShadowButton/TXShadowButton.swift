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
///     action: { }
/// )
/// ```
public struct TXShadowButton: View {
    public struct Configuration {
        let text: String
        let font: TypographyToken = .t2_16b
        let buttonSize: CGSize = CGSize(width: 150, height: 68)
        let borderColor: Color
        let borderWidth: CGFloat = 1.6
        let shadowFrameSize: CGSize = CGSize(width: 150, height: 70)
        let shadowTopPadding: CGFloat = 4
        let frameHeight: CGFloat = 74

        public init(
            text: String,
            borderColor: Color
        ) {
            self.text = text
            self.borderColor = borderColor
        }
    }

    private let config: Configuration
    private let colorStyle: ColorStyle
    private let action: () -> Void

    public init(
        config: Configuration,
        colorStyle: ColorStyle,
        action: @escaping () -> Void
    ) {
        self.config = config
        self.colorStyle = colorStyle
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(config.text)
                .typography(config.font)
                .foregroundStyle(colorStyle.foregroundColor)
                .frame(width: config.buttonSize.width, height: config.buttonSize.height)
                .background(colorStyle.backgroundColor, in: .capsule)
        }
        .buttonStyle(.plain)
        .insideBorder(config.borderColor, shape: .capsule, lineWidth: config.borderWidth)
        .background(
            Capsule()
                .fill(colorStyle.foregroundColor)
                .frame(width: config.shadowFrameSize.width, height: config.shadowFrameSize.height)
                .padding(.top, config.shadowTopPadding)
        )
        .frame(height: config.frameHeight)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TXShadowButton(
        config: .detailGoal(text: "목표 미완료"),
        colorStyle: .black,
        action: { }
    )
}
