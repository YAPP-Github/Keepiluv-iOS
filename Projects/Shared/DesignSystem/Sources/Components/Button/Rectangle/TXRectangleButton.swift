//
//  TXRectangleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 사각형 버튼 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXRectangleButton(
///     config: .blankLeft(
///         image: Image.Icon.Symbol.closeM,
///         imageSize: CGSize(width: 24, height: 24),
///         colorStyle: .white
///     ),
///     action: { }
/// )
/// ```
public struct TXRectangleButton: View {
    public struct Configuration {
        let text: String?
        let font: TypographyToken?
        let image: Image?
        let imageSize: CGSize?
        let frameSize: CGSize
        let colorStyle: ColorStyle
        let borderWidth: CGFloat = LineWidth.m
        let edges: [Edge]

        public init(
            frameSize: CGSize,
            colorStyle: ColorStyle,
            edges: [Edge],
            text: String? = nil,
            font: TypographyToken? = nil,
            image: Image? = nil,
            imageSize: CGSize? = nil
        ) {
            self.frameSize = frameSize
            self.colorStyle = colorStyle
            self.edges = edges
            self.text = text
            self.font = font
            self.image = image
            self.imageSize = imageSize
        }
    }

    private let config: Configuration
    private let action: () -> Void

    public init(
        config: Configuration,
        action: @escaping () -> Void
    ) {
        self.config = config
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            if let text = config.text,
               let font = config.font {
                textLabel(text: text, font: font)
            } else if let image = config.image,
                      let imageSize = config.imageSize {
                iconLabel(image: image, imageSize: imageSize)
            } else {
                EmptyView()
            }
        }
    }
}

private extension TXRectangleButton {
    func baseLabel(@ViewBuilder content: () -> some View) -> some View {
        content()
            .foregroundStyle(config.colorStyle.foregroundColor)
            .frame(width: config.frameSize.width, height: config.frameSize.height)
            .background(config.colorStyle.backgroundColor)
            .insideRectEdgeBorder(
                width: config.borderWidth,
                edges: config.edges,
                color: config.colorStyle.borderColor
            )
    }
    
    func textLabel(text: String, font: TypographyToken) -> some View {
        baseLabel {
            Text(text)
                .typography(font)
        }
    }

    func iconLabel(image: Image, imageSize: CGSize) -> some View {
        baseLabel {
            image
                .resizable()
                .renderingMode(.template)
                .frame(width: imageSize.width, height: imageSize.height)
        }
    }
}

#Preview {
    HStack(spacing: 20) {
        TXRectangleButton(
            config: .blankRightClose(),
            action: { }
        )

        TXRectangleButton(
            config: .blankRightSave(text: "저장", colorStyle: .white),
            action: { }
        )

        TXRectangleButton(
            config: .blankLeftBack(
                image: Image.Icon.Symbol.arrow3Left,
                imageSize: CGSize(width: 24, height: 24),
                colorStyle: .white
            ),
            action: { }
        )
    }
}
