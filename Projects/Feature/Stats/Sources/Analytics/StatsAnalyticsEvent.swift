//
//  StatsAnalyticsEvent.swift
//  FeatureStats
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum StatsAnalyticsEvent: AnalyticsEvent {
    case viewed

    var name: String {
        switch self {
        case .viewed:
            "stats_viewed"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .viewed:
            nil
        }
    }
}
