//
//  TXCircleButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXCircleButton.Configuration {
    static func plus(
        frameSize: CGSize = CGSize(width: 56, height: 56),
        imageSize: CGSize = CGSize(width: 44, height: 44),
        colorStyle: ColorStyle = .black
    ) -> Self {
        .init(
            image: Image.Icon.Symbol.plus,
            frameSize: frameSize,
            imageSize: imageSize,
            colorStyle: colorStyle
        )
    }

    static func clear(
        frameSize: CGSize = CGSize(width: 18, height: 18),
        imageSize: CGSize = CGSize(width: 24, height: 24),
        colorStyle: ColorStyle = .black
    ) -> Self {
        .init(
            image: Image.Icon.Symbol.closeS,
            frameSize: frameSize,
            imageSize: imageSize,
            colorStyle: colorStyle
        )
    }

    static func rightArrow(
        frameSize: CGSize = CGSize(width: 28, height: 28),
        imageSize: CGSize = CGSize(width: 22, height: 22),
        colorStyle: ColorStyle = .black
    ) -> Self {
        .init(
            image: Image.Icon.Symbol.arrow3Right,
            frameSize: frameSize,
            imageSize: imageSize,
            colorStyle: colorStyle
        )
    }
    
    static func cameraChange(
        frameSize: CGSize = CGSize(width: 56, height: 56),
        imageSize: CGSize = CGSize(width: 24, height: 24),
        colorStyle: ColorStyle = .gray400
    ) -> Self {
        .init(
            image: Image.Icon.Symbol.turn,
            frameSize: frameSize,
            imageSize: imageSize,
            colorStyle: colorStyle
        )
    }
}
