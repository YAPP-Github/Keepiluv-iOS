//
//  RootHomeReducer+Impl.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/27/26.
//

import ComposableArchitecture
import FeatureHomeInterface

extension RootHomeReducer {
    public init() {
        let reducer = Reduce<State, Action> { state, action in
            switch action {
                
            case .home:
                return .none
                
            case .binding:
                return .none
            }
        }

        self.init(
            reducer: reducer,
            homeReducer: HomeReducer(),
        )
    }
}
