//
//  ProofPhotoReducer+Impl.swift
//  FeatureGoalDetail
//
//  Created by 정지훈 on 1/22/26.
//

import ComposableArchitecture
import CoreCaptureSessionInterface
import FeatureGoalDetailInterface

extension ProofPhotoReducer {
    public init() {
        @Dependency(\.captureSessionClient) var captureSessionClient
        
        let reducer = Reduce<ProofPhotoReducer.State, ProofPhotoReducer.Action> { state, action in
            switch action {
                
            // MARK: - Life Cycle
            case .onAppear:
                return .run { send in
                    let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                    guard isAuthorized else { return }
                    
                    let session = await captureSessionClient.setUpCaptureSession(.front)
                    
                    await send(.setupCaptureSessionCompleted(session: session))
                }
                
            // MARK: - Action
            case .captureButtonTapped:
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
            
            // MARK: - Update State
            case let .setupCaptureSessionCompleted(session):
                state.captureSession = session
                return .none
                
            case .cameraSwitched:
                state.isFront.toggle()
                return .none
                
            default: return .none
            }
        }

        self.init(reducer: reducer)
    }
}
