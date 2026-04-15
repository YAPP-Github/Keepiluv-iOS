//
//  TXDropdownAction.swift
//  SharedDesignSystem
//
//  Created by 정지훈 on 2/5/26.
//

import Foundation

/// 목표 드롭다운에서 선택 가능한 기본 항목 타입입니다.
///
/// ## 사용 예시
/// ```swift
/// let action: GoalDropList = .edit
/// print(action.title)
/// ```

// TODO: - Feature 계층으로 분리 예정
public enum GoalDropList: TXItem {
    case edit
    case finish
    case delete
}

public enum PeriodItem: TXItem {
    case daily
    case weekly
    case monthly
}

public enum StatsTopTabItem: TXItem {
    case ongoing
    case completed
}

public extension GoalDropList {
    var title: String {
        switch self {
        case .edit: return "수정하기"
        case .finish: return "끝내기"
        case .delete: return "삭제하기"
        }
    }
}

public extension PeriodItem {
    var title: String {
        switch self {
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        }
    }
}

public extension StatsTopTabItem {
    var title: String {
        switch self {
        case .ongoing: return "진행중"
        case .completed: return "종료"
        }
    }
}
