//
//  MainTabAnalyticsEvent.swift
//  FeatureMainTab
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import CorePushInterface
import Foundation

enum MainTabAnalyticsEvent: AnalyticsEvent {
    case openedByPush(deepLink: NotificationDeepLink)

    var name: String {
        switch self {
        case .openedByPush:
            "open_by_push"
        }
    }
    
    var parameters: [String: Any]? {
        let type: String
        switch self {
        case let .openedByPush(deepLink):
            switch deepLink {
            case .poke: type = "poke"
            case .partnerConnected: type = "partner_connected"
            case .goalCompleted: type = "goal_completed"
            case .reaction: type = "reaction"
            case .dailyGoalAchieved: type = "daily_goal_achieved"
            case .goalEnded: type = "goal_ended"
            case .marketing: type = "marketing"
            }
        }
        
        return ["type": type]
    }
}
