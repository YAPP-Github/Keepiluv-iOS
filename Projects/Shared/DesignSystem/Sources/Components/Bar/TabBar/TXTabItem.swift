//
//  TXTabItem.swift
//  SharedDesignSystem
//
//  Created by 정지용 on 1/22/26.
//

import SwiftUI

/// TabBar의 탭 아이템을 정의합니다.
public enum TXTabItem: Int, CaseIterable, Equatable {
    case home
    case statistics
    case couple

    /// 현재 화면에 표시할 탭 목록 (임시: 홈만 활성화)
    public static var visibleCases: [TXTabItem] {
        [.home]
    }
}

extension TXTabItem {
    public var title: String {
        switch self {
        case .home:
            return "홈"

        case .statistics:
            return "통계"

        case .couple:
            return "커플페이지"
        }
    }

    var selectedIcon: Image {
        switch self {
        case .home:
            return Image.Icon.Symbol.selectedSelected

        case .statistics:
            return Image.Icon.Symbol.selectedSelected1

        case .couple:
            return Image.Icon.Symbol.selectedSelected2
        }
    }

    var unselectedIcon: Image {
        switch self {
        case .home:
            return Image.Icon.Symbol.selectedNone

        case .statistics:
            return Image.Icon.Symbol.selectedNone1

        case .couple:
            return Image.Icon.Symbol.selectedNone2
        }
    }

    func icon(isSelected: Bool) -> Image {
        isSelected ? selectedIcon : unselectedIcon
    }
}
