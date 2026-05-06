//
//  AnalyticsClient+Live.swift
//  CoreAnalytics
//
//  Created by 정지훈 on 5/3/26.
//

import ComposableArchitecture
import CoreAnalyticsInterface
import FirebaseAnalytics
import Foundation

// Firebase Analytics SDK를 TCA Dependency liveValue로 연결합니다.
extension AnalyticsClient: @retroactive DependencyKey {
    public static let liveValue = AnalyticsClient(
        setUserProfile: { profile in
            Analytics.setUserID(profile.id.map(String.init))
            Analytics.setUserProperty(profile.name, forName: "name")
        },
        logEvent: { event in
            Analytics.logEvent(
                event.name,
                parameters: nil
            )
        },
        logEventParameter: { event, parameters in
            Analytics.logEvent(
                event.name,
                parameters: parameters
            )
        }
    )
}
