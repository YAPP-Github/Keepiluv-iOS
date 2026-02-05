//
//  EditGoalReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureHomeInterface
import SharedDesignSystem

extension EditGoalReducer {
    /// 실제 로직을 포함한 EditGoalReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = EditGoalReducer()
    /// ```
    // swiftlint:disable:next function_body_length
    public init() {
        @Dependency(\.goalClient) var goalClient
        
        // swiftlint:disable:next closure_body_length
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .run { send in
                    let goals = try await goalClient.fetchGoals()
                    let items = goals.map { goal in
                        // FIXME: - Goal Entity 변경
                        GoalEditCardItem(
                            id: goal.id,
                            goalName: goal.title,
                            iconImage: goal.goalIcon,
                            repeatCycle: "미정",
                            startDate: "-",
                            endDate: "미설정"
                        )
                    }
                    await send(.fetchGoalsCompleted(items))
                }
                
            case .onDisappear:
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
            }
        }
        
        self.init(reducer: reducer)
    }
}
