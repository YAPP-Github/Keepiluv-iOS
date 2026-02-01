//
//  MakeGoalReducer+Impl.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture
import FeatureHomeInterface

extension MakeGoalReducer {
    public init() {
        let reducer = Reduce<State, Action> { state, action in
            return .none
        }
        
        self.init(reducer: reducer)
    }
}
