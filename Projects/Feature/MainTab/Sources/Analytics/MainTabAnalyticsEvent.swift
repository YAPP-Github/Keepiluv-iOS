//
//  MainTabAnalyticsEvent.swift
//  FeatureMainTab
//
//  Created by Codex on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum MainTabAnalyticsEvent: AnalyticsEvent {
    case openedByPush(type: String)

    var name: String {
        switch self {
        case .openedByPush:
            "open_by_push"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .openedByPush(type):
            [
                "type": type
            ]
        }
    }
}
