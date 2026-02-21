//
//  StatsCoordinatorView.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureStatsInterface

/// Stats Feature의 루트 화면을 렌더링하는 Coordinator View입니다.
public struct StatsCoordinatorView: View {
    
    @Bindable var store: StoreOf<StatsCoordinator>
    
    /// StatsCoordinator Store를 주입받아 뷰를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = StatsCoordinatorView(
    ///     store: Store(
    ///         initialState: StatsCoordinator.State()
    ///     ) {
    ///         StatsCoordinator(
    ///             statsReducer: .init(),
    ///             statsDetailReducer: .init()
    ///         )
    ///     }
    /// )
    /// ```
    public init(store: StoreOf<StatsCoordinator>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.routes) {
            StatsView(store: store.scope(state: \.stats, action: \.stats))
                .navigationDestination(for: StatsRoute.self) { route in
                    switch route {
                    case .detail:
                        IfLetStore(store.scope(state: \.detail, action: \.detail)) { store in
                            StatsDetailView(store: store)
                        }
                    }
                }
        }
    }
}

#Preview {
    StatsCoordinatorView(
        store: Store(
            initialState: StatsCoordinator.State(),
            reducer: {
                StatsCoordinator(
                    statsReducer: .init(),
                    statsDetailReducer: .init()
                )
            }, withDependencies: {
                $0.statsClient = .testValue
            }
        )
    )
}
