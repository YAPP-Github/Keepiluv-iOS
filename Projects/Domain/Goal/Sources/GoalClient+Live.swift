//
//  GoalClient+Live.swift
//  DomainGoalInterface
//
//  Created by 정지훈 on 1/26/26.
//

import ComposableArchitecture
import DomainGoalInterface

extension GoalClient: @retroactive DependencyKey {
    public static var liveValue: GoalClient = Self(
        fetchGoals: {
            return []
        }
    )
    
}
