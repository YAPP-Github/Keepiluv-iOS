//
//  TXRoundedRectangleGroupButton+Style.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import Foundation

extension TXRoundedRectangleGroupButton {
    /// 모달 액션 그룹의 스타일을 정의합니다.
    public enum Style {
        case plain(Content)
    }
}

extension TXRoundedRectangleGroupButton.Style {
    var items: [Item] {
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

    func action(
        for item: Item,
        actionLeft: @escaping () -> Void,
        actionRight: @escaping () -> Void
    ) -> () -> Void {
        switch self {
        case .plain:
            switch item {
            case .cancel:
                return actionLeft
            case .delete:
                return actionRight
            }
        }
    }
}
