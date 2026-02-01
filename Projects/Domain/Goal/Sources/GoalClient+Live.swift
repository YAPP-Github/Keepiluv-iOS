//
//  GoalClient+Live.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import ComposableArchitecture
import DomainGoalInterface

extension GoalClient: @retroactive DependencyKey {
    /// GoalClient의 기본 구현입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// @Dependency(\.goalClient) var goalClient
    /// let goals = try await goalClient.fetchGoals()
    /// ```
    public static var liveValue: GoalClient = Self(
        fetchGoals: {
            return []
        }, fetchGoalDetail: {
            return GoalDetail(id: "", title: "", completedGoal: [])
        }
    )
    
}
