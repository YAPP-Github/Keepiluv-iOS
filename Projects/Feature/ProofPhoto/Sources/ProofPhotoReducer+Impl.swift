//
//  ProofPhotoReducer+Impl.swift
//  FeatureProofPhoto
//
//  Created by 정지훈 on 1/22/26.
//

import AVFoundation
import ComposableArchitecture
import CoreCaptureSessionInterface
import FeatureProofPhotoInterface
import PhotosUI

extension ProofPhotoReducer {
    public init() {
        @Dependency(\.captureSessionClient) var captureSessionClient
        
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
                return .run { send in
                    let imageData = try await captureSessionClient.capturePhoto()
                    
                    await send(.captureCompleted(imageData: imageData))
                    captureSessionClient.stopRunning()
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
                let position: AVCaptureDevice.Position = state.isFront ? .front : .back
                
                return .run { send in
                    let session = await captureSessionClient.setUpCaptureSession(position)
                    await send(.setupCaptureSessionCompleted(session: session))
                }
                
            
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
                    }
                }

            case let .galleryPhotoLoaded(imageData):
                state.imageData = imageData
                return .none
                
            case let .captureCompleted(imageData: imageData):
                state.imageData = imageData
                return .none

            case .binding:
                return .none
                
            default: return .none
            }
        }

        self.init(reducer: reducer)
    }
}
