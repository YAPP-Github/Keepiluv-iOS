//
//  HomeAnalyticsEvent.swift
//  FeatureHome
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum HomeAnalyticsEvent: AnalyticsEvent {
    case recommendGoalClicked(kind: String)

    var name: String {
        switch self {
        case .recommendGoalClicked:
            "recommend_goal_clicked"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .recommendGoalClicked(kind):
            [
                "kind": kind
            ]
        }
    }
}
