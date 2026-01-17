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
///     style: .blankLeft(content: .close, colorStyle: .white),
///     action: { }
/// )
/// ```
public struct TXRectangleButton: View {
    private let style: Style
    private let action: () -> Void

    public init(
        style: Style,
        action: @escaping () -> Void
    ) {
        self.style = style
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            if let text = style.text,
               let font = style.font {
                textLabel(text: text, font: font)
            } else if let image = style.image,
                      let imageSize = style.imageSize {
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
            .foregroundStyle(style.colorStyle.foregroundColor)
            .frame(width: style.frameSize.width, height: style.frameSize.height)
            .background(style.colorStyle.backgroundColor)
            .insideRectEdgeBorder(
                width: style.borderWidth,
                edges: style.edges,
                color: style.colorStyle.borderColor
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
            style: .blankLeft(content: .close, colorStyle: .white),
            action: { }
        )

        TXRectangleButton(
            style: .blankLeft(content: .save, colorStyle: .white),
            action: { }
        )

        TXRectangleButton(
            style: .blankRight(content: .back, colorStyle: .white),
            action: { }
        )
    }
}
