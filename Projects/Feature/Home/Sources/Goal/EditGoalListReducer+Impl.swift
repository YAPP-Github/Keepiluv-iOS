//
//  EditGoalListReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation
import SwiftUI

import ComposableArchitecture
import DomainGoalInterface
import FeatureHomeInterface
import SharedDesignSystem
import SharedUtil

extension EditGoalListReducer {
    /// 실제 로직을 포함한 EditGoalListReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = EditGoalListReducer()
    /// ```
    public init() {
        @Dependency(\.goalClient) var goalClient

        let reducer = Reduce<State, Action> { state, action in
            switch action {
            case .view(let viewAction):
                return reduceView(state: &state, action: viewAction)

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

private func reduceView(
    state: inout EditGoalListReducer.State,
    action: EditGoalListReducer.Action.View
) -> Effect<EditGoalListReducer.Action> {
    switch action {
    case let .calendarDateSelected(item):
        guard let components = item.dateComponents,
              let year = components.year,
              let month = components.month,
              let day = components.day else {
            return .none
        }
        return .send(.internal(.setCalendarDate(.init(year: year, month: month, day: day))))

    case let .weekCalendarSwipe(swipe):
        switch swipe {
        case .next:
            guard let nextWeekDate = TXCalendarUtil.dateByAddingWeek(
                from: state.data.calendarDate,
                by: 1
            ) else {
                return .none
            }
            return .send(.internal(.setCalendarDate(nextWeekDate)))

        case .previous:
            guard let previousWeekDate = TXCalendarUtil.dateByAddingWeek(
                from: state.data.calendarDate,
                by: -1
            ) else {
                return .none
            }
            return .send(.internal(.setCalendarDate(previousWeekDate)))
        }

    case .navigationBackButtonTapped:
        return .send(.delegate(.navigateBack))

    case let .cardMenuButtonTapped(card):
        state.data.selectedCardMenu = state.data.selectedCardMenu == card ? nil : card
        return .none

    case let .cardMenuItemSelected(item):
        guard let card = state.data.selectedCardMenu else { return .none }

        switch item {
        case .edit:
            state.data.selectedCardMenu = nil

            // FIXME: - 통계 나오기 전까지 토스트 띄움
            let isPast = state.data.calendarDate < TXCalendarDate()
            if isPast {
                state.presentation.toast = .warning(message: "이미 완료한 목표입니다!")
            } else {
                return .send(.delegate(.goToGoalEdit(goalId: card.id)))
            }

        case .finish:
            state.data.pendingGoalId = card.id
            state.data.pendingAction = .complete
            state.presentation.modal = .info(
                image: card.iconImage,
                title: "\(card.goalName)\n목표를 이루셨나요?",
                subtitle: "이룬 목표에서 확인할 수 있어요",
                leftButtonText: "취소",
                rightButtonText: "이뤘어요"
            )

        case .delete:
            state.data.pendingGoalId = card.id
            state.data.pendingAction = .delete
            state.presentation.modal = .info(
                image: card.iconImage,
                title: "\(card.goalName)\n목표를 삭제할까요?",
                subtitle: "저장된 인증샷은 모두 삭제됩니다.",
                leftButtonText: "취소",
                rightButtonText: "삭제"
            )
        }

        state.data.selectedCardMenu = nil
        return .none

    case .backgroundTapped:
        state.data.selectedCardMenu = nil
        return .none

    case .modalConfirmTapped:
        guard !state.ui.isLoading,
              let goalId = state.data.pendingGoalId,
              let pendingAction = state.data.pendingAction else {
            return .none
        }

        state.ui.isLoading = true
        state.presentation.modal = nil
        return .send(.internal(pendingAction == .complete ? .completeGoal(goalId) : .deleteGoal(goalId)))
    }
}

// MARK: - Internal

private func reduceInternal(
    state: inout EditGoalListReducer.State,
    action: EditGoalListReducer.Action.Internal,
    goalClient: GoalClient
) -> Effect<EditGoalListReducer.Action> {
    switch action {
    case .onAppear:
        return .send(.internal(.fetchGoals))

    case .onDisappear:
        state.data.selectedCardMenu = nil
        return .none

    case let .setCalendarDate(date):
        if date == state.data.calendarDate {
            return .none
        }
        state.data.calendarDate = date
        state.data.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
        state.ui.isLoading = true
        return .send(.internal(.fetchGoals))

    case .fetchGoals:
        state.ui.isLoading = true
        let date = state.data.calendarDate
        return .run { send in
            do {
                let items = try await goalClient.fetchGoalEditList(TXCalendarUtil.apiDateString(for: date))
                let editItems = items.map {
                    GoalEditCardItem(
                        id: $0.id,
                        goalName: $0.title,
                        iconImage: GoalIcon(from: $0.goalIcon).image,
                        repeatCycle: $0.repeatCycle?.text ?? "",
                        startDate: $0.startDate?.dateDisplayString ?? "",
                        endDate: $0.endDate?.dateDisplayString ?? "미설정"
                    )
                }
                await send(.response(.fetchGoalsCompleted(editItems, date: date)))
            } catch {
                await send(.response(.apiError("목표 조회에 실패했어요")))
            }
        }

    case let .completeGoal(goalId):
        return .run { send in
            do {
                _ = try await goalClient.completeGoal(goalId)
                await send(.response(.completeGoalCompleted(goalId: goalId)))
            } catch {
                await send(.response(.apiError("이미 끝났습니다.")))
            }
        }

    case let .deleteGoal(goalId):
        return .run { send in
            do {
                try await goalClient.deleteGoal(goalId)
                await send(.response(.deleteGoalCompleted(goalId: goalId)))
            } catch {
                await send(.response(.apiError("목표 삭제에 실패했어요")))
            }
        }
    }
}

// MARK: - Response

private func reduceResponse(
    state: inout EditGoalListReducer.State,
    action: EditGoalListReducer.Action.Response
) -> Effect<EditGoalListReducer.Action> {
    switch action {
    case let .fetchGoalsCompleted(items, date):
        if date != state.data.calendarDate {
            return .none
        }
        state.ui.isLoading = false
        if state.data.cards != items {
            state.data.cards = items
        }
        return .none

    case let .deleteGoalCompleted(goalId):
        state.ui.isLoading = false
        state.data.pendingGoalId = nil
        state.data.pendingAction = nil
        state.data.cards?.removeAll { $0.id == goalId }
        return .send(.presentation(.showToast(.delete(message: "목표가 삭제되었어요"))))

    case let .completeGoalCompleted(goalId):
        state.ui.isLoading = false
        state.data.pendingGoalId = nil
        state.data.pendingAction = nil
        state.data.cards?.removeAll { $0.id == goalId }
        return .send(.presentation(.showToast(.success(message: "목표를 달성했어요!"))))

    case let .apiError(message):
        state.ui.isLoading = false
        state.data.pendingGoalId = nil
        state.data.pendingAction = nil
        return .send(.presentation(.showToast(.warning(message: message))))
    }
}

// MARK: - Presentation

private func reducePresentation(
    state: inout EditGoalListReducer.State,
    action: EditGoalListReducer.Action.Presentation
) -> Effect<EditGoalListReducer.Action> {
    switch action {
    case let .showToast(toast):
        state.presentation.toast = toast
        return .none
    }
}
