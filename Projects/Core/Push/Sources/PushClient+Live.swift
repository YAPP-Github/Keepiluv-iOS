//
//  PushClient+Live.swift
//  CorePush
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import CorePushInterface
import FirebaseMessaging
import Foundation
import UIKit
import UserNotifications

extension PushClient: DependencyKey {
    public static let liveValue = Self(
        requestAuthorization: {
            try await withCheckedThrowingContinuation { continuation in
                UNUserNotificationCenter.current().requestAuthorization(
                    options: [.alert, .badge, .sound]
                ) { granted, error in
                    if let error {
                        continuation.resume(throwing: error)
                    } else {
                        continuation.resume(returning: granted)
                    }
                }
            }
        },
        getFCMToken: {
            // FCM 토큰이 있으면 바로 반환 (Firebase swizzling 환경에서는 apnsToken이 nil일 수 있음)
            if let token = Messaging.messaging().fcmToken {
                return token
            }

            // FCM 토큰이 없으면 NotificationCenter로 토큰 기다리기 (최대 10초)
            return try await withCheckedThrowingContinuation { continuation in
                var observer: NSObjectProtocol?
                var hasResumed = false

                let timeout = DispatchWorkItem {
                    guard !hasResumed else { return }
                    hasResumed = true
                    if let obs = observer {
                        NotificationCenter.default.removeObserver(obs)
                    }
                    continuation.resume(throwing: PushError.tokenNotAvailable)
                }

                observer = NotificationCenter.default.addObserver(
                    forName: .fcmTokenRefreshed,
                    object: nil,
                    queue: .main
                ) { notification in
                    guard !hasResumed else { return }
                    hasResumed = true
                    timeout.cancel()
                    if let obs = observer {
                        NotificationCenter.default.removeObserver(obs)
                    }
                    if let token = notification.userInfo?["token"] as? String {
                        continuation.resume(returning: token)
                    } else {
                        continuation.resume(throwing: PushError.tokenNotAvailable)
                    }
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 10, execute: timeout)
            }
        },
        tokenRefreshStream: {
            AsyncStream { continuation in
                let observer = NotificationCenter.default.addObserver(
                    forName: .fcmTokenRefreshed,
                    object: nil,
                    queue: .main
                ) { notification in
                    if let token = notification.userInfo?["token"] as? String {
                        continuation.yield(token)
                    }
                }
                continuation.onTermination = { _ in
                    NotificationCenter.default.removeObserver(observer)
                }
            }
        },
        registerForRemoteNotifications: {
            await MainActor.run {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    )
}

// MARK: - PushError

/// 푸시 관련 에러입니다.
public enum PushError: Error, Sendable {
    case tokenNotAvailable
    case authorizationDenied
}

// MARK: - Notification.Name

extension Notification.Name {
    static let fcmTokenRefreshed = Notification.Name("fcmTokenRefreshed")
}
