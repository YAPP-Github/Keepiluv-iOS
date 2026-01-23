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
            case .onAppear:
                return .run { send in
                    let isAuthorized = await captureSessionClient.fetchIsAuthorized()
                    guard isAuthorized else { return }
                    
                    let session = await captureSessionClient.setUpCaptureSession(.front)
                    
                    await send(.completedSetupCaptureSession(session: session))
                }
                
            case let .completedSetupCaptureSession(session):
                state.captureSession = session
                return .none
                
            default: return .none
            }
        }

        self.init(reducer: reducer)
    }
}
