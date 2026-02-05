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
                
                // MARK: - Update State
            case let .fetchGoalsCompleted(items):
                state.cards = items
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
