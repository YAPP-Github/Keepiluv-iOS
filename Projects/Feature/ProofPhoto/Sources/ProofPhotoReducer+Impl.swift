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
import FeatureProofPhotoInterface
import PhotosUI

// FIXME: - Remove
import SwiftUI

extension ProofPhotoReducer {
    // swiftlint: disable function_body_length
    /// 실제 로직을 포함한 ProofPhotoReducer를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = ProofPhotoReducer()
    /// ```
    public init() {
        @Dependency(\.captureSessionClient) var captureSessionClient
        
        // swiftlint: disable closure_body_length
        let reducer = Reduce<ProofPhotoReducer.State, ProofPhotoReducer.Action> { state, action in
            switch action {
                
            // MARK: - Life Cycle
            case .onAppear:
                return .run { send in
                    let session = await captureSessionClient.setUpCaptureSession(.back)
                    
                    await send(.setupCaptureSessionCompleted(session: session))
                }
                
            // MARK: - Action
            case .closeButtonTapped:
                return .send(.delegate(.closeProofPhoto))

            case .captureButtonTapped:
                // TODO: - Error 처리
                guard !state.isCapturing else { return .none }
                state.isCapturing = true
                return .run { send in
                    do {
                        let imageData = try await captureSessionClient.capturePhoto()
                        
                        await send(.captureCompleted(imageData: imageData))
                        captureSessionClient.stopRunning()
                    } catch {
                        await send(.captureFailed)
                    }
                }
                
            case .switchButtonTapped:
                return .run { [isFront = state.isFront] send in
                    let isFront = !isFront
                    await captureSessionClient.switchCamera(isFront)
                    
                    await send(.cameraSwitched)
                }
                
            case .flashButtonTapped:
                state.isFlashOn.toggle()
                captureSessionClient.setFlashEnabled(state.isFlashOn)
                return .none
                
            case let .commentTextChanged(text):
                state.commentText = String(text.prefix(5))
                return .none
                
            case .returnButtonTapped:
                state.imageData = nil
                state.selectedPhotoItem = nil
                state.isCapturing = false
                let position: AVCaptureDevice.Position = state.isFront ? .front : .back
                
                return .run { send in
                    let session = await captureSessionClient.setUpCaptureSession(position)
                    await send(.setupCaptureSessionCompleted(session: session))
                }
                
            case let .focusChanged(isFocused):
                state.isCommentFocused = isFocused
                return .none
                
            case .uploadButtonTapped:
                // TODO: - post
                if state.commentText.count < 5 {
                    return .send(.showToast(.fit(message: "코멘트는 5글자로 입력해주세요!")))
                } else {
                    guard let imageData = state.imageData,
                          let uiImage = UIImage(data: imageData) else {
                        return .none
                    }
                    
                    let completedGoal = GoalDetail.CompletedGoal(
                        owner: .mySelf,
                        image: Image(uiImage: uiImage),
                        comment: state.commentText,
                        createdAt: "방금"
                    )
                    return .send(.delegate(.completedUploadPhoto(completedGoal: completedGoal)))
                }
                
            case .dimmedBackgroundTapped:
                return .send(.focusChanged(false))
            
            // MARK: - Update State
            case let .setupCaptureSessionCompleted(session):
                state.captureSession = session
                return .none
                
            case .cameraSwitched:
                state.isFront.toggle()
                return .none
            
            case .binding(\.selectedPhotoItem):
                guard let selectedPhotoItem = state.selectedPhotoItem else {
                    state.imageData = nil
                    return .none
                }

                return .run { send in
                    if let imageData = try? await selectedPhotoItem.loadTransferable(type: Data.self) {
                        await send(.galleryPhotoLoaded(imageData: imageData))
                        captureSessionClient.stopRunning()
                    }
                }

            case let .galleryPhotoLoaded(imageData):
                state.imageData = imageData
                return .none
                
            case let .captureCompleted(imageData: imageData):
                state.imageData = imageData
                state.isCapturing = false
                return .none
                
            case .captureFailed:
                state.isCapturing = false
                return .none
                
            case let .showToast(toast):
                state.toast = toast
                return .none

            case .binding:
                return .none
                
            default: return .none
            }
        }
        // swiftlint: enable closure_body_length

        self.init(reducer: reducer)
    }
    // swiftlint: enable function_body_length
}
