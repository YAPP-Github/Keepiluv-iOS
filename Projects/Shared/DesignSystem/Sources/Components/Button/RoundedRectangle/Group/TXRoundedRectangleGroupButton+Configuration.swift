//
//  TXRoundedRectangleGroupButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXRoundedRectangleGroupButton.Configuration {
    static func modal(
        leftText: String = "취소",
        rightText: String = "삭제",
        leftColorStyle: ColorStyle = .white,
        rightColorStyle: ColorStyle = .black
    ) -> Self {
        .init(
            leftText: leftText,
            rightText: rightText,
            leftColorStyle: leftColorStyle,
            rightColorStyle: rightColorStyle
        )
    }
}
