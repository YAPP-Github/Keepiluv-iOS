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
        selectedState: TXButtonShape.TXRectState = .standard,
        unselectedState: TXButtonShape.TXRectState = .line
    ) -> Self {
        .init(
            items: items,
            selectedState: selectedState,
            unselectedState: unselectedState
        )
    }
}
