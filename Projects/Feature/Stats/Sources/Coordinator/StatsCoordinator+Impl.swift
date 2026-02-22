//
//  StatsCoordinator+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture
import FeatureGoalDetailInterface
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
        statsDetailReducer: StatsDetailReducer,
        goalDetailReducer: GoalDetailReducer
    ) {
        let reducer = Reduce<State, Action> {
            state,
            action in
            switch action {
                // MARK: - Child Action
            case let .stats(.delegate(.goToStatsDetail(goalId))):
                state.routes.append(.statsDetail)
                state.statsDetail = .init(goalId: goalId)
                return .none
                
                
            case let .statsDetail(.delegate(.goToGoalDetail(goalId, isCompletedPartner, date))):
                state.routes.append(.goalDetail)
                state.goalDetail = .init(
                    currentUser: isCompletedPartner ? .you : .mySelf,
                    id: goalId,
                    verificationDate: date
                )
                return .none
                
            case .statsDetail(.delegate(.navigateBack)):
                state.routes.removeLast()
                return .none
                
            case .goalDetail(.delegate(.navigateBack)):
                state.routes.removeLast()
                return .none

            case .statsDetail(.onDisappear):
                if !state.routes.contains(.statsDetail) {
                    state.statsDetail = nil
                }
                return .none
                
            case .goalDetail(.onDisappear):
                if !state.routes.contains(.goalDetail) {
                    state.goalDetail = nil
                }
                return .none
                
            case .stats:
                return .none

            case .statsDetail:
                return .none
                
            case .goalDetail:
                return .none

                // MARK: - Binding
            case .binding:
                return .none
            }
        }
        
        self.init(
            statsReducer: statsReducer,
            statsDetailReducer: statsDetailReducer,
            goalDetailReducer: goalDetailReducer,
            reducer: reducer
        )
    }
}
