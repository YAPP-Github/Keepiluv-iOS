//
//  StatsDetailReducer+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture
import DomainStatsInterface
import FeatureStatsInterface
import SharedDesignSystem

// TODO: API 연동
extension StatsDetailReducer {
    /// 기본 구성의 StatsDetailReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = StatsDetailReducer()
    /// ```
    public init() {
        @Dependency(\.statsClient) var statsClient
        
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .send(.fetchStatsDetail)
                
                // MARK: - Network
            case .fetchStatsDetail:
                let goalId = state.goalId
                return .run { send in
                    let statsDetail = try await statsClient.fetchStatsDetail(String(goalId))
                    await send(.updateStatsDetail(statsDetail))
                }
                
                // MARK: - Update State
            case let .updateStatsDetail(statsDetail):
                state.statsDetail = statsDetail
                
                return .merge([
                    .send(.updateMonthlyDate(statsDetail.completedDate)),
                    .send(.updateStatsSummary(statsDetail.summary))
                ])
                
            case let .updateStatsSummary(summary):
                let myCountString = "\(summary.myNickname) - \(summary.myCompletedCount)/\(summary.totalCount)"
                let partnerCountString = "\(summary.partnerNickname) - \(summary.partnerCompltedCount)/\(summary.totalCount)"
                 
                let summaryInfo: [State.StatsSummaryInfo] = [
                    .init(
                        title: "달성 횟수", content: [myCountString, partnerCountString]
                    ),
                    .init(title: "반복 주기", content: [summary.repeatCycle.text]),
                    .init(title: "시작일", content: [summary.startDate]),
                    .init(title: "종료일", content: [summary.endDate ?? "미설정"]),
                ]
                
                state.statsSummaryInfo = summaryInfo
                return .none
                
            case let .updateMonthlyDate(completedDate):
                state.completedDateByKey = completedDate.reduce(into: [:]) { result, item in
                    guard item.myImageUrl != nil || item.partnerImageUrl != nil else { return }
                    result[item.date] = item
                }

                let completedDateSet = Set(completedDate.map(\.date))
                state.monthlyData = state.monthlyData.map { week in
                    week.map { item in
                        guard let components = item.dateComponents,
                              let date = TXCalendarDate(components: components) else {
                            return item
                        }
                        let isCompletedDate = completedDateSet.contains(date.formattedAPIDateString())

                        guard isCompletedDate else { return item }
                        return TXCalendarDateItem(
                            id: item.id,
                            text: item.text,
                            status: .completed,
                            dateComponents: item.dateComponents
                        )
                    }
                }
                return .none
            }
        }

        self.init(reducer: reducer)
    }
}
