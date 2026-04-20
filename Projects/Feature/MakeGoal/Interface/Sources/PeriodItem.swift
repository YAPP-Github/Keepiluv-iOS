//
//  PeriodItem.swift
//  FeatureMakeGoalInterface
//
//  Created by 정지훈 on 4/20/26.
//

import SharedDesignSystem

/// 목표 생성/수정 화면에서 사용하는 반복 주기 탭 아이템입니다.
public enum PeriodItem: TXItem {
    case daily
    case weekly
    case monthly

    public var title: String {
        switch self {
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        }
    }
}
