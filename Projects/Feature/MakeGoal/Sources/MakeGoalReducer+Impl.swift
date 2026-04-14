//
//  MakeGoalReducer+Impl.swift
//  FeatureMakeGoalInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureMakeGoalInterface
import SharedDesignSystem

extension MakeGoalReducer {
    // swiftlint:disable:next function_body_length
    public init() {
        @Dependency(\.goalClient) var goalClient

        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case .view(let viewAction):
                return reduceView(state: &state, action: viewAction, goalClient: goalClient)

            case .internal(let internalAction):
                return reduceInternal(state: &state, action: internalAction, goalClient: goalClient)

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
    state: inout MakeGoalReducer.State,
    action: MakeGoalReducer.Action.View,
    goalClient: GoalClient
) -> Effect<MakeGoalReducer.Action> {
    switch action {
    case .emojiButtonTapped:
        state.ui.isGoalTitleFocused = false
        state.presentation.modal = .selection(
            title: "아이콘 변경",
            icons: MakeGoalReducer.State.icons.map { $0.image },
            selectedIndex: state.data.selectedEmojiIndex,
            buttonTitle: "완료"
        )
        return .none

    case let .modalConfirmTapped(index):
        state.data.selectedEmojiIndex = index
        return .none

    case let .goalTitleFocusChanged(isFocused):
        state.ui.isGoalTitleFocused = isFocused
        return .none

    case .dismissKeyboard:
        state.ui.isGoalTitleFocused = false
        return .none

    case let .periodTabSelected(item):
        switch item {
        case .daily:
            state.data.selectedPeriod = .daily
        case .weekly:
            state.data.selectedPeriod = .weekly
        case .monthly:
            state.data.selectedPeriod = .monthly
        }
        return .none

    case .periodSelected:
        state.ui.isGoalTitleFocused = false
        state.ui.isPeriodSheetPresented = true
        return .none

    case .periodSheetWeeklyTapped:
        state.data.selectedPeriod = .weekly
        return .none

    case .periodSheetMonthlyTapped:
        state.data.selectedPeriod = .monthly
        return .none

    case .periodSheetMinusTapped:
        switch state.data.selectedPeriod {
        case .daily:
            return .none
        case .weekly:
            state.data.weeklyPeriodCount -= 1
            state.data.selectedPeriod = .weekly
        case .monthly:
            state.data.monthlyPeriodCount -= 1
            state.data.selectedPeriod = .monthly
        }
        return .none

    case .periodSheetPlusTapped:
        switch state.data.selectedPeriod {
        case .daily:
            return .none
        case .weekly:
            state.data.weeklyPeriodCount += 1
            state.data.selectedPeriod = .weekly
        case .monthly:
            state.data.monthlyPeriodCount += 1
            state.data.selectedPeriod = .monthly
        }
        return .none

    case .periodSheetCompleteTapped:
        state.ui.isPeriodSheetPresented = false
        return .none

    case .startDateTapped:
        state.ui.isGoalTitleFocused = false
        state.data.calendarTarget = .startDate
        state.data.calendarSheetDate = state.data.startDate
        state.ui.isCalendarSheetPresented = true
        return .none

    case .endDateTapped:
        state.ui.isGoalTitleFocused = false
        state.data.calendarTarget = .endDate
        if state.data.endDate < state.data.startDate {
            state.data.endDate = state.data.startDate
        }
        state.data.calendarSheetDate = state.data.endDate
        state.ui.isCalendarSheetPresented = true
        return .send(.internal(.updateDateText))

    case .monthCalendarConfirmTapped:
        guard let target = state.data.calendarTarget else {
            state.ui.isCalendarSheetPresented = false
            return .none
        }

        switch target {
        case .startDate:
            state.data.startDate = state.data.calendarSheetDate
            if state.data.endDate < state.data.startDate {
                state.data.endDate = state.data.startDate
            }
        case .endDate:
            state.data.endDate = state.data.calendarSheetDate
        }

        state.ui.isCalendarSheetPresented = false
        return .send(.internal(.updateDateText))

    case .completeButtonTapped:
        guard !state.ui.isLoading else { return .none }
        guard !state.completeButtonDisabled else {
            return .send(.presentation(.showToast(.warning(message: "목표 이름은 14글자 이내로 입력해 주세요!"))))
        }

        state.ui.isLoading = true
        let endDateString: String? = state.ui.isEndDateOn
            ? TXCalendarUtil.apiDateString(for: state.data.endDate)
            : nil

        switch state.data.mode {
        case .add:
            let request = GoalCreateRequestDTO(
                name: state.data.goalTitle,
                icon: state.selectedEmoji.rawValue,
                repeatCycle: state.data.selectedPeriod.rawValue,
                repeatCount: state.periodCount,
                startDate: TXCalendarUtil.apiDateString(for: state.data.startDate),
                endDate: endDateString
            )
            return .run { send in
                do {
                    _ = try await goalClient.createGoal(request)
                    await send(.delegate(.navigateBack))
                } catch {
                    await send(.response(.createGoalFailed))
                }
            }

        case .edit:
            guard let goalId = state.data.editingGoalId else {
                state.ui.isLoading = false
                return .send(.presentation(.showToast(.warning(message: "목표 수정에 실패했어요"))))
            }
            let request = GoalUpdateRequestDTO(
                goalName: state.data.goalTitle,
                icon: state.selectedEmoji.rawValue,
                repeatCycle: state.data.selectedPeriod.rawValue,
                repeatCount: state.periodCount,
                endDate: endDateString
            )
            return .run { [goalId] send in
                do {
                    _ = try await goalClient.updateGoal(goalId, request)
                    await send(.delegate(.navigateBack))
                } catch {
                    await send(.response(.updateGoalFailed))
                }
            }
        }

    case .navigationBackButtonTapped:
        return .send(.delegate(.navigateBack))
    }
}

// MARK: - Internal

private func reduceInternal(
    state: inout MakeGoalReducer.State,
    action: MakeGoalReducer.Action.Internal,
    goalClient: GoalClient
) -> Effect<MakeGoalReducer.Action> {
    switch action {
    case .onAppear:
        if case .edit = state.data.mode, let goalId = state.data.editingGoalId {
            state.ui.isLoading = true
            return .run { send in
                do {
                    let goal = try await goalClient.fetchGoalById(goalId)
                    await send(.response(.fetchGoalCompleted(goal)))
                } catch {
                    await send(.response(.fetchGoalFailed))
                }
            }
        }
        return .none

    case .onDisappear:
        return .none

    case .updateDateText:
        guard let startDay = state.data.startDate.day,
              let endDay = state.data.endDate.day
        else { return .none }

        state.ui.startDateText = "\(state.data.startDate.month)월 \(startDay)일"
        state.ui.endDateText = "\(state.data.endDate.month)월 \(endDay)일"
        return .none
    }
}

// MARK: - Response

private func reduceResponse(
    state: inout MakeGoalReducer.State,
    action: MakeGoalReducer.Action.Response
) -> Effect<MakeGoalReducer.Action> {
    switch action {
    case let .fetchGoalCompleted(goal):
        state.ui.isLoading = false
        state.data.goalTitle = goal.title
        state.data.selectedEmojiIndex = MakeGoalReducer.State.icons.firstIndex(
            of: GoalIcon(from: goal.goalIcon)
        ) ?? 0
        if let repeatCycle = goal.repeatCycle {
            state.data.selectedPeriod = repeatCycle
        }
        if let repeatCount = goal.repeatCount {
            switch state.data.selectedPeriod {
            case .weekly:
                state.data.weeklyPeriodCount = repeatCount
            case .monthly:
                state.data.monthlyPeriodCount = repeatCount
            case .daily:
                break
            }
        }
        if let startDateString = goal.startDate,
           let startDate = TXCalendarUtil.parseAPIDateString(startDateString) {
            state.data.startDate = startDate
        }
        if let endDateString = goal.endDate,
           let endDate = TXCalendarUtil.parseAPIDateString(endDateString) {
            state.data.endDate = endDate
            state.ui.isEndDateOn = true
        }
        return .send(.internal(.updateDateText))

    case .fetchGoalFailed:
        state.ui.isLoading = false
        return .send(.presentation(.showToast(.warning(message: "목표 정보를 불러오지 못했어요"))))

    case .createGoalFailed:
        state.ui.isLoading = false
        return .send(.presentation(.showToast(.warning(message: "목표 생성에 실패했어요"))))

    case .updateGoalFailed:
        state.ui.isLoading = false
        return .send(.presentation(.showToast(.warning(message: "이미 완료한 목표입니다!"))))
    }
}

// MARK: - Presentation

private func reducePresentation(
    state: inout MakeGoalReducer.State,
    action: MakeGoalReducer.Action.Presentation
) -> Effect<MakeGoalReducer.Action> {
    switch action {
    case let .showToast(toast):
        state.presentation.toast = toast
        return .none
    }
}
