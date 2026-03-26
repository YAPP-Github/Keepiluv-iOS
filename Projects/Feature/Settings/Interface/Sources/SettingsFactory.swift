//
//  SettingsFactory.swift
//  FeatureSettingsInterface
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import SwiftUI

/// Settings 화면 생성을 담당하는 Factory입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.settingsFactory) var settingsFactory
/// settingsFactory.makeView(store)
/// ```
public struct SettingsFactory: Sendable {
    public var makeView: @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView
    public var makeAccountView: @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView
    public var makeInfoView: @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView
    public var makeNotificationSettingsView: @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView
    public var makeWebView: @MainActor @Sendable (StoreOf<SettingsReducer>, URL, String) -> AnyView

    public init(
        makeView: @escaping @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView,
        makeAccountView: @escaping @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView,
        makeInfoView: @escaping @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView,
        makeNotificationSettingsView: @escaping @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView,
        makeWebView: @escaping @MainActor @Sendable (StoreOf<SettingsReducer>, URL, String) -> AnyView
    ) {
        self.makeView = makeView
        self.makeAccountView = makeAccountView
        self.makeInfoView = makeInfoView
        self.makeNotificationSettingsView = makeNotificationSettingsView
        self.makeWebView = makeWebView
    }
}

extension SettingsFactory: TestDependencyKey {
    public static let testValue = Self(
        makeView: { _ in
            assertionFailure("SettingsFactory.makeView is unimplemented")
            return AnyView(EmptyView())
        },
        makeAccountView: { _ in
            assertionFailure("SettingsFactory.makeAccountView is unimplemented")
            return AnyView(EmptyView())
        },
        makeInfoView: { _ in
            assertionFailure("SettingsFactory.makeInfoView is unimplemented")
            return AnyView(EmptyView())
        },
        makeNotificationSettingsView: { _ in
            assertionFailure("SettingsFactory.makeNotificationSettingsView is unimplemented")
            return AnyView(EmptyView())
        },
        makeWebView: { _, _, _ in
            assertionFailure("SettingsFactory.makeWebView is unimplemented")
            return AnyView(EmptyView())
        }
    )
}

public extension DependencyValues {
    var settingsFactory: SettingsFactory {
        get { self[SettingsFactory.self] }
        set { self[SettingsFactory.self] = newValue }
    }
}
