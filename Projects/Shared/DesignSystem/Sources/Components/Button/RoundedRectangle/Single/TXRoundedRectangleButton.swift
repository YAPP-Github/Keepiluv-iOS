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
///     config: .medium(text: "취소", colorStyle: .white),
///     action: { }
/// )
/// ```
public struct TXRoundedRectangleButton: View {
    public struct Configuration {
        let text: String
        let font: TypographyToken
        let colorStyle: ColorStyle
        let fixedFrame: Bool
        let minWidth: CGFloat = 56
        let radius: CGFloat
        let borderWidth: CGFloat
        let width: CGFloat?
        let height: CGFloat?
        let horizontalPadding: CGFloat?
        let verticalPadding: CGFloat?
        
        public init(
            text: String,
            font: TypographyToken,
            colorStyle: ColorStyle,
            fixedFrame: Bool,
            radius: CGFloat,
            borderWidth: CGFloat,
            width: CGFloat? = nil,
            height: CGFloat? = nil,
            horizontalPadding: CGFloat? = nil,
            verticalPadding: CGFloat? = nil
        ) {
            self.text = text
            self.font = font
            self.colorStyle = colorStyle
            self.fixedFrame = fixedFrame
            self.radius = radius
            self.borderWidth = borderWidth
            self.width = width
            self.height = height
            self.horizontalPadding = horizontalPadding
            self.verticalPadding = verticalPadding
        }
    }
    
    private let config: Configuration
    private let action: () -> Void

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: config.radius)
    }

    public init(
        config: Configuration,
        action: @escaping () -> Void
    ) {
        self.config = config
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
        Text(config.text)
            .typography(config.font)
            .foregroundStyle(config.colorStyle.foregroundColor)
    }
    
    @ViewBuilder
    func label() -> some View {
        Group {
            if config.fixedFrame {
                baseText()
                    .frame(height: config.height)
                    .frame(maxWidth: config.width)
            } else {
                baseText()
                    .padding(.horizontal, config.horizontalPadding)
                    .padding(.vertical, config.verticalPadding)
            }
        }
        .frame(minWidth: 56)
        .background(config.colorStyle.backgroundColor, in: shape)
        .insideBorder(
            config.colorStyle.borderColor,
            shape: shape,
            lineWidth: config.borderWidth
        )
    }
}

// swiftlint:disable closure_body_length
#Preview {
    VStack(spacing: 10) {
        HStack {
            TXRoundedRectangleButton(
                config: .small(
                    text: "보러가기",
                    colorStyle: .white
                ),
                action: { }
            )
            
            TXRoundedRectangleButton(
                config: .small(
                    text: "보러가기",
                    colorStyle: .black
                ),
                action: { }
            )
        }
        
        HStack {
            TXRoundedRectangleButton(
                config: .medium(
                    text: "취소",
                    colorStyle: .white
                ),
                action: { }
            )
            
            TXRoundedRectangleButton(
                config: .medium(
                    text: "목표 완료",
                    colorStyle: .black
                ),
                action: { }
            )
        }
        
        TXRoundedRectangleButton(
            config: .long(
                text: "확인",
                colorStyle: .black
            ),
            action: { }
        )
        .padding(.horizontal, 20)
    }
}
// swiftlint:enable closure_body_length
