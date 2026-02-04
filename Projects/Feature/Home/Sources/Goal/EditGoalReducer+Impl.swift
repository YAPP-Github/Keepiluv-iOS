//
//  EditGoalReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

import ComposableArchitecture
import FeatureHomeInterface

extension EditGoalReducer {
    public init() {
        let reducer = Reduce<State, Action> { state, action in
            return .none
        }
        
        self.init(reducer: reducer)
    }
}
