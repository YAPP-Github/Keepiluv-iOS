//
//  GoalDetailFactory+Live.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface

extension GoalDetailFactory: @retroactive DependencyKey {
    /// GoalDetailFactory의 기본 구현입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @Dependency(\.goalDetailFactory) var goalDetailFactory
    /// let view = goalDetailFactory.makeView(store)
    /// ```
    public static var liveValue: GoalDetailFactory = Self { store in
        AnyView(GoalDetailView(store: store))
    }
}
