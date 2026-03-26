//
//  StatsDetailFactory.swift
//  FeatureStatsInterface
//
//  Created by Claude on 2/25/26.
//

import SwiftUI

import ComposableArchitecture

/// StatsDetail 화면을 생성하는 Factory입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.statsDetailFactory) var statsDetailFactory
/// let view = statsDetailFactory.makeView(store)
/// ```
public struct StatsDetailFactory {
    public var makeView: @MainActor (StoreOf<StatsDetailReducer>) -> AnyView

    /// StatsDetail 화면 생성 클로저를 주입하여 Factory를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let factory = StatsDetailFactory { store in
    ///     AnyView(StatsDetailView(store: store))
    /// }
    /// ```
    public init(makeView: @escaping (StoreOf<StatsDetailReducer>) -> AnyView) {
        self.makeView = makeView
    }
}

extension StatsDetailFactory: TestDependencyKey {
    public static var testValue: StatsDetailFactory = Self(
        makeView: { _ in
            assertionFailure("StatsDetailFactory.makeView is unimplemented")
            return AnyView(EmptyView())
        }
    )
}

public extension DependencyValues {
    var statsDetailFactory: StatsDetailFactory {
        get { self[StatsDetailFactory.self] }
        set { self[StatsDetailFactory.self] = newValue }
    }
}
