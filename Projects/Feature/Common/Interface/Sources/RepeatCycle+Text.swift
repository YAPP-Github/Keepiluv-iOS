//
//  RepeatCycle+Text.swift
//  FeatureCommonInterface
//
//  Created by 정지훈 on 4/20/26.
//

import DomainCommonInterface

public extension RepeatCycle {
    public var text: String {
        switch self {
        case .daily: "매일"
        case .weekly: "매주"
        case .monthly: "매월"
        }
    }
}
