//
//  TXShapeButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 디자인 시스템에서 사용하는 Shape 기반 버튼 컴포넌트입니다.
public struct TXShapeButton: View {
    private let buttonType: TXShapeButtonType
    private let action: () -> Void

    /// 버튼 타입을 지정해 버튼을 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// TXShapeButton(
    ///     buttonType: .circle(
    ///         config: .init(
    ///             frameSize: CGSize(width: 56, height: 56),
    ///             image: Image(systemName: "plus"),
    ///             imageSize: CGSize(width: 44, height: 44),
    ///             backgroundColor: Color.Gray.gray500,
    ///             foregroundColor: Color.Common.white
    ///         )
    ///     ),
    ///     action: { }
    /// )
    /// ```
    public init(
        type buttonType: TXShapeButtonType,
        action: @escaping () -> Void
    ) {
        self.buttonType = buttonType
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            if let text,
               let font = buttonType.font {
                textLabel(text: text, font: font)
            } else if let image {
                imageLabel(image: image)
            } else {
                EmptyView()
            }
        }
    }
}

private extension TXShapeButton {
    var text: String? { buttonType.text }
    var image: Image? { buttonType.image }
    var backgroundColor: Color { buttonType.backgroundColor }
    var foregroundColor: Color { buttonType.foregroundColor }

    func textLabel(text: String, font: TypographyToken) -> some View {
        let cornerRadius = buttonType.radius()
        let shape = RoundedRectangle(cornerRadius: cornerRadius)
        let baseView = Text(text)
            .typography(font)
            .foregroundStyle(foregroundColor)
            .frame(height: buttonType.height())
            .frame(maxWidth: buttonType.width())
            .background(backgroundColor)
            .clipShape(shape)

        return borderedLabel(shape: shape, content: baseView)
    }

    func imageLabel(image: Image) -> some View {
        let cornerRadius = buttonType.radius()
        let shape = RoundedRectangle(cornerRadius: cornerRadius)
        let baseView = image
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(foregroundColor)
            .frame(width: buttonType.imageSize?.width, height: buttonType.imageSize?.height)
            .frame(width: buttonType.width(), height: buttonType.height())
            .background(backgroundColor)
            .clipShape(shape)

        return borderedLabel(shape: shape, content: baseView)
    }

    @ViewBuilder
    func borderedLabel(
        shape: RoundedRectangle,
        content: some View
    ) -> some View {
        if let edges = buttonType.borderEdges {
            content
                .insideRectEdgeBorder(
                    width: buttonType.borderWidth,
                    edges: edges,
                    color: buttonType.borderColor
                )
        } else {
            content
                .insideBorder(
                    buttonType.borderColor,
                    shape: shape,
                    lineWidth: buttonType.borderWidth
                )
        }
    }
}

// swiftlint: disable closure_body_length
#Preview {
    VStack(spacing: 10) {
        HStack {
            TXShapeButton(
                type: .smallRoundedRectangle(
                    config: .init(
                        text: "보러가기",
                        backgroundColor: Color.Common.white,
                        foregroundColor: Color.Gray.gray500
                    )
                ),
                action: { }
            )

            TXShapeButton(
                type: .smallRoundedRectangle(
                    config: .init(
                        text: "보러가기",
                        backgroundColor: Color.Gray.gray500,
                        foregroundColor: Color.Common.white
                    )
                ),
                action: { }
            )
        }

        HStack {
            TXShapeButton(
                type: .mediumRoundedRectangle(
                    config: .init(
                        text: "취소",
                        backgroundColor: Color.Common.white,
                        foregroundColor: Color.Gray.gray500
                    )
                ),
                action: { }
            )

            TXShapeButton(
                type: .mediumRoundedRectangle(
                    config: .init(
                        text: "취소",
                        backgroundColor: Color.Gray.gray500,
                        foregroundColor: Color.Common.white
                    )
                ),
                action: { }
            )
        }
        TXShapeButton(
            type: .longRoundedRectangle(
                config: .init(
                    text: "확인",
                    backgroundColor: Color.Gray.gray500,
                    foregroundColor: Color.Common.white
                )
            ),
            action: { }
        )
        .padding(.horizontal, 20)

        HStack(spacing: 20) {
            TXShapeButton(
                type: .rectangle(
                    config: .init(
                        edges: [.top, .bottom, .leading],
                        frameSize: CGSize(width: 60, height: 60),
                        backgroundColor: Color.Common.white,
                        foregroundColor: Color.Gray.gray500,
                        content: .icon(
                            image: Image.Icon.Symbol.closeM,
                            imageSize: CGSize(width: 24, height: 24)
                        )
                    )
                ),
                action: { }
            )

            TXShapeButton(
                type: .rectangle(
                    config: .init(
                        edges: [.top, .bottom, .leading],
                        frameSize: CGSize(width: 60, height: 60),
                        backgroundColor: Color.Common.white,
                        foregroundColor: Color.Gray.gray500,
                        content: .text("저장")
                    )
                ),
                action: { }
            )

            TXShapeButton(
                type: .rectangle(
                    config: .init(
                        edges: [.top, .bottom, .trailing],
                        frameSize: CGSize(width: 60, height: 60),
                        backgroundColor: Color.Common.white,
                        foregroundColor: Color.Gray.gray500,
                        content: .icon(
                            image: Image.Icon.Symbol.arrow3Left,
                            imageSize: CGSize(width: 24, height: 24)
                        )
                    )
                ),
                action: { }
            )
        }

        HStack {
            TXShapeButton(
                type: .circle(
                    config: .init(
                        frameSize: CGSize(width: 56, height: 56),
                        image: Image.Icon.Symbol.plus,
                        imageSize: CGSize(width: 44, height: 44),
                        backgroundColor: Color.Gray.gray500,
                        foregroundColor: Color.Common.white
                    )
                ),
                action: { }
            )
        }
    }
}
// swiftlint: enable closure_body_length
