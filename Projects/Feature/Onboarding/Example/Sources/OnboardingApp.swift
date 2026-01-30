//
//  OnboardingApp.swift
//  FeatureOnboardingExample
//
//  Created by Jihun on 12/29/25.
//

import ComposableArchitecture
import FeatureOnboarding
import SwiftUI

@main
struct OnboardingApp: App {
    var body: some Scene {
        WindowGroup {
            OnboardingConnectView(
                store: Store(
                    initialState: OnboardingConnectReducer.State(
                        shareContent: "초대 코드"
                    ),
                    reducer: { OnboardingConnectReducer() }
                )
            )
        }
    }
}

#Preview {
    OnboardingConnectView(
        store: Store(
            initialState: OnboardingConnectReducer.State(
                shareContent: "초대 코드"
            ),
            reducer: { OnboardingConnectReducer() }
        )
    )
}
