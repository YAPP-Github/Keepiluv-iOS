//
//  OnboardingCrashlyticsEvent.swift
//  FeatureOnboarding
//

import CoreCrashlyticsInterface
import Foundation

enum OnboardingCrashlyticsRecordEvent: CrashlyticsRecordEvent {
    case inviteCodeFetchFailed

    var customKeys: [String: String] {
        switch self {
        case .inviteCodeFetchFailed:
            [CrashlyticsKey.screen: "onboarding_connect"]
        }
    }
}
