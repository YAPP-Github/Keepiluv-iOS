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
        case subTitle(title: String, rightText: String?)
        case noTitle
        
        /// 홈 스타일에서 사용하는 설정 값입니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let homeStyle = TXNavigationBar.Style.Home(
        ///     subTitle: "1월 2026",
        ///     mainTitle: "오늘 우리 목표",
        ///     isHiddenRefresh: false,
        ///     isRemainedAlarm: true
        /// )
        /// ```
        public struct Home {
            public var subTitle: String
            let mainTitle: String
            public var isHiddenRefresh: Bool
            public var isRemainedAlarm: Bool
            
            /// 홈 스타일 설정 값을 생성합니다.
            ///
            /// ## 사용 예시
            /// ```swift
            /// let homeStyle = TXNavigationBar.Style.Home(
            ///     subTitle: "1월 2026",
            ///     mainTitle: "오늘 우리 목표",
            ///     isHiddenRefresh: false,
            ///     isRemainedAlarm: true
            /// )
            /// ```
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
}

// MARK: - Style Properties
extension TXNavigationBar.Style {
    var backgroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle:
            return Color.Common.white

        case .noTitle:
            return Color.Gray.gray500
        }
    }

    var foregroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle:
            return Color.Gray.gray500

        case .noTitle:
            return Color.Common.white
        }
    }

    var subTitleForegroundColor: Color {
        return Color.Gray.gray400
    }

    var iconForegroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle:
            return Color.Gray.gray400

        case .noTitle:
            return Color.Common.white
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

        case .noTitle:
            return 72
        }
    }

    var titleFont: TypographyToken {
        switch self {
        case .mainTitle, .home:
            return .h3_22b

        case .subTitle:
            return .h4_20b

        case .noTitle:
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

        case .noTitle:
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
        case .mainTitle, .home, .noTitle:
            return CGSize(width: 44, height: 44)

        case .subTitle:
            return CGSize(width: 60, height: 60)
        }
    }

    var iconSize: CGSize {
        return CGSize(width: 24, height: 24)
    }
}
