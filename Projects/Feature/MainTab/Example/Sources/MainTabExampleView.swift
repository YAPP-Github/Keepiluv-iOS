//
//  MainTabExampleView.swift
//  FeatureMainTabExample
//
//  Created by 정지훈 on 1/28/26.
//

import SwiftUI

import ComposableArchitecture
import Feature
import CoreCaptureSession
import DomainGoalInterface

struct MainTabExampleView: View {
    var body: some View {
        MainTabView(
            store: Store(
                initialState: MainTabReducer.State(),
                reducer: {
                    MainTabReducer()
                }, withDependencies: {
                    $0.goalClient = .previewValue
                    $0.captureSessionClient = .liveValue
                    $0.proofPhotoFactory = .liveValue
                    $0.goalDetailFactory = .liveValue
                }
            )
        )
    }
}

#Preview {
    MainTabExampleView()
}
