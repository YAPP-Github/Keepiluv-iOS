//
//  GoalDetailFactory.swift
//  
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

import ComposableArchitecture

public struct GoalDetailFactory {
    public var makeView: @MainActor (StoreOf<GoalDetailReducer>) -> AnyView
    
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

