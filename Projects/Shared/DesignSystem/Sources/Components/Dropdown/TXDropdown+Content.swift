//
//  TXDropdown+Content.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 1/18/26.
//

import Foundation

extension TXDropdown.Style {
    /// 드롭다운에서 제공하는 콘텐츠 정의입니다.
    public enum Content {
        case goal
        case custom(items: [Item])

        var items: [Item] {
            switch self {
            case .goal:
                return [.edit, .done, .delete]
            case let .custom(items):
                return items
            }
        }
    }

    /// 드롭다운에서 표시되는 개별 항목입니다.
    public enum Item: CaseIterable {
        case edit
        case done
        case delete

        var title: String {
            switch self {
            case .edit:
                return "수정하기"
            case .done:
                return "끝내기"
            case .delete:
                return "삭제하기"
            }
        }
    }
}
