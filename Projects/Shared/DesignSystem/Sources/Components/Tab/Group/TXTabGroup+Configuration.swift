//
//  TXTabGroup+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXTabGroup.Configuration {
    static func period(
        items: [String] = ["매일", "매주", "매월"],
        selectedColorStyle: ColorStyle = .black,
        unselectedColorStyle: ColorStyle = .white
    ) -> Self {
        .init(
            items: items,
            selectedColorStyle: selectedColorStyle,
            unselectedColorStyle: unselectedColorStyle
        )
    }
}
