//
//  AppCrashlyticsEvent.swift
//  Twix
//

import CoreCrashlyticsInterface
import Foundation

enum AppCrashlyticsLogEvent: CrashlyticsLogEvent {
    case sessionExpiredAtOnboardingStatusCheck

    var message: String {
        switch self {
        case .sessionExpiredAtOnboardingStatusCheck:
            "session expired at onboarding status check"
        }
    }
}

enum AppCrashlyticsRecordEvent: CrashlyticsRecordEvent {
    case appStartupFailed
    case onboardingStatusCheckFailed

    var customKeys: [String: String] {
        switch self {
        case .appStartupFailed:
            [CrashlyticsKey.screen: "app_startup"]

        case .onboardingStatusCheckFailed:
            [CrashlyticsKey.screen: "startup_onboarding_check"]
        }
    }
}
