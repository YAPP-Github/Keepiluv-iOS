//
//  TXNavigationBar+Style.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/21/26.
//

import SwiftUI

extension TXNavigationBar {
    /// NavigationBar의 스타일을 정의합니다.
    public enum Style {
        case mainTitle(title: String)
        case home(Home)
        case subTitle(title: String)
        case iconOnly(IconStyle)

        public struct Home {
            public var subTitle: String
            let mainTitle: String
            public var isHiddenRefresh: Bool
            public var isRemainedAlarm: Bool

            public init(
                subTitle: String,
                mainTitle: String,
                isHiddenRefresh: Bool,
                isRemainedAlarm: Bool
            ) {
                self.subTitle = subTitle
                self.mainTitle = mainTitle
                self.isHiddenRefresh = isHiddenRefresh
                self.isRemainedAlarm = isRemainedAlarm
            }
        }
    }

    /// iconOnly 스타일에서 사용할 아이콘 타입입니다.
    public enum IconStyle {
        case back
        case close
    }
}

// MARK: - Style Properties
extension TXNavigationBar.Style {
    var backgroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle, .iconOnly:
            return Color.Common.white
        }
    }

    var foregroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle, .iconOnly:
            return Color.Gray.gray500
        }
    }

    var subTitleForegroundColor: Color {
        return Color.Gray.gray400
    }

    var iconForegroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle, .iconOnly:
            return Color.Gray.gray400
        }
    }

    var height: CGFloat {
        switch self {
        case .mainTitle:
            return 80

        case .home:
            return 80

        case .subTitle:
            return 80

        case .iconOnly:
            return 72
        }
    }

    var titleFont: TypographyToken {
        switch self {
        case .mainTitle, .home:
            return .h3_22b

        case .subTitle, .iconOnly:
            return .h4_20b
        }
    }

    var subTitleFont: TypographyToken {
        return .t3_14eb
    }

    var horizontalPadding: EdgeInsets {
        switch self {
        case .mainTitle, .home:
            return EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10)

        case .subTitle:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        case .iconOnly:
            return EdgeInsets(top: 14, leading: 10, bottom: 14, trailing: 10)
        }
    }

    var borderWidth: CGFloat {
        return LineWidth.m
    }

    var borderColor: Color {
        return Color.Gray.gray500
    }

    var actionButtonSize: CGSize {
        switch self {
        case .mainTitle, .home, .iconOnly:
            return CGSize(width: 44, height: 44)

        case .subTitle:
            return CGSize(width: 60, height: 60)
        }
    }

    var iconSize: CGSize {
        return CGSize(width: 24, height: 24)
    }
}
