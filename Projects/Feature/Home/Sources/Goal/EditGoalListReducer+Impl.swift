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
                return .send(.fetchGoals)
                
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
                
            case let .weekCalendarSwipe(swipe):
                switch swipe {
                case .next:
                    guard let nextWeekDate = TXCalendarUtil.dateByAddingWeek(
                        from: state.calendarDate,
                        by: 1
                    ) else {
                        return .none
                    }
                    return .send(.setCalendarDate(nextWeekDate))

                case .previous:
                    guard let previousWeekDate = TXCalendarUtil.dateByAddingWeek(
                        from: state.calendarDate,
                        by: -1
                    ) else {
                        return .none
                    }
                    return .send(.setCalendarDate(previousWeekDate))
                }
                
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
                    
                    // FIXME: - 통계 나오기 전까지 토스트 띄움
                    let isPast = TXCalendarUtil.isEarlier(state.calendarDate, than: TXCalendarDate())
                    if isPast {
                        state.toast = .warning(message: "과거의 것은 수정 불가능합니다.")
                    } else {
                        return .send(.delegate(.goToGoalEdit(goalId: card.id)))
                    }
                    
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
                guard !state.isLoading,
                      let goalId = state.pendingGoalId,
                      let pendingAction = state.pendingAction else {
                    return .none
                }

                state.isLoading = true
                state.modal = nil
                
                switch pendingAction {
                case .complete:
                    return .run { send in
                        do {
                            _ = try await goalClient.completeGoal(goalId)
                            await send(.completeGoalCompleted(goalId: goalId))
                        } catch {
                            await send(.apiError("이미 끝났습니다."))
                        }
                    }
                    
                case .delete:
                    return .run { send in
                        do {
                            try await goalClient.deleteGoal(goalId)
                            await send(.deleteGoalCompleted(goalId: goalId))
                        } catch {
                            // FIXME: - 통계 나오기 전까지 토스트 띄움
                            await send(.apiError("목표 삭제에 실패했어요"))
                        }
                    }
                }
                
                // MARK: - Update State
            case let .setCalendarDate(date):
                if date == state.calendarDate {
                    return .none
                }
                state.calendarDate = date
                state.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
                state.isLoading = true
                return .send(.fetchGoals)
                
            case .fetchGoals:
                state.isLoading = true
                let date = state.calendarDate
                return .run { send in
                    do {
                        let items = try await goalClient.fetchGoalEditList(TXCalendarUtil.apiDateString(for: date))
                        let editItems = items.map {
                            GoalEditCardItem(
                                id: $0.id,
                                goalName: $0.title,
                                iconImage: $0.goalIcon.image,
                                repeatCycle: $0.repeatCycle?.text ?? "",
                                startDate: $0.startDate ?? "",
                                endDate: $0.endDate ?? "미설정"
                            )
                        }
                        await send(.fetchGoalsCompleted(editItems, date: date))
                    } catch {
                        await send(.apiError("목표 조회에 실패했어요"))
                    }
                }

            case let .fetchGoalsCompleted(items, date):
                if date != state.calendarDate {
                    return .none
                }
                state.isLoading = false
                if state.cards != items {
                    state.cards = items
                }
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
