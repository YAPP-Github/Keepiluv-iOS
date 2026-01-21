//
//  TXToggleButton+Configuration.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/20/26.
//

import SwiftUI

public extension TXToggleButton.Configuration {
    static func goalCheck(
        items: [TXToggleButton.Item] = [.myCheck, .coupleCheck],
        spacing: CGFloat = -11,
        myCheckImage: Image = .Icon.Symbol.unCheckMe,
        myCheckSelectedImage: Image = .Icon.Symbol.checkMe,
        coupleCheckImage: Image = .Icon.Symbol.unCheckYou,
        coupleCheckSelectedImage: Image = .Icon.Symbol.checkYou,
    ) -> Self {
        .init(
            items: items,
            spacing: spacing,
            leftImage: myCheckImage,
            leftSelectedImage: myCheckSelectedImage,
            rightImage: coupleCheckImage,
            rightSelectedImage: coupleCheckSelectedImage
        )
    }
}
