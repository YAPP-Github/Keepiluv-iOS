//
//  TapGroup+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

extension TabGroup {
    public enum Style {
        case plain(content: Content)
    }
}

extension TabGroup.Style {
    var items: [TXRoundedRectangleButton.Style.SmallContent] {
        switch self {
        case let .plain(content):
            return content.items
        }
    }

    var spacing: CGFloat {
        switch self {
        case .plain:
            return Spacing.spacing5
        }
    }

    var selectedColorStyle: ColorStyle {
        switch self {
        case .plain:
            return .black
        }
    }

    var unselectedColorStyle: ColorStyle {
        switch self {
        case .plain:
            return .white
        }
    }
}
