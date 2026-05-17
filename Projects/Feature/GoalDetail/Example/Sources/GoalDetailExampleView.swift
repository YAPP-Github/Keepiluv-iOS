//
//  GoalDetailExampleView.swift
//  FeatureGoalDetailExample
//
//  Created by 정지훈 on 1/23/26.
//

import AVFoundation
import SwiftUI

import ComposableArchitecture
import CoreCaptureSession
import CoreCaptureSessionInterface
import FeatureGoalDetail
import FeatureGoalDetailInterface
import FeatureProofPhoto
import FeatureProofPhotoInterface
import SharedPerfTestingSupport
import SharedDesignSystem

struct GoalDetailExampleView: View {
    var body: some View {
        GoalDetailView(
            store: Store(
                initialState: GoalDetailReducer.State(
                    currentUser: .mySelf,
                    id: 1,
                    verificationDate: "2026-02-07"
                ),
                reducer: {
                    GoalDetailReducer(
                        proofPhotoReducer: ProofPhotoReducer()
                    )
                }, withDependencies: {
                    $0.captureSessionClient = UITestMode.isEnabled ? .perfMock : .liveValue
                    $0.proofPhotoFactory = .liveValue
                    $0.goalClient = .previewValue
                }
            )
        )
    }
}

#Preview {
    GoalDetailExampleView()
}

private extension CaptureSessionClient {
    static let perfMock = Self(
        fetchIsAuthorized: { true },
        setUpCaptureSession: { _ in AVCaptureSession() },
        stopRunning: {},
        capturePhoto: { Data() },
        switchCamera: { _ in },
        switchFlash: { _ in }
    )
}
