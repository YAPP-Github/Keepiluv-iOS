//
//  CrashlyticsClient+Live.swift
//  CoreCrashlytics
//

import ComposableArchitecture
import CoreCrashlyticsInterface
import FirebaseCrashlytics

extension CrashlyticsClient: DependencyKey {
    public static let liveValue = Self(
        record: { error, event in
            let instance = Crashlytics.crashlytics()
            event.customKeys.forEach { instance.setCustomValue($0.value, forKey: $0.key) }
            instance.record(error: error)
        },
        log: { event in
            Crashlytics.crashlytics().log(event.message)
        },
        setUserIdentifier: { userId in
            Crashlytics.crashlytics().setUserID(userId)
        }
    )
}
