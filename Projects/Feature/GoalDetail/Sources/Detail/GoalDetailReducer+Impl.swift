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

private enum PokeCooldownManager {
    private static let userDefaultsKey = "pokeCooldownTimestamps"
    private static let cooldownInterval: TimeInterval = 3 * 60 * 60

    static func remainingCooldown(goalId: Int64) -> TimeInterval? {
        guard let timestamps = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: TimeInterval],
              let lastPokeTime = timestamps[String(goalId)] else {
            return nil
        }
        let elapsed = Date().timeIntervalSince1970 - lastPokeTime
        let remaining = cooldownInterval - elapsed
        return remaining > 0 ? remaining : nil
    }

    static func formatRemainingTime(_ seconds: TimeInterval) -> String {
        let totalMinutes = Int(ceil(seconds / 60))
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(max(1, minutes))분"
        }
    }

    static func recordPoke(goalId: Int64) {
        var timestamps = UserDefaults.standard.dictionary(forKey: userDefaultsKey) as? [String: TimeInterval] ?? [:]
        timestamps[String(goalId)] = Date().timeIntervalSince1970
        UserDefaults.standard.set(timestamps, forKey: userDefaultsKey)
    }
}

extension GoalDetailReducer {
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

        let reducer = Reduce<GoalDetailReducer.State, GoalDetailReducer.Action> { state, action in
            switch action {
            case .view(let viewAction):
                return reduceView(
                    state: &state,
                    action: viewAction,
                    captureSessionClient: captureSessionClient,
                    goalClient: goalClient,
                    photoLogClient: photoLogClient,
                    timeFormatter: timeFormatter
                )

            case .internal(let internalAction):
                return reduceInternal(
                    state: &state,
                    action: internalAction,
                    goalClient: goalClient,
                    photoLogClient: photoLogClient,
                    timeFormatter: timeFormatter
                )

            case .response(let responseAction):
                return reduceResponse(
                    state: &state,
                    action: responseAction,
                    timeFormatter: timeFormatter
                )

            case .presentation(let presentationAction):
                return reducePresentation(state: &state, action: presentationAction)

            case .proofPhoto(.delegate(.closeProofPhoto)):
                state.presentation.isPresentedProofPhoto = false
                return .none

            case let .proofPhoto(.delegate(.completedUploadPhoto(myPhotoLog, editedImageData))):
                state.presentation.isPresentedProofPhoto = false
                state.data.pendingEditedImageData = editedImageData
                var myPhotoLog = myPhotoLog
                myPhotoLog.goalName = state.goalName
                myPhotoLog.photologId = state.currentCard?.photologId
                return .none

            case .proofPhoto:
                return .none

            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }

        self.init(
            reducer: reducer,
            proofPhotoReducer: proofPhotoReducer
        )
    }
}

// MARK: - View

// swiftlint:disable:next function_body_length
private func reduceView(
    state: inout GoalDetailReducer.State,
    action: GoalDetailReducer.Action.View,
    captureSessionClient: CaptureSessionClient,
    goalClient: GoalClient,
    photoLogClient: PhotoLogClient,
    timeFormatter: RelativeTimeFormatter
) -> Effect<GoalDetailReducer.Action> {
    switch action {
    case .bottomButtonTapped:
        let shouldGoToProofPhoto = (state.data.currentUser == .mySelf && !state.isCompleted) || state.ui.isEditing
        if shouldGoToProofPhoto {
            return .run { send in
                let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                await send(.response(.authorizationCompleted(isAuthorized: isAuthorized)))
            }
        }
        guard state.data.currentUser == .you, !state.isCompleted else { return .none }
        let goalId = state.currentGoalId
        if let remaining = PokeCooldownManager.remainingCooldown(goalId: goalId) {
            let timeText = PokeCooldownManager.formatRemainingTime(remaining)
            return .send(.presentation(.showToast(.warning(message: "\(timeText) 뒤에 다시 찌를 수 있어요"))))
        }
        return .run { send in
            do {
                try await goalClient.pokePartner(goalId)
                PokeCooldownManager.recordPoke(goalId: goalId)
                await send(.presentation(.showToast(.poke(message: "상대방을 찔렀어요!"))))
            } catch {
                await send(.presentation(.showToast(.warning(message: "찌르기에 실패했어요"))))
            }
        }

    case let .navigationBarTapped(action):
        if case .backTapped = action {
            return .send(.delegate(.navigateBack))
        } else if case .rightTapped = action {
            if state.ui.isEditing {
                return .send(.internal(.updatePhotoLog))
            } else {
                state.ui.isEditing = true
                state.data.commentText = state.comment
            }
        }
        return .none

    case let .reactionEmojiTapped(reactionEmoji):
        guard state.data.currentUser == .you else { return .none }
        guard state.data.selectedReactionEmoji != reactionEmoji else { return .none }
        guard let photoLogId = state.currentCard?.photologId else { return .none }
        let previousReaction = state.currentCard?.reaction
        state.data.selectedReactionEmoji = reactionEmoji
        return .concatenate(
            .send(.response(.updateCurrentCardReaction(reactionEmoji.rawValue))),
            .run { send in
                do {
                    let request = PhotoLogUpdateReactionRequestDTO(reaction: reactionEmoji.rawValue)
                    _ = try await photoLogClient.updateReaction(photoLogId, request)
                } catch {
                    await send(.response(.reactionUpdateFailed(previousReaction: previousReaction)))
                }
            }
        )

    case .cardSwiped:
        state.ui.isSwapped.toggle()
        state.data.currentUser = state.data.currentUser == .mySelf ? .you : .mySelf
        state.data.commentText = state.comment
        state.data.selectedReactionEmoji = state.currentCard?.reaction.flatMap(ReactionEmoji.init(from:))
        return .send(.response(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt))))

    case let .focusChanged(isFocused):
        state.ui.isCommentFocused = isFocused
        return .none

    case .dimmedBackgroundTapped:
        state.ui.isCommentFocused = false
        return .none

    case .proofPhotoDismissed:
        state.presentation.proofPhoto = nil
        return .none

    case .cameraPermissionAlertDismissed:
        state.presentation.isCameraPermissionAlertPresented = false
        return .none
    }
}

// MARK: - Internal

// swiftlint:disable:next function_body_length
private func reduceInternal(
    state: inout GoalDetailReducer.State,
    action: GoalDetailReducer.Action.Internal,
    goalClient: GoalClient,
    photoLogClient: PhotoLogClient,
    timeFormatter: RelativeTimeFormatter
) -> Effect<GoalDetailReducer.Action> {
    switch action {
    case .onAppear:
        let date = state.data.verificationDate
        let goalId = state.data.goalId

        return .run { send in
            do {
                let item = try await goalClient.fetchGoalDetail(date, goalId)
                await send(.response(.fethedGoalDetailItem(item)))
            } catch {
                await send(.response(.fetchGoalDetailFailed))
            }
        }

    case .onDisappear:
        return .none

    case let .updateMyPhotoLog(myPhotoLog):
        guard let item = state.data.item else { return .none }

        let targetGoalId = myPhotoLog.goalId
        var updatedCompletedGoals = item.completedGoals

        if let index = updatedCompletedGoals.firstIndex(where: { card in
            guard let card else { return false }
            return card.myPhotoLog?.goalId == targetGoalId || card.yourPhotoLog?.goalId == targetGoalId
        }) {
            let existing = updatedCompletedGoals[index]
            updatedCompletedGoals[index] = GoalDetail.CompletedGoal(
                goalName: existing?.goalName ?? myPhotoLog.goalName ?? "",
                myPhotoLog: myPhotoLog,
                yourPhotoLog: existing?.yourPhotoLog
            )
        } else {
            updatedCompletedGoals.append(
                GoalDetail.CompletedGoal(
                    goalName: myPhotoLog.goalName ?? "",
                    myPhotoLog: myPhotoLog,
                    yourPhotoLog: nil
                )
            )
        }

        state.data.item = GoalDetail(
            partnerNickname: item.partnerNickname,
            completedGoals: updatedCompletedGoals
        )

        state.data.commentText = state.comment
        state.data.selectedReactionEmoji = state.currentCard?.reaction.flatMap(ReactionEmoji.init(from:))
        return .send(.response(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt))))

    case .updatePhotoLog:
        if let current = state.currentCard, state.data.currentUser == .mySelf {
            guard let photologId = current.photologId else { return .none }
            let pendingEditedImageData = state.data.pendingEditedImageData
            let comment = state.data.commentText
            let goalId = state.currentGoalId
            let isCommentChanged = comment != current.comment
            let isImageChanged = pendingEditedImageData != nil
            if !isCommentChanged && !isImageChanged {
                state.ui.isEditing = false
                return .none
            }
            state.ui.isSavingPhotoLog = true

            return .run { send in
                do {
                    var fileName: String
                    if let pendingEditedImageData {
                        let optimizedImageData = ImageUploadOptimizer.optimizedJPEGData(
                            from: pendingEditedImageData
                        )
                        let uploadResponse = try await photoLogClient.fetchUploadURL(goalId)
                        try await photoLogClient.uploadImageData(
                            optimizedImageData,
                            uploadResponse.uploadUrl
                        )
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
                    await send(.binding(.set(\.ui.isEditing, false)))
                    await send(.binding(.set(\.ui.isSavingPhotoLog, false)))
                } catch {
                    await send(.binding(.set(\.ui.isSavingPhotoLog, false)))
                    await send(.presentation(.showToast(.warning(message: "인증샷 수정에 실패했어요"))))
                }
            }
        }
        return .none
    }
}

// MARK: - Response

private func reduceResponse(
    state: inout GoalDetailReducer.State,
    action: GoalDetailReducer.Action.Response,
    timeFormatter: RelativeTimeFormatter
) -> Effect<GoalDetailReducer.Action> {
    switch action {
    case let .fethedGoalDetailItem(item):
        state.data.item = item
        if let goalIndex = state.completedGoalItems.firstIndex(where: {
            $0.myPhotoLog?.goalId == state.data.goalId || $0.yourPhotoLog?.goalId == state.data.goalId
        }) {
            state.data.currentGoalIndex = goalIndex
        } else {
            state.data.currentGoalIndex = 0
        }
        state.data.commentText = state.comment
        state.data.selectedReactionEmoji = state.currentCard?.reaction.flatMap(ReactionEmoji.init(from:))
        return .send(.response(.setCreatedAt(timeFormatter.displayText(from: state.currentCard?.createdAt))))

    case .fetchGoalDetailFailed:
        return .send(.presentation(.showToast(.warning(message: "목표 상세 조회에 실패했어요"))))

    case let .updateCurrentCardReaction(reaction):
        guard state.data.currentUser == .you else { return .none }
        guard let item = state.data.item else { return .none }
        let targetGoalId = state.currentGoalId
        var updatedCompletedGoals = item.completedGoals

        guard let index = updatedCompletedGoals.firstIndex(where: { goal in
            guard let goal else { return false }
            return goal.myPhotoLog?.goalId == targetGoalId || goal.yourPhotoLog?.goalId == targetGoalId
        }) else { return .none }
        guard let currentGoal = updatedCompletedGoals[index] else { return .none }

        guard var yourPhotoLog = currentGoal.yourPhotoLog else { return .none }
        yourPhotoLog.reaction = reaction
        updatedCompletedGoals[index] = GoalDetail.CompletedGoal(
            goalName: currentGoal.goalName,
            myPhotoLog: currentGoal.myPhotoLog,
            yourPhotoLog: yourPhotoLog
        )

        state.data.item = GoalDetail(
            partnerNickname: item.partnerNickname,
            completedGoals: updatedCompletedGoals
        )
        return .none

    case let .reactionUpdateFailed(previousReaction):
        state.data.selectedReactionEmoji = previousReaction.flatMap(ReactionEmoji.init(from:))
        return .send(.presentation(.showToast(.warning(message: "리액션 전송에 실패했어요"))))

    case let .setCreatedAt(text):
        state.data.createdAt = text
        return .none

    case let .authorizationCompleted(isAuthorized):
        if !isAuthorized {
            state.presentation.isCameraPermissionAlertPresented = true
            return .none
        }
        state.presentation.isPresentedProofPhoto = true
        state.presentation.proofPhoto = ProofPhotoReducer.State(
            goalId: state.currentGoalId,
            comment: state.ui.isEditing ? state.data.commentText : state.comment,
            verificationDate: state.data.verificationDate,
            isEditing: state.ui.isEditing
        )
        return .none
    }
}

// MARK: - Presentation

private func reducePresentation(
    state: inout GoalDetailReducer.State,
    action: GoalDetailReducer.Action.Presentation
) -> Effect<GoalDetailReducer.Action> {
    switch action {
    case let .showToast(toast):
        state.presentation.toast = toast
        return .none
    }
}
