//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation

import ComposableArchitecture
import CoreCaptureSessionInterface
import FeatureGoalDetailInterface
import SharedDesignSystem

extension GoalDetailReducer {
    public init() {
        @Dependency(\.captureSessionClient) var captureSessionClient

        let reducer = Reduce<GoalDetailReducer.State, GoalDetailReducer.Action> { state, action in
            switch action {
            // MARK: - Action
            case .bottomButtonTapped:
                if case .pending = state.status {
                    switch state.currentUser {
                    case .me:
                        return .run { send in
                            let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                            await send(.authorizationCompleted(isAuthorized: isAuthorized))
                        }
                        
                    case .you:
                        return .none
                    }
                }
                return .none

            // MARK: - State Update
            case let .authorizationCompleted(isAuthorized):
                // TODO: - 권한 해제시 alert 띄워서 아이폰 설정으로 보내기
                guard isAuthorized else { return .none }
                state.isPresentedProofPhoto = true
                state.proofPhoto = ProofPhotoReducer.State(
                    galleryThumbnail:
                        SharedDesignSystemAsset.ImageAssets.girl.swiftUIImage
                )
                
                return .none
                
            case let .setProofPhotoPresented(isPresented):
                state.isPresentedProofPhoto = isPresented
                if !isPresented {
                    state.proofPhoto = nil
                }
                return .none
                
            // MARK: - Reducer
            case .proofPhoto(.delegate(.closeProofPhoto)):
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
