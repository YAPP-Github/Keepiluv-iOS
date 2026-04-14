//
//  StatsDetailReducer+Impl.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
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
        @Dependency(\.goalClient) var goalClient
        @Dependency(\.statsClient) var statsClient

        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case .view(let viewAction):
                return reduceView(state: &state, action: viewAction)

            case .internal(let internalAction):
                return reduceInternal(
                    state: &state,
                    action: internalAction,
                    goalClient: goalClient,
                    statsClient: statsClient
                )

            case .response(let responseAction):
                return reduceResponse(state: &state, action: responseAction)

            case .presentation(let presentationAction):
                return reducePresentation(state: &state, action: presentationAction)

            case .delegate:
                return .none

            case .binding:
                return .none
            }
        }

        self.init(reducer: reducer)
    }
}

// MARK: - View

// swiftlint:disable:next function_body_length
private func reduceView(
    state: inout StatsDetailReducer.State,
    action: StatsDetailReducer.Action.View
) -> Effect<StatsDetailReducer.Action> {
    switch action {
    case let .navigationBarTapped(action):
        if case .backTapped = action {
            return .send(.delegate(.navigateBack))
        } else if case .rightTapped = action {
            if state.isCompleted {
                return .send(.view(.dropDownSelected(.delete)))
            } else {
                state.ui.isDropdownPresented = true
                return .none
            }
        }
        return .none

    case .previousMonthTapped:
        state.data.currentMonth.goToPreviousMonth()
        state.data.monthlyData = TXCalendarDataGenerator.generateMonthData(
            for: state.data.currentMonth,
            hideAdjacentDates: true
        )
        return .send(.internal(.fetchStatsDetailCalendar))

    case .nextMonthTapped:
        guard !state.nextMonthDisabled else { return .none }
        state.data.currentMonth.goToNextMonth()
        state.data.monthlyData = TXCalendarDataGenerator.generateMonthData(
            for: state.data.currentMonth,
            hideAdjacentDates: true
        )
        return .send(.internal(.fetchStatsDetailCalendar))

    case let .calendarSwiped(swipe):
        switch swipe {
        case .previous:
            return .send(.view(.previousMonthTapped))
        case .next:
            return .send(.view(.nextMonthTapped))
        }

    case let .calendarCellTapped(item):
        guard let dateComponents = item.dateComponents,
              let txDate = TXCalendarDate(components: dateComponents)
        else { return .none }
        let dateString = txDate.formattedAPIDateString()
        let completedItem = state.data.completedDateByKey[dateString]
        let isCompletedPartner = completedItem?.partnerImageUrl != nil

        return .send(
            .delegate(
                .goToGoalDetail(
                    goalId: state.data.goalId,
                    isCompletedPartner: isCompletedPartner,
                    date: dateString
                )
            )
        )

    case let .dropDownSelected(item):
        guard let detail = state.data.statsDetail,
              let summary = state.data.statsSummary else { return .none }
        let goalItem = GoalEditCardItem(
            id: detail.goalId,
            goalName: detail.goalName,
            // FIXME: - image 연결
            iconImage: .Icon.Illustration.default,
            repeatCycle: summary.repeatCycle.text,
            startDate: summary.startDate,
            endDate: summary.endDate ?? ""
        )
        state.ui.isDropdownPresented = false
        state.ui.selectedDropDownItem = item

        switch item {
        case .edit:
            return .send(.delegate(.goToGoalEdit(goalId: state.data.goalId)))

        case .finish:
            state.presentation.modal = .info(
                image: goalItem.iconImage,
                title: "\(goalItem.goalName)\n목표를 이루셨나요?",
                subtitle: "이룬 목표에서 확인할 수 있어요",
                leftButtonText: "취소",
                rightButtonText: "이뤘어요"
            )

        case .delete:
            state.presentation.modal = .info(
                image: goalItem.iconImage,
                title: "\(goalItem.goalName)\n목표를 삭제할까요?",
                subtitle: "저장된 인증샷은 모두 삭제됩니다.",
                leftButtonText: "취소",
                rightButtonText: "삭제"
            )
        }
        return .none

    case .backgroundTapped:
        state.ui.isDropdownPresented = false
        return .none

    case .modalConfirmTapped:
        guard let selectedDropDownItem = state.ui.selectedDropDownItem else { return .none }
        switch selectedDropDownItem {
        case .edit: return .none
        case .finish: return .send(.internal(.patchCompleteGoal))
        case .delete: return .send(.internal(.deleteGoal))
        }
    }
}

// MARK: - Internal

// swiftlint:disable:next function_body_length
private func reduceInternal(
    state: inout StatsDetailReducer.State,
    action: StatsDetailReducer.Action.Internal,
    goalClient: GoalClient,
    statsClient: StatsClient
) -> Effect<StatsDetailReducer.Action> {
    switch action {
    case .onAppear:
        return .merge(
            .send(.internal(.fetchStatsDetailCalendar)),
            .send(.internal(.fetchStatsDetailSummary))
        )

    case .onDisappear:
        return .none

    case .fetchStatsDetailCalendar:
        let month = state.data.currentMonth.formattedYearDashMonth
        let goalId = state.data.goalId
        var applyCached: Effect<StatsDetailReducer.Action> = .none
        if let cached = state.data.completedDateCache[month] {
            state.ui.isLoading = false
            applyCached = .send(.internal(.updateMonthlyDate(cached)))
        } else {
            state.ui.isLoading = true
        }

        let fetchRemote: Effect<StatsDetailReducer.Action> = .run { send in
            do {
                let statsDetail = try await statsClient.fetchStatsDetailCalendar(goalId, month)
                await send(.response(.fetchStatsDetailCalendarSuccess(statsDetail, month: month)))
            } catch {
                await send(.response(.fetchStatsDetailCalendarFailed))
            }
        }

        return .merge(applyCached, fetchRemote)

    case .fetchStatsDetailSummary:
        let goalId = state.data.goalId
        return .run { send in
            do {
                let summary = try await statsClient.fetchStatsDetailSummary(goalId)
                await send(.response(.fetchStatsDetailSummarySuccess(summary)))
            } catch {
                await send(.response(.fetchStatsDetailSummaryFailed))
            }
        }

    case .patchCompleteGoal:
        let goalId = state.data.goalId
        return .run { send in
            do {
                _ = try await goalClient.completeGoal(goalId)
                await send(.response(.completeGoalSuccees))
            } catch {
                await send(.presentation(.showToast("이미 끝났습니다.")))
            }
        }

    case .deleteGoal:
        let goalId = state.data.goalId
        return .run { send in
            do {
                try await goalClient.deleteGoal(goalId)
                await send(.response(.deleteGoalSuccees))
            } catch {
                await send(.presentation(.showToast("목표 삭제에 실패했어요")))
            }
        }

    case let .updateStatsDetail(statsDetail):
        state.data.statsDetail = statsDetail
        return .none

    case let .updateStatsSummary(summary):
        state.data.statsSummary = summary
        let myCountString = "\(summary.myNickname) - \(summary.myCompletedCount)/\(summary.totalCount)"
        let partnerCountString = "\(summary.partnerNickname) - \(summary.partnerCompltedCount)/\(summary.totalCount)"

        let summaryInfo: [StatsDetailReducer.State.StatsSummaryInfo] = [
            .init(title: "달성 횟수", content: [myCountString, partnerCountString]),
            .init(title: "반복 주기", content: [summary.repeatCycle.text]),
            .init(title: "시작일", content: [summary.startDate]),
            .init(title: "종료일", content: [summary.endDate ?? "미설정"])
        ]

        state.data.statsSummaryInfo = summaryInfo
        return .none

    case let .updateMonthlyDate(completedDate):
        state.data.completedDateByKey = completedDate.reduce(into: [:]) { result, item in
            guard item.myImageUrl != nil || item.partnerImageUrl != nil else { return }
            result[item.date] = item
        }

        let completedDateSet = Set(completedDate.map(\.date))
        state.data.monthlyData = state.data.monthlyData.map { week in
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

// MARK: - Response

private func reduceResponse(
    state: inout StatsDetailReducer.State,
    action: StatsDetailReducer.Action.Response
) -> Effect<StatsDetailReducer.Action> {
    switch action {
    case let .fetchStatsDetailCalendarSuccess(statsDetail, month):
        state.ui.isLoading = false
        state.data.statsDetail = statsDetail
        state.data.completedDateCache[month] = statsDetail.completedDate.filter { $0.date.hasPrefix(month) }

        let currentMonth = state.data.currentMonth.formattedYearDashMonth
        guard currentMonth == month else {
            return .none
        }

        return .send(.internal(.updateMonthlyDate(state.data.completedDateCache[month] ?? [])))

    case .fetchStatsDetailCalendarFailed:
        state.ui.isLoading = false
        return .none

    case let .fetchStatsDetailSummarySuccess(summary):
        return .send(.internal(.updateStatsSummary(summary)))

    case .fetchStatsDetailSummaryFailed:
        return .none

    case .completeGoalSuccees:
        state.data.statsDetail?.isCompleted = true
        return .none

    case .deleteGoalSuccees:
        return .send(.delegate(.navigateBack))
    }
}

// MARK: - Presentation

private func reducePresentation(
    state: inout StatsDetailReducer.State,
    action: StatsDetailReducer.Action.Presentation
) -> Effect<StatsDetailReducer.Action> {
    switch action {
    case let .showToast(text):
        state.presentation.toast = .warning(message: text)
        return .none
    }
}
