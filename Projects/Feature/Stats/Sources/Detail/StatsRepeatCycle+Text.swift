//
//  StatsRepeatCycle+Text.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/20/26.
//

import DomainStatsInterface

extension Stats.RepeatCycle {
    var text: String {
        switch self {
        case .daily: "매일"
        case .weekly: "매주"
        case .monthly: "매월"
        }
    }
}
