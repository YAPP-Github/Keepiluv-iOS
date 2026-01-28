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
            OnboardingCoordinatorView(
                store: Store(
                    initialState: OnboardingCoordinator.State(
                        myInviteCode: "KDJ34923",
                        shareContent: "초대 코드: KDJ34923"
                    ),
                    reducer: { OnboardingCoordinator() }
                )
            )
        }
    }
}
