//
//  GoalDropList.swift
//  FeatureCommonInterface
//
//  Created by 정지훈 on 4/20/26.
//

import SharedDesignSystem

/// 목표 편집/상세 화면에서 사용하는 드롭다운 액션 타입입니다.
public enum GoalDropList: TXItem {
    case edit
    case finish
    case delete

    public var title: String {
        switch self {
        case .edit: return "수정하기"
        case .finish: return "끝내기"
        case .delete: return "삭제하기"
        }
    }
}
