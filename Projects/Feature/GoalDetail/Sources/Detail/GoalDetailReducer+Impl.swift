//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation

import ComposableArchitecture
import FeatureGoalDetailInterface

extension GoalDetailReducer {
    public init() {
        let reducer = Reduce<GoalDetailReducer.State, GoalDetailReducer.Action> { state, action in
            return .none
        }
        
        self.init(reducer: reducer)
    }
}
