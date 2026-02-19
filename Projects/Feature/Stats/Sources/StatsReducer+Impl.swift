//
//  StatsReducer+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/18/26.
//

import Foundation

import ComposableArchitecture
import FeatureStatsInterface
import DomainStatsInterface
import SharedDesignSystem

extension StatsReducer {
    public init() {
        @Dependency(\.statsClient) var statsClient
        
        let reducer = Reduce<State, Action> {
            state,
            action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .send(.fetchStats)
                
                // MARK: - Network
                
            case .fetchStats:
                return .run { send in
                    let stats = try await statsClient.fetchOngoingStats("")
                    
                    await send(.fetchedStats(stats))
                }
                
            case let .fetchedStats(stats):
                let items = stats.stats.map {
                    let goalCount = $0.monthlyCount ?? $0.totalCount ?? 0
                    
                    return StatsCardItem(
                        goalId: $0.goalId,
                        goalName: $0.goalName,
                        iconImage: GoalIcon(rawValue: $0.icon)?.image ?? GoalIcon.default.image,
                        goalCount: goalCount,
                        completionInfos: [
                            .init(name: stats.myNickname, count: $0.myCompletedCount),
                            .init(name: stats.partnerNickname, count: $0.partnerCompletedCount),
                        ]
                    )
                }
                
                state.items = items
                
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
