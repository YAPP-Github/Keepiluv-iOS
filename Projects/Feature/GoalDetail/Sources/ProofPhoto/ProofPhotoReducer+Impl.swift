//
//  ProofPhotoReducer+Impl.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/22/26.
//

import ComposableArchitecture
import FeatureGoalDetailInterface

extension ProofPhotoReducer {
    public init() {
        let reducer = Reduce<ProofPhotoReducer.State, ProofPhotoReducer.Action> { _, _ in
            return .none
        }

        self.init(reducer: reducer)
    }
}
