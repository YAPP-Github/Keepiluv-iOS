//
//  ProofPhotoReducer+Impl.swift
//  FeatureProofPhoto
//
//  Created by 정지훈 on 1/22/26.
//

import AVFoundation
import ComposableArchitecture
import CoreCaptureSessionInterface
import DomainGoalInterface
import DomainPhotoLogInterface
import FeatureProofPhotoInterface
import PhotosUI
import SharedDesignSystem
import SharedUtil

extension ProofPhotoReducer {
    /// 실제 로직을 포함한 ProofPhotoReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = ProofPhotoReducer()
    /// ```
    public init() {
        @Dependency(\.captureSessionClient) var captureSessionClient
        @Dependency(\.photoLogClient) var photoLogClient

        let reducer = Reduce<ProofPhotoReducer.State, ProofPhotoReducer.Action> { state, action in
            switch action {
            case .view(let viewAction):
                return reduceView(
                    state: &state,
                    action: viewAction,
                    captureSessionClient: captureSessionClient,
                    photoLogClient: photoLogClient
                )

            case .internal(let internalAction):
                return reduceInternal(state: &state, action: internalAction)

            case .presentation(let presentationAction):
                return reducePresentation(state: &state, action: presentationAction)

            case .binding(\.data.selectedPhotoItem):
                guard let selectedPhotoItem = state.data.selectedPhotoItem else {
                    state.data.imageData = nil
                    return .none
                }

                return .run { send in
                    if let imageData = try? await selectedPhotoItem.loadTransferable(type: Data.self) {
                        await send(.internal(.galleryPhotoLoaded(imageData: imageData)))
                        captureSessionClient.stopRunning()
                    }
                }

            case .binding:
                return .none

            case .delegate:
                return .none
            }
        }

        self.init(reducer: reducer)
    }
}

// MARK: - View

private func reduceView(
    state: inout ProofPhotoReducer.State,
    action: ProofPhotoReducer.Action.View,
    captureSessionClient: CaptureSessionClient,
    photoLogClient: PhotoLogClient
) -> Effect<ProofPhotoReducer.Action> {
    switch action {
    case .onAppear:
        return .run { [isFlashOn = state.ui.isFlashOn] send in
            captureSessionClient.setFlashEnabled(isFlashOn)
            let session = await captureSessionClient.setUpCaptureSession(.back)
            await send(.internal(.setupCaptureSessionCompleted(session: session)))
        }

    case .closeButtonTapped:
        return .send(.delegate(.closeProofPhoto))

    case .captureButtonTapped:
        guard !state.ui.isCapturing else { return .none }
        captureSessionClient.setFlashEnabled(state.ui.isFlashOn)
        state.ui.isCapturing = true
        return .run { send in
            do {
                let imageData = try await captureSessionClient.capturePhoto()
                await send(.internal(.captureCompleted(imageData: imageData)))
                captureSessionClient.stopRunning()
            } catch {
                await send(.internal(.captureFailed))
            }
        }

    case .switchButtonTapped:
        return .run { [isFront = state.ui.isFront, isFlashOn = state.ui.isFlashOn] send in
            let isFront = !isFront
            await captureSessionClient.switchCamera(isFront)
            captureSessionClient.setFlashEnabled(isFlashOn)
            await send(.internal(.cameraSwitched))
        }

    case .flashButtonTapped:
        state.ui.isFlashOn.toggle()
        captureSessionClient.setFlashEnabled(state.ui.isFlashOn)
        return .none

    case let .commentTextChanged(text):
        state.data.commentText = String(text.prefix(5))
        return .none

    case .returnButtonTapped:
        state.data.imageData = nil
        state.data.selectedPhotoItem = nil
        state.ui.isCapturing = false
        let position: AVCaptureDevice.Position = state.ui.isFront ? .front : .back

        return .run { [isFlashOn = state.ui.isFlashOn] send in
            let session = await captureSessionClient.setUpCaptureSession(position)
            captureSessionClient.setFlashEnabled(isFlashOn)
            await send(.internal(.setupCaptureSessionCompleted(session: session)))
        }

    case let .focusChanged(isFocused):
        state.ui.isCommentFocused = isFocused
        return .none

    case .uploadButtonTapped:
        guard !state.ui.isUploading else { return .none }
        let commentCount = state.data.commentText.count
        if commentCount > 0 && commentCount < 5 {
            return .send(.presentation(.showToast(.fit(message: "코멘트는 5글자로 입력해주세요!"))))
        } else {
            guard let imageData = state.data.imageData else {
                return .none
            }
            state.ui.isUploading = true

            let goalId = state.data.goalId
            let comment = state.data.commentText
            let verificationDate = state.data.verificationDate

            if state.ui.isEditing {
                let myPhotoLog = GoalDetail.CompletedGoal.PhotoLog(
                    goalId: goalId,
                    photologId: nil,
                    goalName: nil,
                    owner: .mySelf,
                    imageUrl: nil,
                    comment: comment,
                    reaction: nil,
                    createdAt: "방금"
                )
                return .send(
                    .delegate(
                        .completedUploadPhoto(
                            myPhotoLog: myPhotoLog,
                            editedImageData: imageData
                        )
                    )
                )
            }
            return .run { send in
                do {
                    let optimizedImageData = ImageUploadOptimizer.optimizedJPEGData(from: imageData)
                    let uploadResponse = try await photoLogClient.fetchUploadURL(goalId)
                    try await photoLogClient.uploadImageData(optimizedImageData, uploadResponse.uploadUrl)

                    let createRequest = PhotoLogCreateRequestDTO(
                        goalId: goalId,
                        fileName: uploadResponse.fileName,
                        comment: comment,
                        verificationDate: verificationDate
                    )
                    let photoLog = try await photoLogClient.createPhotoLog(createRequest)
                    let myPhotoLog = GoalDetail.CompletedGoal.PhotoLog(
                        goalId: goalId,
                        photologId: photoLog.photologId,
                        goalName: nil,
                        owner: .mySelf,
                        imageUrl: photoLog.imageUrl,
                        comment: comment,
                        reaction: nil,
                        createdAt: "방금"
                    )
                    await send(
                        .delegate(
                            .completedUploadPhoto(
                                myPhotoLog: myPhotoLog,
                                editedImageData: imageData
                            )
                        )
                    )
                } catch {
                    await send(.internal(.uploadFailed))
                }
            }
        }

    case .dimmedBackgroundTapped:
        return .send(.view(.focusChanged(false)))
    }
}

// MARK: - Internal

private func reduceInternal(
    state: inout ProofPhotoReducer.State,
    action: ProofPhotoReducer.Action.Internal
) -> Effect<ProofPhotoReducer.Action> {
    switch action {
    case let .setupCaptureSessionCompleted(session):
        state.data.captureSession = session
        return .none

    case .cameraSwitched:
        state.ui.isFront.toggle()
        return .none

    case let .galleryPhotoLoaded(imageData):
        state.data.imageData = imageData
        return .none

    case let .captureCompleted(imageData):
        state.data.imageData = imageData
        state.ui.isCapturing = false
        return .none

    case .captureFailed:
        state.ui.isCapturing = false
        return .send(.presentation(.showToast(.warning(message: "사진 촬영에 실패했어요"))))

    case .uploadFailed:
        state.ui.isUploading = false
        return .send(.presentation(.showToast(.warning(message: "사진 업로드에 실패했어요"))))
    }
}

// MARK: - Presentation

private func reducePresentation(
    state: inout ProofPhotoReducer.State,
    action: ProofPhotoReducer.Action.Presentation
) -> Effect<ProofPhotoReducer.Action> {
    switch action {
    case let .showToast(toast):
        state.presentation.toast = toast
        return .none
    }
}
