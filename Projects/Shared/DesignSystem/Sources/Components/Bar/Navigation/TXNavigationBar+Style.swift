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
        case subContent(SubContent)
        case home(Home)
        case subTitle(title: String, type: SubTitleType)
        case iconOnly(IconStyle)
        case noTitle

        /// 좌측 뒤로가기 + 중앙 타이틀 + 우측 액션 영역을 사용하는 스타일 설정입니다.
        public struct SubContent {
            /// `subContent` 스타일 우측 액션의 표현 타입입니다.
            public enum RightContent {
                case text(String)
                case image(Image)
                case rotatedImage(Image, angle: Angle)
            }

            public let title: String
            public let rightContent: RightContent?
            public let backgroundColor: Color

            /// `subContent` 스타일 설정을 생성합니다.
            ///
            /// - Parameters:
            ///   - title: 중앙에 표시할 타이틀
            ///   - rightContent: 우측 액션 콘텐츠
            public init(
                title: String,
                rightContent: RightContent? = nil,
                backgroundColor: Color = Color.Common.white
            ) {
                self.title = title
                self.rightContent = rightContent
                self.backgroundColor = backgroundColor
            }
        }

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

    /// iconOnly 스타일에서 사용할 아이콘 타입입니다.
    public enum IconStyle {
        case back
        case close
    }

    /// subTitle 스타일에서 사용할 타입입니다.
    public enum SubTitleType {
        /// 좌측 뒤로가기 버튼, 우측 빈 영역
        case back
        /// 좌측 빈 영역, 우측 닫기 버튼
        case close
    }
}

// MARK: - Style Properties
extension TXNavigationBar.Style {
    var backgroundColor: Color {
        switch self {
        case .mainTitle, .home, .subTitle, .iconOnly, .noTitle:
            return Color.Common.white
        case let .subContent(content):
            return content.backgroundColor
        }
    }

    var foregroundColor: Color {
        switch self {
        case .mainTitle, .subContent, .home, .subTitle, .iconOnly, .noTitle:
            return Color.Gray.gray500
        }
    }

    var subTitleForegroundColor: Color {
        return Color.Gray.gray400
    }

    var iconForegroundColor: Color {
        switch self {
        case .mainTitle, .subContent, .home, .subTitle, .iconOnly, .noTitle:
            return Color.Gray.gray400
        }
    }

    var height: CGFloat {
        switch self {
        case .mainTitle, .subContent, .home, .subTitle:
            return 80

        case .iconOnly, .noTitle:
            return 72
        }
    }

    var titleFont: TypographyToken {
        switch self {
        case .mainTitle, .home:
            return .h3_22b

        case .subContent, .subTitle, .iconOnly, .noTitle:
            return .h4_20b
        }
    }

    var subTitleFont: TypographyToken {
        return .t3_14eb
    }

    var horizontalPadding: EdgeInsets {
        switch self {
        case .mainTitle, .subContent, .home:
            return EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 10)

        case .subTitle:
            return EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        case .iconOnly, .noTitle:
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
        case .mainTitle, .home, .iconOnly, .noTitle:
            return CGSize(width: 44, height: 44)

        case .subContent, .subTitle:
            return CGSize(width: 60, height: 60)
        }
    }

    var iconSize: CGSize {
        return CGSize(width: 24, height: 24)
    }
}
