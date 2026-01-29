//
//  OnboardingCoordinatorView.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import SharedDesignSystem
import SwiftUI

/// 온보딩 플로우 전체를 관리하는 Coordinator View입니다.
public struct OnboardingCoordinatorView: View {
    @Bindable var store: StoreOf<OnboardingCoordinator>

    public init(store: StoreOf<OnboardingCoordinator>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            OnboardingConnectView(
                store: store.scope(state: \.connect, action: \.connect)
            )
        } destination: { store in
            switch store.case {
            case let .codeInput(store):
                OnboardingCodeInputView(store: store)
                    .navigationBarBackButtonHidden(true)
                
            case let .profile(store):
                OnboardingProfileView(store: store)
                    .navigationBarBackButtonHidden(true)

            case let .dday(store):
                OnboardingDdayView(store: store)
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}
