//
//  PeriodItem.swift
//  FeatureMakeGoalInterface
//
//  Created by 정지훈 on 4/20/26.
//

import DomainCommonInterface
import FeatureCommonInterface
import SharedDesignSystem

/// 목표 생성/수정 화면에서 사용하는 반복 주기 탭 아이템입니다.
public enum PeriodItem: TXItem {
    case daily
    case weekly
    case monthly

    public var title: String {
        repeatCycle.text
    }

    public var repeatCycle: RepeatCycle {
        switch self {
        case .daily: return .daily
        case .weekly: return .weekly
        case .monthly: return .monthly
        }
    }

    public init(repeatCycle: RepeatCycle) {
        switch repeatCycle {
        case .daily: self = .daily
        case .weekly: self = .weekly
        case .monthly: self = .monthly
        }
    }
}
