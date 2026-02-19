//
//  StatsReducer+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/18/26.
//

import Foundation

import ComposableArchitecture
import DomainStatsInterface
import FeatureStatsInterface
import SharedDesignSystem

extension StatsReducer {
    /// 실제 로직을 포함한 기본 구성의 StatsReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = StatsReducer()
    /// ```
    public init() {
        @Dependency(\.statsClient) var statsClient
        
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .send(.fetchStats)
                
                // MARK: - UserAction
            case let .topTabBarSelected(item):
                state.isOngoing = item == .ongoing
                return .send(.fetchStats)
                
            case let .statsCardTapped(goalId):
                return .send(.delegate(.goToStatsDetail(goalId: goalId)))
                
                // MARK: - Network
            case .fetchStats:
                let isOngoing = state.isOngoing
                return .run { send in
                    let stats: Stats
                    if isOngoing {
                        stats = try await statsClient.fetchOngoingStats("")
                    } else {
                        stats = try await statsClient.fetchCompletedStats("")
                    }
                    
                    await send(.fetchedStats(stats))
                }
                
            case let .fetchedStats(stats):
                let items = stats.stats.map {
                    let goalCount = $0.monthlyCount ?? $0.totalCount ?? 0
                    
                    return StatsCardItem(
                        goalId: $0.goalId,
                        goalName: $0.goalName,
                        iconImage: GoalIcon(from: $0.icon).image,
                        goalCount: goalCount,
                        completionInfos: [
                            .init(name: stats.myNickname, count: $0.myCompletedCount),
                            .init(name: stats.partnerNickname, count: $0.partnerCompletedCount)
                        ]
                    )
                }
                
                if state.isOngoing {
                    state.ongoingItems = items
                } else {
                    state.completedItems = items
                }
                
                return .none
                
            case .delegate:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
