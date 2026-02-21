//
//  NotificationFactory.swift
//  FeatureNotificationInterface
//
//  Created by Jiyong on 02/21/26.
//

import ComposableArchitecture
import SwiftUI

/// Notification 화면 생성을 담당하는 Factory입니다.
public struct NotificationFactory: Sendable {
    public var makeView: @MainActor @Sendable (StoreOf<NotificationReducer>) -> AnyView

    public init(makeView: @escaping @MainActor @Sendable (StoreOf<NotificationReducer>) -> AnyView) {
        self.makeView = makeView
    }
}

extension NotificationFactory: TestDependencyKey {
    public static let testValue = Self { _ in
        assertionFailure("NotificationFactory.makeView is unimplemented")
        return AnyView(EmptyView())
    }
}

public extension DependencyValues {
    var notificationFactory: NotificationFactory {
        get { self[NotificationFactory.self] }
        set { self[NotificationFactory.self] = newValue }
    }
}
