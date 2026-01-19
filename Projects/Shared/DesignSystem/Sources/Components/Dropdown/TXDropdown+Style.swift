//
//  TXDropdown+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import SwiftUI

extension TXDropdown {
    /// 드롭다운의 레이아웃과 컬러 조합을 정의합니다.
    public enum Style {
        case config(Content)
    }
}

extension TXDropdown.Style {
    var items: [TXDropdown.Item] {
        switch self {
        case let .config(content):
            return content.items
        }
    }

    var width: CGFloat {
        switch self {
        case .config:
            return 88
        }
    }

    var itemHeight: CGFloat {
        switch self {
        case .config:
            return 44
        }
    }

    var radius: CGFloat {
        switch self {
        case .config:
            return Radius.xs
        }
    }

    var font: TypographyToken {
        switch self {
        case .config:
            return .b2_14r
        }
    }

    var leadingPadding: CGFloat {
        switch self {
        case .config:
            return Spacing.spacing7
        }
    }

    var borderWidth: CGFloat {
        switch self {
        case .config:
            return LineWidth.m
        }
    }

    var separatorHeight: CGFloat {
        switch self {
        case .config:
            return LineWidth.m
        }
    }

    var foregroundColor: Color {
        Color.Gray.gray500
    }

    var borderColor: Color {
        Color.Gray.gray500
    }

    var separatorColor: Color {
        Color.Gray.gray500
    }

    var shadowColor: Color {
        Color.black.opacity(0.16)
    }

    var shadowRadius: CGFloat {
        20
    }

    var shadowX: CGFloat {
        2
    }

    var shadowY: CGFloat {
        1
    }
}
