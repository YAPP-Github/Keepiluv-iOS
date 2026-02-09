//
//  GoalRepeatCycle+Text.swift
//  FeatureHome
//
//  Created by Jihun on 2/6/26.
//

import DomainGoalInterface

extension Goal.RepeatCycle {
    public var text: String {
        switch self {
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        }
    }
}
