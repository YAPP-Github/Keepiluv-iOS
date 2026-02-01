//
//  GoalDetailExampleView.swift
//  FeatureGoalDetailExample
//
//  Created by 정지훈 on 1/23/26.
//

import SwiftUI

import ComposableArchitecture
import CoreCaptureSession
import FeatureGoalDetail
import FeatureGoalDetailInterface
import FeatureProofPhoto
import FeatureProofPhotoInterface
import SharedDesignSystem

struct GoalDetailExampleView: View {
    var body: some View {
        GoalDetailView(
            store: Store(
                initialState: GoalDetailReducer.State(),
                reducer: {
                    GoalDetailReducer(
                        proofPhotoReducer: ProofPhotoReducer()
                    )
                }, withDependencies: {
                    $0.captureSessionClient = .liveValue
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
