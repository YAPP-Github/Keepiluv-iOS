//
//  GoalDetailAnalyticsEvent.swift
//  FeatureGoalDetail
//
//  Created by Codex on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum GoalDetailAnalyticsEvent: AnalyticsEvent {
    case emojiReactionSent(emoji: String)
    case pokeSent

    var name: String {
        switch self {
        case .emojiReactionSent:
            "emoji_reaction_sent"
        case .pokeSent:
            "poke_sent"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .emojiReactionSent(emoji):
            [
                "emoji": emoji
            ]
        case .pokeSent:
            nil
        }
    }
}
