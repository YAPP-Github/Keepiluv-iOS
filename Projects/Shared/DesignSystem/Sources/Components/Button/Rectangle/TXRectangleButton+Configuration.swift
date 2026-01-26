//
//  TXRectangleButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXRectangleButton.Configuration {
    static func blankRightClose(
        text: String? = nil,
        image: Image? = Image.Icon.Symbol.closeM,
        imageSize: CGSize? = CGSize(width: 24, height: 24),
        colorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            frameSize: CGSize(width: 60, height: 60),
            colorStyle: colorStyle,
            edges: [.top, .bottom, .leading],
            text: text,
            font: text != nil ? .t2_16b : nil,
            image: image,
            imageSize: imageSize
        )
    }
    
    static func blankRightSave(
        text: String? = "저장",
        image: Image? = nil,
        imageSize: CGSize? = nil,
        colorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            frameSize: CGSize(width: 60, height: 60),
            colorStyle: colorStyle,
            edges: [.top, .bottom, .leading],
            text: text,
            font: text != nil ? .t2_16b : nil,
            image: image,
            imageSize: imageSize,
        )
    }

    static func blankLeftBack(
        text: String? = nil,
        image: Image? = Image.Icon.Symbol.arrow3Left,
        imageSize: CGSize = CGSize(width: 24, height: 24),
        colorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            frameSize: CGSize(width: 60, height: 60),
            colorStyle: colorStyle,
            edges: [.top, .bottom, .trailing],
            text: text,
            font: text != nil ? .t2_16b : nil,
            image: image,
            imageSize: imageSize
        )
    }
}
