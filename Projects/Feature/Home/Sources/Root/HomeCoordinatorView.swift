//
//  HomeCoordinatorView.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface
import FeatureHomeInterface

/// Home Feature의 NavigationStack을 제공하는 Root View입니다.
///
/// ## 사용 예시
/// ```swift
/// HomeCoordinatorView(
///     store: Store(
///         initialState: HomeCoordinatorReducer.State()
///     ) {
///         HomeCoordinatorReducer()
///     }
/// )
/// ```
public struct HomeCoordinatorView: View {
    @Dependency(\.goalDetailFactory) var goalDetailFactory
    @Bindable public var store: StoreOf<HomeCoordinator>

    /// HomeCoordinatorView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = HomeCoordinatorView(store: Store(initialState: HomeCoordinatorReducer.State()) { HomeCoordinatorReducer() })
    /// ```
    public init(store: StoreOf<HomeCoordinator>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.routes) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .detail:
                        IfLetStore(store.scope(state: \.goalDetail, action: \.goalDetail)) { store in
                            goalDetailFactory.makeView(store)
                        }
                    case .editGoal:
                        IfLetStore(store.scope(state: \.editGoal, action: \.editGoal)) { store in
                            EditGoalView(store: store)
                        }
                        
                    case .makeGoal:
                        IfLetStore(store.scope(state: \.makeGoal, action: \.makeGoal)) { store in
                            MakeGoalView(store: store)
                        }
                    }
                }
        }
    }
}
