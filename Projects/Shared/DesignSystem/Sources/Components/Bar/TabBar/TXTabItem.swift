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
    // FIXME: 삭제 예정 - 설정 화면 진입점 확정 후 제거
    case settings

    /// 현재 화면에 표시할 탭 목록
    public static var visibleCases: [TXTabItem] {
        // FIXME: 삭제 예정 - settings 탭은 임시로 추가됨
        [.home, .settings]
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

        case .settings:
            return "설정"
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

        case .settings:
            // FIXME: 삭제 예정 - 임시 아이콘 사용
            return Image.Icon.Symbol.setting
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

        case .settings:
            // FIXME: 삭제 예정 - 임시 아이콘 사용
            return Image.Icon.Symbol.setting
        }
    }

    func icon(isSelected: Bool) -> Image {
        isSelected ? selectedIcon : unselectedIcon
    }
}
