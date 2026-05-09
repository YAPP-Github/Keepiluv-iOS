//
//  MakeGoalAnalyticsEvent.swift
//  FeatureMakeGoal
//
//  Created by Codex on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum MakeGoalAnalyticsEvent: AnalyticsEvent {
    case created(goalId: Int64, kind: String)

    var name: String {
        switch self {
        case .created:
            "goal_created"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .created(goalId, kind):
            [
                "goal_id": "\(goalId)",
                "kind": kind
            ]
        }
    }
}
