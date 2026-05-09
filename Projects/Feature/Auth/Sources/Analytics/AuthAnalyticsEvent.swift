//
//  AuthAnalyticsEvent.swift
//  FeatureAuth
//
//  Created by Codex on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum AuthAnalyticsEvent: AnalyticsEvent {
    case loginViewed

    var name: String {
        switch self {
        case .loginViewed:
            "login_viewed"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .loginViewed:
            nil
        }
    }
}
