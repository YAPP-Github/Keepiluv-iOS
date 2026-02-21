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
    // swiftlint:disable:next function_body_length
    public init() {
        @Dependency(\.statsClient) var statsClient
        
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .send(.fetchStats)
                
                // MARK: - UserAction
            case let .topTabBarSelected(item):
                state.isOngoing = item == .ongoing
                return .send(.fetchStats)
                
            case .previousMonthTapped:
                state.currentMonth.goToPreviousMonth()
                return .send(.fetchStats)
                
            case .nextMonthTapped:
                state.currentMonth.goToNextMonth()
                return .send(.fetchStats)
                
            case let .statsCardTapped(goalId):
                return .send(.delegate(.goToStatsDetail(goalId: goalId)))
                
                // MARK: - Update State
            case let .showToast(toast):
                state.toast = toast
                return .none
                
                // MARK: - Network
            case .fetchStats:
                let isOngoing = state.isOngoing
                let month = state.currentMonth.formattedAPIDateString()
                
                if isOngoing,
                   let cachedItems = state.ongoingItemsCache[month] {
                    state.ongoingItems = cachedItems
                    state.isLoading = false
                } else {
                    state.isLoading = true
                }
                
                return .run { send in
                    do {
                        let stats: Stats
                        if isOngoing {
                            stats = try await statsClient.fetchOngoingStats(month)
                        } else {
                            stats = try await statsClient.fetchCompletedStats(month)
                        }
                        
                        await send(.fetchedStats(stats: stats, month: month))
                    } catch {
                        await send(.fetchStatsFailed)
                    }
                }
                
            case let .fetchedStats(stats, month):
                state.isLoading = false
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
                    state.ongoingItemsCache[month] = items
                }

                // 요청 시점의 탭/월과 현재 상태가 같을 때만 화면을 업데이트합니다.
                guard month == state.currentMonth.formattedAPIDateString() else {
                    return .none
                }

                if state.isOngoing {
                    state.ongoingItems = items
                } else {
                    state.completedItems = items
                }
                
                return .none

            case .fetchStatsFailed:
                state.isLoading = false
                return .send(.showToast(.warning(message: "통계 조회에 실패했어요")))
                
            case .delegate:
                return .none
                
            case .binding:
                return .none
            }
        }
        self.init(reducer: reducer)
    }
}
