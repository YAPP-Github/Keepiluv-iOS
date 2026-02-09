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

private enum GoalAPIError: Error {
    case invalidGoalId
}

extension EditGoalListReducer {
    /// 실제 로직을 포함한 EditGoalListReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = EditGoalListReducer()
    /// ```
    // swiftlint:disable:next function_body_length
    public init() {
        @Dependency(\.goalClient) var goalClient
        
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                state.isLoading = true
                return .run { [calendarDate = state.calendarDate] send in
                    do {
                        let goals = try await goalClient.fetchGoals(TXCalendarUtil.apiDateString(for: calendarDate))

                        // 각 목표의 상세 정보를 병렬로 가져옴
                        let items = try await withThrowingTaskGroup(
                            of: GoalEditCardItem?.self
                        ) { group in
                            for goal in goals {
                                group.addTask {
                                    do {
                                        let detail = try await goalClient.fetchGoalById(goal.id)
                                        let repeatCycleText: String
                                        if let cycle = detail.repeatCycle, let count = detail.repeatCount {
                                            repeatCycleText = "\(cycle.text) \(count)번"
                                        } else {
                                            repeatCycleText = "미정"
                                        }

                                        let startDateText = detail.startDate ?? "-"
                                        let endDateText = detail.endDate ?? "미설정"

                                        return GoalEditCardItem(
                                            id: String(goal.id),
                                            goalName: goal.title,
                                            iconImage: goal.goalIcon.image,
                                            repeatCycle: repeatCycleText,
                                            startDate: startDateText,
                                            endDate: endDateText
                                        )
                                    } catch {
                                        // 상세 조회 실패 시 기본 값으로 카드 생성
                                        return GoalEditCardItem(
                                            id: String(goal.id),
                                            goalName: goal.title,
                                            iconImage: goal.goalIcon.image,
                                            repeatCycle: "미정",
                                            startDate: "-",
                                            endDate: "미설정"
                                        )
                                    }
                                }
                            }

                            var results: [GoalEditCardItem] = []
                            for try await item in group {
                                if let item { results.append(item) }
                            }
                            return results
                        }

                        await send(.fetchGoalsCompleted(items))
                    } catch {
                        await send(.apiError("목표 조회에 실패했어요"))
                    }
                }
                
            case .onDisappear:
                state.selectedCardMenu = nil
                return .none
                
                // MARK: - User Action
            case let .calendarDateSelected(item):
                guard let components = item.dateComponents,
                      let year = components.year,
                      let month = components.month,
                      let day = components.day else {
                    return .none
                }
                return .send(.setCalendarDate(.init(year: year, month: month, day: day)))
                
            case .navigationBackButtonTapped:
                return .send(.delegate(.navigateBack))
                
            case let .cardMenuButtonTapped(card):
                state.selectedCardMenu = state.selectedCardMenu == card ? nil : card
                return .none
                
            case let .cardMenuItemSelected(item):
                guard let card = state.selectedCardMenu else { return .none }

                switch item {
                case .edit:
                    state.selectedCardMenu = nil
                    guard let goalIdInt = Int(card.id) else { return .none }
                    return .send(.delegate(.goToGoalEdit(goalId: goalIdInt)))

                case .finish:
                    state.pendingGoalId = card.id
                    state.pendingAction = .complete
                    state.modal = .info(.finishGoal(for: card))

                case .delete:
                    state.pendingGoalId = card.id
                    state.pendingAction = .delete
                    state.modal = .info(.editDeleteGoal(for: card))
                }

                state.selectedCardMenu = nil
                return .none
                
            case .backgroundTapped:
                state.selectedCardMenu = nil
                return .none
                
            case .modalConfirmTapped:
                guard let goalId = state.pendingGoalId,
                      let pendingAction = state.pendingAction else {
                    return .none
                }

                state.isLoading = true
                state.modal = nil

                switch pendingAction {
                case .complete:
                    return .run { send in
                        do {
                            guard let goalIdInt = Int(goalId) else { throw GoalAPIError.invalidGoalId }
                            _ = try await goalClient.completeGoal(goalIdInt)
                            await send(.completeGoalCompleted(goalId: goalId))
                        } catch {
                            await send(.apiError("목표 완료에 실패했어요"))
                        }
                    }

                case .delete:
                    return .run { send in
                        do {
                            guard let goalIdInt = Int(goalId) else { throw GoalAPIError.invalidGoalId }
                            try await goalClient.deleteGoal(goalIdInt)
                            await send(.deleteGoalCompleted(goalId: goalId))
                        } catch {
                            await send(.apiError("목표 삭제에 실패했어요"))
                        }
                    }
                }
                
                // MARK: - Update State
            case let .setCalendarDate(date):
                state.calendarDate = date
                state.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
                return .none
                
            case let .fetchGoalsCompleted(items):
                state.isLoading = false
                state.cards = items
                return .none

            case let .deleteGoalCompleted(goalId):
                state.isLoading = false
                state.pendingGoalId = nil
                state.pendingAction = nil
                state.cards.removeAll { $0.id == goalId }
                return .send(.showToast(.delete(message: "목표가 삭제되었어요")))

            case let .completeGoalCompleted(goalId):
                state.isLoading = false
                state.pendingGoalId = nil
                state.pendingAction = nil
                state.cards.removeAll { $0.id == goalId }
                return .send(.showToast(.success(message: "목표를 달성했어요!")))

            case let .apiError(message):
                state.isLoading = false
                state.pendingGoalId = nil
                state.pendingAction = nil
                return .send(.showToast(.warning(message: message)))

            case let .showToast(toast):
                state.toast = toast
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
