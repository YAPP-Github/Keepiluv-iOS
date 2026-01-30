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
        NavigationStack(path: $store.routes) {
            OnboardingConnectView(
                store: store.scope(state: \.connect, action: \.connect)
            )
            .navigationDestination(for: OnboardingRoute.self) { route in
                switch route {
                case .codeInput:
                    if let codeInputStore = store.scope(
                        state: \.codeInput,
                        action: \.codeInput
                    ) {
                        OnboardingCodeInputView(store: codeInputStore)
                            .navigationBarBackButtonHidden(true)
                    }

                case .profile:
                    if let profileStore = store.scope(
                        state: \.profile,
                        action: \.profile
                    ) {
                        OnboardingProfileView(store: profileStore)
                            .navigationBarBackButtonHidden(true)
                    }

                case .dday:
                    if let ddayStore = store.scope(
                        state: \.dday,
                        action: \.dday
                    ) {
                        OnboardingDdayView(store: ddayStore)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}
