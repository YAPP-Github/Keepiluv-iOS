//
//  StatsCoordinator+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture
import FeatureStatsInterface

extension StatsCoordinator {
    /// 기본 구성의 StatsCoordinator를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let coordinator = StatsCoordinator(
    ///     statsReducer: .init(),
    ///     statsDetailReducer: .init()
    /// )
    /// ```
    public init(
        statsReducer: StatsReducer,
        statsDetailReducer: StatsDetailReducer
    ) {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - Child Action
            case let .stats(.delegate(.goToStatsDetail(goalId))):
                state.routes.append(.detail)
                state.detail = .init(goalId: goalId)
                return .none

            case .detail(.delegate(.navigateBack)):
                if !state.routes.isEmpty {
                    state.routes.removeLast()
                }
                return .none

            case .detail(.onDisappear):
                state.detail = nil
                return .none
                
            case .stats:
                return .none

            case .detail:
                return .none

                // MARK: - Binding
            case .binding:
                return .none
            }
        }
        
        self.init(
            statsReducer: statsReducer,
            statsDetailReducer: statsDetailReducer,
            reducer: reducer
        )
    }
}
