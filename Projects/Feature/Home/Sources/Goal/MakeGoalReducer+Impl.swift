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
            switch action {
            case .binding:
                return .none

            case .emojiButtonTapped:
                return .none

            case .periodSelected:
                return .none

            case .startDateTapped:
                return .none

            case .endDateTapped:
                return .none

            case .completeButtonTapped:
                return .none
            }
        }
        
        self.init(reducer: reducer)
    }
}
