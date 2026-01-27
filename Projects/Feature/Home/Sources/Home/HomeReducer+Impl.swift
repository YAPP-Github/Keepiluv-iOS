//
//  HomeReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureHomeInterface
import SharedDesignSystem

extension HomeReducer {
    /// 실제 로직을 포함한 HomeReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeReducer()
    /// ```
    public init() {
        @Dependency(\.goalClient) var goalClient
        
        let reducer = Reduce<State, Action> { state, action in
            
            switch action {
            // MARK: - Life Cycle
            case .onAppear:
                return .run { send in
                    let myGoals = try await goalClient.fetchGoals()
                    let yourGoals = try await goalClient.fetchGoals().shuffled()
                    
                    let items = zip(myGoals, yourGoals).map { myGoal, yourGoal in
                        GoalCardItem(
                            id: myGoal.id,
                            goalName: myGoal.title,
                            goalEmoji: myGoal.goalIcon,
                            myCard: .init(
                                image: myGoal.image,
                                emoji: myGoal.emoji,
                                isSelected: myGoal.isCompleted
                            ),
                            yourCard: .init(
                                image: yourGoal.image,
                                emoji: yourGoal.emoji,
                                isSelected: yourGoal.isCompleted
                            )
                        )
                    }
                    
                    await send(.fetchGoalsCompleted(items))
                }
            
            // MARK: - Update State
            case let .fetchGoalsCompleted(items):
                state.isLoading = false
                state.cards = items
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
