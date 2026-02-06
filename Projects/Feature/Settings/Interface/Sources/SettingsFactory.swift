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

    public init(makeView: @escaping @MainActor @Sendable (StoreOf<SettingsReducer>) -> AnyView) {
        self.makeView = makeView
    }
}

extension SettingsFactory: TestDependencyKey {
    public static let testValue = Self { _ in
        assertionFailure("SettingsFactory.makeView is unimplemented")
        return AnyView(EmptyView())
    }
}

public extension DependencyValues {
    var settingsFactory: SettingsFactory {
        get { self[SettingsFactory.self] }
        set { self[SettingsFactory.self] = newValue }
    }
}
