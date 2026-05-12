//
//  OnboardingAnalyticsEvent.swift
//  FeatureOnboarding
//
//  Created by Jihun on 5/9/26.
//

import CoreAnalyticsInterface
import Foundation

enum OnboardingAnalyticsEvent: Hashable, AnalyticsEvent {
    case inviteViewed
    case profileSetupViewed
    case anniversarySetupViewed
    case onboardingCompleted

    var name: String {
        switch self {
        case .inviteViewed:
            "invite_viewed"
        case .profileSetupViewed:
            "profile_setup_viewed"
        case .anniversarySetupViewed:
            "anniversary_setup_viewed"
        case .onboardingCompleted:
            "onboarding_completed"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .inviteViewed, .profileSetupViewed, .anniversarySetupViewed, .onboardingCompleted:
            nil
        }
    }
}
