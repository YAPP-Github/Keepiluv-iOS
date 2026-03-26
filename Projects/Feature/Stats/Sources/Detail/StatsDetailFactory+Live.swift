//
//  StatsDetailFactory+Live.swift
//  FeatureStats
//
//  Created by Claude on 2/25/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureStatsInterface

extension StatsDetailFactory: @retroactive DependencyKey {
    /// StatsDetailFactory의 기본 구현입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @Dependency(\.statsDetailFactory) var statsDetailFactory
    /// let view = statsDetailFactory.makeView(store)
    /// ```
    public static var liveValue: StatsDetailFactory = Self { store in
        AnyView(StatsDetailView(store: store))
    }
}
