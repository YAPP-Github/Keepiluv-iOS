//
//  CrashlyticsClient+Live.swift
//  CoreCrashlytics
//

import ComposableArchitecture
import CoreCrashlyticsInterface
import FirebaseCrashlytics

extension CrashlyticsClient: DependencyKey {
    public static let liveValue = Self(
        record: { error, keys in
            let instance = Crashlytics.crashlytics()
            keys.forEach { instance.setCustomValue($0.value, forKey: $0.key) }
            instance.record(error: error)
        },
        log: { message in
            Crashlytics.crashlytics().log(message)
        },
        setUserIdentifier: { userId in
            Crashlytics.crashlytics().setUserID(userId)
        },
        setCustomValue: { value, key in
            Crashlytics.crashlytics().setCustomValue(value, forKey: key)
        }
    )
}
