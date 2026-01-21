//
//  TXRectangleButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXRectangleButton.Configuration {
    static func blankLeftClose(
        text: String? = nil,
        image: Image? = Image.Icon.Symbol.closeM,
        imageSize: CGSize? = CGSize(width: 24, height: 24),
        colorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            text: text,
            font: text != nil ? .t2_16b : nil,
            image: image,
            imageSize: imageSize,
            frameSize: CGSize(width: 60, height: 60),
            colorStyle: colorStyle,
            borderWidth: LineWidth.m,
            edges: [.top, .bottom, .trailing]
        )
    }
    
    static func blankLeftSave(
        text: String? = "저장",
        image: Image? = nil,
        imageSize: CGSize? = nil,
        colorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            text: text,
            font: text != nil ? .t2_16b : nil,
            image: image,
            imageSize: imageSize,
            frameSize: CGSize(width: 60, height: 60),
            colorStyle: colorStyle,
            borderWidth: LineWidth.m,
            edges: [.top, .bottom, .trailing]
        )
    }

    static func blankRightBack(
        text: String? = nil,
        image: Image? = Image.Icon.Symbol.arrow3Left,
        imageSize: CGSize = CGSize(width: 24, height: 24),
        colorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            text: text,
            font: text != nil ? .t2_16b : nil,
            image: image,
            imageSize: imageSize,
            frameSize: CGSize(width: 60, height: 60),
            colorStyle: colorStyle,
            borderWidth: LineWidth.m,
            edges: [.top, .bottom, .leading]
        )
    }
}
