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
import DomainPhotoLogInterface
import FeatureGoalDetailInterface
import FeatureProofPhotoInterface
import SharedDesignSystem
import SharedUtil

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
        @Dependency(\.photoLogClient) var photoLogClient
        let timeFormatter = RelativeTimeFormatter()
        
        // swiftlint: disable closure_body_length
        let reducer = Reduce<GoalDetailReducer.State, GoalDetailReducer.Action> { state, action in
            switch action {
                // MARK: - LifeCycle
            case .onAppear:
                let date = state.verificationDate

                return .run { send in
                    do {
                        let item = try await goalClient.fetchGoalDetailList(date)
                        await send(.fethedGoalDetailItem(item))
                    } catch {
                        await send(.fetchGoalDetailFailed)
                    }
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
                        return .send(.updatePhotoLog)
                    } else {
                        state.isEditing = true
                        state.commentText = state.comment
                    }
                }
                return .none
                
            case let .reactionEmojiTapped(reactionEmoji):
                guard state.selectedReactionEmoji != reactionEmoji else { return .none }
                guard let photoLogId = state.currentCard?.photologId else { return .none }
                state.selectedReactionEmoji = reactionEmoji
                return .run { send in
                    do {
                        let request = PhotoLogUpdateReactionRequestDTO(reaction: reactionEmoji.rawValue)
                        _ = try await photoLogClient.updateReaction(photoLogId, request)
                    } catch {
                        await send(.showToast(.warning(message: "리액션 전송에 실패했어요")))
                    }
                }
                
            case .cardTapped:
                state.currentUser = state.currentUser == .mySelf ? .you : .mySelf
                state.commentText = state.comment
                state.isCommentFocused = false
                state.selectedReactionEmoji = ReactionEmoji(rawValue: state.currentCard?.reaction?.rawValue ?? "")
                return .send(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt)))
                
            case .cardSwipedUp:
                let nextIndex = state.currentGoalIndex + 1
                guard nextIndex < state.completedGoalItems.count else { return .none }
                state.currentGoalIndex = nextIndex
                state.commentText = state.comment
                state.isCommentFocused = false
                state.selectedReactionEmoji = ReactionEmoji(rawValue: state.currentCard?.reaction?.rawValue ?? "")
                return .send(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt)))
                
            case .cardSwipedDown:
                guard state.currentGoalIndex > 0 else { return .none }
                state.currentGoalIndex -= 1
                state.commentText = state.comment
                state.isCommentFocused = false
                state.selectedReactionEmoji = ReactionEmoji(rawValue: state.currentCard?.reaction?.rawValue ?? "")
                return .send(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt)))
                
            case let .focusChanged(isFocused):
                state.isCommentFocused = isFocused
                return .none
                
            case .dimmedBackgroundTapped:
                state.isCommentFocused = false
                return .none
                
                // MARK: - State Update
            case let .fethedGoalDetailItem(item):
                state.item = item
                if let goalIndex = state.completedGoalItems.firstIndex(where: {
                    $0.myPhotoLog?.goalId == state.goalId || $0.yourPhotoLog?.goalId == state.goalId
                }) {
                    state.currentGoalIndex = goalIndex
                } else {
                    state.currentGoalIndex = 0
                }
                state.commentText = state.comment
                state.selectedReactionEmoji = ReactionEmoji(rawValue: state.currentCard?.reaction?.rawValue ?? "")
                return .send(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt)))

            case .fetchGoalDetailFailed:
                return .send(.showToast(.warning(message: "목표 상세 조회에 실패했어요")))

            case let .showToast(toast):
                state.toast = toast
                return .none
                
            case let .setCreatedAt(text):
                state.createdAt = text
                return .none
                
            case let .authorizationCompleted(isAuthorized):
                if !isAuthorized {
                    state.isCameraPermissionAlertPresented = true
                    return .none
                }
                state.isPresentedProofPhoto = true
                state.proofPhoto = ProofPhotoReducer.State(
                    goalId: state.currentGoalId,
                    comment: state.isEditing ? state.commentText : state.comment,
                    verificationDate: state.verificationDate,
                    isEditing: state.isEditing
                )
                
                return .none
                
            case .cameraPermissionAlertDismissed:
                state.isCameraPermissionAlertPresented = false
                return .none
                
            case .updatePhotoLog:
                if let current = state.currentCard, state.currentUser == .mySelf {
                    guard let photologId = current.photologId else { return .none }
                    let pendingEditedImageData = state.pendingEditedImageData
                    let comment = state.commentText
                    let goalId = state.currentGoalId
                    
                    return .run { send in
                        do {
                            var fileName: String
                            if let pendingEditedImageData {
                                let uploadResponse = try await photoLogClient.fetchUploadURL(goalId)
                                try await photoLogClient.uploadImageData(pendingEditedImageData, uploadResponse.uploadUrl)
                                fileName = uploadResponse.fileName
                            } else {
                                let imageURLString = current.imageUrl ?? ""
                                fileName = URL(string: imageURLString)?.lastPathComponent ?? imageURLString
                            }

                            let request = PhotoLogUpdateRequestDTO(
                                fileName: fileName,
                                comment: comment
                            )
                            try await photoLogClient.updatePhotoLog(photologId, request)
                            await send(.binding(.set(\.isEditing, false)))
                        } catch {
                            await send(.showToast(.warning(message: "인증샷 수정에 실패했어요")))
                        }
                    }
                }
                
                return .none
                
                // MARK: - Child Action
            case .proofPhoto(.delegate(.closeProofPhoto)):
                state.isPresentedProofPhoto = false
                return .none
                
            case let .proofPhoto(.delegate(.completedUploadPhoto(myPhotoLog, editedImageData: editedImageData))):
                state.isPresentedProofPhoto = false
                state.pendingEditedImageData = editedImageData
                var myPhotoLog = myPhotoLog
                myPhotoLog.goalName = state.goalName
                myPhotoLog.photologId = state.currentCard?.photologId
                
                return .none
                
            case .proofPhotoDismissed:
                state.proofPhoto = nil
                return .none

            case let .updateMyPhotoLog(myPhotoLog):
                guard let item = state.item else { return .none }

                let targetGoalId = myPhotoLog.goalId
                var updatedCompletedGoals = item.completedGoals
                
                if let index = updatedCompletedGoals.firstIndex(where: { card in
                    guard let card else { return false }
                    return card.myPhotoLog?.goalId == targetGoalId || card.yourPhotoLog?.goalId == targetGoalId
                }) {
                    let existing = updatedCompletedGoals[index]
                    updatedCompletedGoals[index] = GoalDetail.CompletedGoal(
                        myPhotoLog: myPhotoLog,
                        yourPhotoLog: existing?.yourPhotoLog
                    )
                } else {
                    updatedCompletedGoals.append(
                        GoalDetail.CompletedGoal(
                            myPhotoLog: myPhotoLog,
                            yourPhotoLog: nil
                        )
                    )
                }
                
                state.item = GoalDetail(
                    partnerNickname: item.partnerNickname,
                    completedGoals: updatedCompletedGoals
                )
                
                state.commentText = state.comment
                state.selectedReactionEmoji = ReactionEmoji(rawValue: state.currentCard?.reaction?.rawValue ?? "")
                return .send(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt)))
                
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
