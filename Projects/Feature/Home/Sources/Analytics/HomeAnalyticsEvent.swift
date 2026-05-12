//
//  HomeAnalyticsEvent.swift
//  FeatureHome
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum HomeAnalyticsEvent: AnalyticsEvent {
    case selectGoalClicked(kind: String)

    var name: String {
        switch self {
        case .selectGoalClicked:
            "select_goal_clicked"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .selectGoalClicked(kind):
            [
                "kind": kind
            ]
        }
    }
}
