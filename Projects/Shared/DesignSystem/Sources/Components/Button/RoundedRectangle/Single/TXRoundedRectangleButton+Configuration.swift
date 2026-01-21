//
//  TXRoundedRectangleButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXRoundedRectangleButton.Configuration {
    static func small(
        text: String,
        colorStyle: ColorStyle
    ) -> Self {
        .init(
            text: text,
            font: .b1_14b,
            colorStyle: colorStyle,
            fixedFrame: false,
            radius: Radius.xs,
            borderWidth: LineWidth.m,
            horizontalPadding: Spacing.spacing6,
            verticalPadding: 5.5
        )
    }

    static func medium(
        text: String,
        colorStyle: ColorStyle
    ) -> Self {
        .init(
            text: text,
            font: .t2_16b,
            colorStyle: colorStyle,
            fixedFrame: true,
            radius: Radius.s,
            borderWidth: LineWidth.m,
            width: 151,
            height: 52
        )
    }

    static func long(
        text: String,
        colorStyle: ColorStyle
    ) -> Self {
        .init(
            text: text,
            font: .t2_16b,
            colorStyle: colorStyle,
            fixedFrame: true,
            radius: Radius.s,
            borderWidth: LineWidth.m,
            width: .infinity,
            height: 52
        )
    }
}
