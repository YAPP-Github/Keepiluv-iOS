//
//  TXDropdownAction.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/5/26.
//

import Foundation

/// TXDropdown에서 선택 가능한 기본 항목 타입입니다.
///
/// ## 사용 예시
/// ```swift
/// let action: TXDropdownItem = .edit
/// print(action.title)
/// ```
public enum TXDropdownItem: CaseIterable, Equatable, Hashable {
    case edit
    case finish
    case delete
}

public extension TXDropdownItem {
    var title: String {
        switch self {
        case .edit:
            return "수정하기"
        case .finish:
            return "끝내기"
        case .delete:
            return "삭제하기"
        }
    }
}
