//
//  TXTopAppBar+Style.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/21/26.
//

import SwiftUI

extension TXTopAppBar {
    /// TopAppBar의 스타일을 정의합니다.
    public enum Style {
        /// 메인 타이틀 스타일 (좌측 타이틀만 표시)
        case mainTitle(title: String)

        /// 홈 화면 스타일 (서브타이틀, 메인타이틀, 우측 아이콘)
        case home(
            subTitle: String,
            mainTitle: String
        )

        /// 서브 타이틀 스타일 (뒤로가기, 중앙 타이틀, 닫기 버튼)
        case subTitle(title: String)

        /// 타이틀 없음 스타일 (닫기 버튼만)
        case noTitle
    }
}

// MARK: - Style Properties
extension TXTopAppBar.Style {
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
