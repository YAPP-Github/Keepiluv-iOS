//
//  GaolDetailReducer.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/21/26.
//

import Foundation

import ComposableArchitecture
import CoreCaptureSessionInterface
import DomainGoalInterface
import FeatureGoalDetailInterface
import FeatureProofPhotoInterface
import SharedDesignSystem

extension GoalDetailReducer {
    // swiftlint: disable function_body_length
    public init(
        proofPhotoReducer: ProofPhotoReducer
    ) {
        @Dependency(\.captureSessionClient) var captureSessionClient
        @Dependency(\.goalClient) var goalClient
        
        // swiftlint: disable closure_body_length
        let reducer = Reduce<GoalDetailReducer.State, GoalDetailReducer.Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                return .run { send in
                    let item = try await goalClient.fetchGoalDetail()
                    await send(.fethedGoalDetailItem(item))
                }
                
                // MARK: - Action
            case .bottomButtonTapped:
                if case .mySelf = state.currentUser,
                   !state.isCompleted {
                    return .run { send in
                        let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                        await send(.authorizationCompleted(isAuthorized: isAuthorized))
                    }
                }
                return .none
                
            case let .navigationBarTapped(action):
                if case .backTapped = action {
                    return .send(.path(.pop))
                } else if case .rightTapped = action {
                    if state.isEditing {
                        // TODO: - post api
                        state.isEditing = false
                    } else {
                        state.isEditing = true
                    }
                }
                return .none
                
            case let .reactionEmojiTapped(index):
                state.selectedReactionIndex = index
                return .none
                
            case .cardTapped:
                state.currentUser = state.currentUser == .mySelf ? .you : .mySelf
                return .none
                
                // MARK: - State Update
            case let .fethedGoalDetailItem(item):
                state.item = item
                return .none
                
            case let .authorizationCompleted(isAuthorized):
                // TODO: - 권한 해제시 alert 띄워서 아이폰 설정으로 보내기
                guard isAuthorized else { return .none }
                state.isPresentedProofPhoto = true
                state.proofPhoto = ProofPhotoReducer.State()
                
                return .none
                
                // MARK: - Reducer
            case .proofPhoto(.delegate(.closeProofPhoto)):
                state.isPresentedProofPhoto = false
                return .none
                
            case let .proofPhoto(.delegate(.completedUploadPhoto(completedGoal))):
                state.item?.completedGoal[0] = completedGoal
                state.isPresentedProofPhoto = false
                return .none
                
            case .proofPhotoDismissed:
                state.proofPhoto = nil
                return .none
                
            case .proofPhoto:
                return .none
                
            case .binding:
                return .none
                
            case .path:
                return .none
            }
        }
        // swiftlint: enable closure_body_length
        self.init(
            reducer: reducer,
            proofPhotoReducer: proofPhotoReducer
        )
    }
    // swiftlint: enable function_body_length
}
