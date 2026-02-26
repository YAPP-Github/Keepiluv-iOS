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
    // swiftlint:disable:next function_body_length
    public init() {
        @Dependency(\.goalClient) var goalClient
        @Dependency(\.statsClient) var statsClient
        
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .merge(
                    .send(.fetchStatsDetailCalendar),
                    .send(.fetchStatsDetailSummary)
                )
                
            case .onDisappear:
                return .none
                
                // MARK: - User Action
            case let .navigationBarTapped(action):
                if case .backTapped = action {
                    return .send(.delegate(.navigateBack))
                } else if case .rightTapped = action {
                    if state.isCompleted {
                        return .send(.dropDownSelected(.delete))
                    } else {
                        state.isDropdownPresented = true
                        return .none
                    }
                }
                return .none
                
            case .previousMonthTapped:
                state.currentMonth.goToPreviousMonth()
                state.monthlyData = TXCalendarDataGenerator.generateMonthData(
                    for: state.currentMonth,
                    hideAdjacentDates: true
                )
                return .send(.fetchStatsDetailCalendar)
                
            case .nextMonthTapped:
                guard !state.nextMonthDisabled else { return .none }
                state.currentMonth.goToNextMonth()
                state.monthlyData = TXCalendarDataGenerator.generateMonthData(
                    for: state.currentMonth,
                    hideAdjacentDates: true
                )
                return .send(.fetchStatsDetailCalendar)

            case let .calendarSwiped(swipe):
                switch swipe {
                case .previous:
                    return .send(.previousMonthTapped)
                case .next:
                    return .send(.nextMonthTapped)
                }
                
            case let .calendarCellTapped(item):
                guard let dateComponents = item.dateComponents,
                      let txDate = TXCalendarDate(components: dateComponents)
                else { return .none }
                let dateString = txDate.formattedAPIDateString()
                let completedItem = state.completedDateByKey[dateString]
                let isCompletedPartner = completedItem?.partnerImageUrl != nil
                
                return .send(
                    .delegate(
                        .goToGoalDetail(
                            goalId: state.goalId,
                            isCompletedPartner: isCompletedPartner,
                            date: dateString
                        )
                    )
                )
                
            case let .dropDownSelected(item):
                guard let detail = state.statsDetail,
                      let summary = state.statsSummary else { return .none }
                let goalItem = GoalEditCardItem(
                    id: detail.goalId,
                    goalName: detail.goalName,
                    // FIXME: - image 연결
                    iconImage: .Icon.Illustration.default,
                    repeatCycle: summary.repeatCycle.text,
                    startDate: summary.startDate,
                    endDate: summary.endDate ?? ""
                )
                state.isDropdownPresented = false
                state.selectedDropDownItem = item
                
                switch item {
                case .edit:
                    return .send(.delegate(.goToGoalEdit(goalId: state.goalId)))
                    
                case .finish:
                    state.modal = .info(.finishGoal(for: goalItem))
                    
                case .delete:
                    state.modal = .info(.editDeleteGoal(for: goalItem))
                }
                return .none
                
            case .backgroundTapped:
                state.isDropdownPresented = false
                return .none
                
            case .modalConfirmTapped:
                guard let selectedDropDownItem = state.selectedDropDownItem else { return .none }
                switch selectedDropDownItem {
                case .edit: return .none
                case .finish: return .send(.patchCompleteGoal)
                case .delete: return .send(.deleteGoal)
                }
                
                return .none
                
                // MARK: - Network
            case .fetchStatsDetailCalendar:
                let month = state.currentMonth.formattedYearDashMonth
                let goalId = state.goalId
                var applyCached: Effect<Action> = .none
                if let cached = state.completedDateCache[month] {
                    state.isLoading = false
                    applyCached = .send(.updateMonthlyDate(cached))
                } else {
                    state.isLoading = true
                }
                
                let fetchRemote: Effect<Action> = .run { send in
                    do {
                        let statsDetail = try await statsClient.fetchStatsDetailCalendar(goalId, month)
                        await send(.fetchStatsDetailCalendarSuccess(statsDetail, month: month))
                    } catch {
                        await send(.fetchStatsDetailCalendarFailed)
                    }
                }
                
                return .merge(applyCached, fetchRemote)
            
            case .fetchStatsDetailSummary:
                let goalId = state.goalId
                return .run { send in
                    do {
                        let summary = try await statsClient.fetchStatsDetailSummary(goalId)
                        await send(.fetchStatsDetailSummarySuccess(summary))
                    } catch {
                        await send(.fetchStatsDetailSummaryFailed)
                    }
                }

            case let .fetchStatsDetailCalendarSuccess(statsDetail, month):
                state.isLoading = false
                state.statsDetail = statsDetail
                state.completedDateCache[month] = statsDetail.completedDate.filter { $0.date.hasPrefix(month) }
                
                let currentMonth = state.currentMonth.formattedYearDashMonth
                guard currentMonth == month else {
                    return .none
                }
                
                return .send(.updateMonthlyDate(state.completedDateCache[month] ?? []))
                
            case .fetchStatsDetailCalendarFailed:
                state.isLoading = false
                return .none

            case let .fetchStatsDetailSummarySuccess(summary):
                return .send(.updateStatsSummary(summary))

            case .fetchStatsDetailSummaryFailed:
                return .none
                
            case .patchCompleteGoal:
                let goalId = state.goalId
                return .run { send in
                    do {
                        _ = try await goalClient.completeGoal(goalId)
                        await send(.completeGoalSuccees)
                    } catch {
                        await send(.showToast("이미 끝났습니다."))
                    }
                }
                
            case .completeGoalSuccees:
                state.statsDetail?.isCompleted = true
                return .none
                
            case .deleteGoal:
                let goalId = state.goalId
                return .run { send in
                    do {
                        try await goalClient.deleteGoal(goalId)
                        await send(.deleteGoalSuccees)
                    } catch {
                        await send(.showToast("목표 삭제에 실패했어요"))
                    }
                }
                
            case .deleteGoalSuccees:
                return .send(.delegate(.navigateBack))
                
                // MARK: - Update State
            case let .updateStatsDetail(statsDetail):
                state.statsDetail = statsDetail
                return .none
                
            case let .updateStatsSummary(summary):
                state.statsSummary = summary
                let myCountString = "\(summary.myNickname) - \(summary.myCompletedCount)/\(summary.totalCount)"
                let partnerCountString = "\(summary.partnerNickname) - \(summary.partnerCompltedCount)/\(summary.totalCount)"
                 
                let summaryInfo: [State.StatsSummaryInfo] = [
                    .init(title: "달성 횟수", content: [myCountString, partnerCountString]),
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
                
            case let .showToast(text):
                state.toast = .warning(message: text)
                return .none
             
            case .delegate:
                return .none
                
            case .binding:
                return .none
            }
        }

        self.init(reducer: reducer)
    }
}
