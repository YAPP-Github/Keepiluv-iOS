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
                return .run { [calendarDate = state.calendarDate] send in
                    let goals = try await goalClient.fetchGoals(TXCalendarUtil.apiDateString(for: calendarDate))
                    let items = goals.map { goal in
                        // FIXME: - Goal Entity 변경
                        GoalEditCardItem(
                            id: String(goal.id),
                            goalName: goal.title,
                            iconImage: goal.goalIcon.image,
                            repeatCycle: "미정",
                            startDate: "-",
                            endDate: "미설정"
                        )
                    }
                    await send(.fetchGoalsCompleted(items))
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
                    // TODO: - API연동할 때 MakeGoalItem 넘기기
                    return .send(.delegate(.goToGoalEdit))
                    
                case .finish:
                    state.modal = .info(.finishGoal(for: card))
                    
                case .delete:
                    state.modal = .info(.editDeleteGoal(for: card))
                }
                
                state.selectedCardMenu = nil
                return .none
                
            case .backgroundTapped:
                state.selectedCardMenu = nil
                return .none
                
            case .modalConfirmTapped:
                // TODO: - finish API
                return .none
                
                // MARK: - Update State
            case let .setCalendarDate(date):
                state.calendarDate = date
                state.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: date)
                return .none
                
            case let .fetchGoalsCompleted(items):
                state.cards = items
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
