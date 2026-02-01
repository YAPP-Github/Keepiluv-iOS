//
//  GoalDetailFactory.swift
//  
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

import ComposableArchitecture

/// GoalDetail 화면을 생성하는 Factory입니다.
///
/// ## 사용 예시
/// ```swift
/// @Dependency(\.goalDetailFactory) var goalDetailFactory
/// let view = goalDetailFactory.makeView(store)
/// ```
public struct GoalDetailFactory {
    public var makeView: @MainActor (StoreOf<GoalDetailReducer>) -> AnyView
    
    /// GoalDetail 화면 생성 클로저를 주입하여 Factory를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let factory = GoalDetailFactory { store in
    ///     AnyView(GoalDetailView(store: store))
    /// }
    /// ```
    public init(makeView: @escaping (StoreOf<GoalDetailReducer>) -> AnyView) {
        self.makeView = makeView
    }
}

extension GoalDetailFactory: TestDependencyKey {
    static public var testValue: GoalDetailFactory = Self(
        makeView: { _ in 
            assertionFailure("GoalDetailFactory.makeView is unimplemented")
            return AnyView(EmptyView())
        }
    )
}

public extension DependencyValues {
    var goalDetailFactory: GoalDetailFactory {
        get { self[GoalDetailFactory.self] }
        set { self[GoalDetailFactory.self] = newValue }
    }
}
