//
//  TopTabBar+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

extension TopTabBar {
    public enum Style {
        case plain(content: Content)
    }
}

extension TopTabBar.Style {
    var items: [TopTabBar.Style.Item] {
        switch self {
        case let .plain(content):
            return content.items
        }
    }

    var font: TypographyToken {
        switch self {
        case .plain:
            return .t2_16b
        }
    }

    var selectedColor: Color {
        switch self {
        case .plain:
            return Color.Gray.gray500
        }
    }

    var unselectedColor: Color {
        switch self {
        case .plain:
            return Color.Gray.gray200
        }
    }

    var height: CGFloat {
        switch self {
        case .plain:
            return 36
        }
    }

    var bottomPadding: CGFloat {
        switch self {
        case .plain:
            return Spacing.spacing6
        }
    }

    var underlineHeight: CGFloat {
        switch self {
        case .plain:
            return LineWidth.l
        }
    }

    var underlineBottomPadding: CGFloat {
        switch self {
        case .plain:
            return Spacing.spacing2
        }
    }
}
