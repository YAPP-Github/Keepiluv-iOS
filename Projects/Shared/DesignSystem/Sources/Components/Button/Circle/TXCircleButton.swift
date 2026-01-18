//
//  TXCircleButton.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/15/26.
//

import SwiftUI

/// 원형 아이콘 버튼 컴포넌트입니다.
///
/// ## 사용 예시
/// ```swift
/// TXCircleButton(
///     style: .medium(content: .plus, colorStyle: .black),
///     action: { }
/// )
/// ```
public struct TXCircleButton: View {
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
            style.image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(style.colorStyle.foregroundColor)
                .frame(width: style.imageSize.width, height: style.imageSize.height)
                .frame(width: style.frameSize.width, height: style.frameSize.height)
                .background(style.colorStyle.backgroundColor, in: .circle)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TXCircleButton(
        style: .medium(content: .plus, colorStyle: .black),
        action: { }
    )
}
