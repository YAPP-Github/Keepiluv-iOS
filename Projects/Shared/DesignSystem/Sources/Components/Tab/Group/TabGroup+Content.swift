//
//  TapGroup+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import Foundation

extension TabGroup {
    public enum Content {
        case period
    }
}

extension TabGroup.Content {
    var items: [TXRoundedRectangleButton.Style.SmallContent] {
        return [.daily, .weekly, .monthly]
    }
}
