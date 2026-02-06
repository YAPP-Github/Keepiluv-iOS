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
    /// 실제 로직을 포함한 GoalDetailReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = GoalDetailReducer(
    ///     proofPhotoReducer: ProofPhotoReducer()
    /// )
    /// ```
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
                
            case .onDisappear:
                return .none
                
                // MARK: - Action
            case .bottomButtonTapped:
                let shouldGoToProofPhoto = (state.currentUser == .mySelf && !state.isCompleted) || state.isEditing
                if shouldGoToProofPhoto {
                    return .run { send in
                        let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                        await send(.authorizationCompleted(isAuthorized: isAuthorized))
                    }
                }
                return .none
                
            case let .navigationBarTapped(action):
                if case .backTapped = action {
                    return .send(.delegate(.navigateBack))
                } else if case .rightTapped = action {
                    if state.isEditing {
                        // TODO: - post api
                        state.isEditing = false
                        state.isCommentFocused = false
                        var newItem = state.item?.completedGoal[0]
                        newItem?.comment = state.commentText
                        
                        guard let newItem else { return .none }
                        state.item?.completedGoal[0] = newItem 
                    } else {
                        state.isEditing = true
                        state.commentText = state.comment
                    }
                }
                return .none
                
            case let .reactionEmojiTapped(index):
                state.selectedReactionIndex = index
                return .none
                
            case .cardTapped:
                state.currentUser = state.currentUser == .mySelf ? .you : .mySelf
                state.commentText = state.comment
                state.isCommentFocused = false
                return .none
                
            case let .focusChanged(isFocused):
                state.isCommentFocused = isFocused
                return .none
                
            case .dimmedBackgroundTapped:
                state.isCommentFocused = false
                return .none
                
                // MARK: - State Update
            case let .fethedGoalDetailItem(item):
                state.item = item
                state.commentText = item.completedGoal.first?.comment ?? ""
                return .none
                
            case let .authorizationCompleted(isAuthorized):
                if !isAuthorized {
                    state.isCameraPermissionAlertPresented = true
                    return .none
                }
                state.isPresentedProofPhoto = true
                guard let goalId = Int(state.item?.id ?? "") else { return .none }
                
                state.proofPhoto = ProofPhotoReducer.State(
                    goalId: goalId,
                    comment: state.comment
                )
                
                return .none
                
            case .cameraPermissionAlertDismissed:
                state.isCameraPermissionAlertPresented = false
                return .none
                
                // MARK: - Child Action
            case .proofPhoto(.delegate(.closeProofPhoto)):
                state.isPresentedProofPhoto = false
                return .none
                
            case let .proofPhoto(.delegate(.completedUploadPhoto(completedGoal))):
                state.item?.completedGoal[0] = completedGoal
                state.commentText = completedGoal.comment
                state.isPresentedProofPhoto = false
                return .none
                
            case .proofPhotoDismissed:
                state.proofPhoto = nil
                return .none
                
            case .proofPhoto:
                return .none
                
            case .binding:
                return .none
                
            case .delegate:
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
