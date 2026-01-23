//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation

import ComposableArchitecture
import FeatureGoalDetailInterface
import SharedDesignSystem

extension GoalDetailReducer {
    public init() {
        let reducer = Reduce<GoalDetailReducer.State, GoalDetailReducer.Action> { state, action in
            switch action {
            case .bottomButtonTapped:
                if case .pending = state.status {
                    switch state.currentUser {
                    case .me:
                        state.isPresentedProofPhoto = true
                        state.proofPhoto = ProofPhotoReducer.State(
                            galleryThumbnail:
                                SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage
                        )
                        
                    case .you:
                        return .none
                    }
                }
                return .none
                
            case let .setProofPhotoPresented(isPresented):
                state.isPresentedProofPhoto = isPresented
                if !isPresented {
                    state.proofPhoto = nil
                }
                return .none
                
            case .proofPhoto(.closeButtonTapped):
                state.isPresentedProofPhoto = false
                return .none
                
            case .proofPhoto:
                return .none
                
            case .binding(_):
                return .none
            }
        }

        self.init(
            reducer: reducer,
            proofPhotoReducer: ProofPhotoReducer()
        )
    }
}
