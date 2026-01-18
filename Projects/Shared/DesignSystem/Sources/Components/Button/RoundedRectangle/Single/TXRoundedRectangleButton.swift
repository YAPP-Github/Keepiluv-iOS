//
//  TXRoundedRectangleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 라운드 사각형 텍스트 버튼 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXRoundedRectangleButton(
///     style: .medium(content: .cancel, colorStyle: .white),
///     action: { }
/// )
/// ```
public struct TXRoundedRectangleButton: View {
    private let style: Style
    private let action: () -> Void

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: style.radius)
    }

    public init(
        style: Style,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            label()
        }
    }
}

private extension TXRoundedRectangleButton {
    
    func baseText() -> some View {
        Text(style.text)
            .typography(style.font)
            .foregroundStyle(style.colorStyle.foregroundColor)
    }
    
    @ViewBuilder
    func label() -> some View {
        Group {
            if style.fixedFrame {
                baseText()
                    .frame(height: style.height)
                    .frame(maxWidth: style.width)
            } else {
                baseText()
                    .padding(.horizontal, style.horizontalPadding)
                    .padding(.vertical, style.verticalPadding)
            }
        }
        .background(style.colorStyle.backgroundColor, in: shape)
        .insideBorder(
            style.colorStyle.borderColor,
            shape: shape,
            lineWidth: style.borderWidth
        )
    }
}

// swiftlint:disable closure_body_length
#Preview {
    VStack(spacing: 10) {
        HStack {
            TXRoundedRectangleButton(
                style: .small(
                    content: .goToDetail,
                    colorStyle: .white
                ),
                action: { }
            )
            
            TXRoundedRectangleButton(
                style: .small(
                    content: .goToDetail,
                    colorStyle: .black
                ),
                action: { }
            )
        }

        HStack {
            
            TXRoundedRectangleButton(
                style: .medium(
                    content: .cancel,
                    colorStyle: .white
                ),
                action: { }
            )
            
            TXRoundedRectangleButton(
                style: .medium(
                    content: .goalCompleted,
                    colorStyle: .black
                ),
                action: { }
            )
        }

        TXRoundedRectangleButton(
            style: .long(
                content: .confirm,
                colorStyle: .black
            ),
            action: { }
        )
        .padding(.horizontal, 20)
    }
}
// swiftlint:enable closure_body_length
