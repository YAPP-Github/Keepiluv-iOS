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
///     config: .plus(colorStyle: .black),
///     action: { }
/// )
/// ```
public struct TXCircleButton: View {
    public struct Configuration {
        let image: Image
        let frameSize: CGSize
        let imageSize: CGSize
        let colorStyle: ColorStyle

        public init(
            image: Image,
            frameSize: CGSize,
            imageSize: CGSize,
            colorStyle: ColorStyle
        ) {
            self.image = image
            self.frameSize = frameSize
            self.imageSize = imageSize
            self.colorStyle = colorStyle
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
            config.image
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(config.colorStyle.foregroundColor)
                .frame(width: config.imageSize.width, height: config.imageSize.height)
                .frame(width: config.frameSize.width, height: config.frameSize.height)
                .background(config.colorStyle.backgroundColor, in: .circle)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    TXCircleButton(
        config: .plus(colorStyle: .black),
        action: { }
    )
}
