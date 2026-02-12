//
//  AppRootView.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import SwiftUI

import ComposableArchitecture
import Feature

#if canImport(CoreLoggingDebug)
import CoreLoggingDebug
#endif

struct AppRootView: View {

    private enum Constants {
        static let transitionDuration: TimeInterval = 0.3
    }

    let store: StoreOf<AppCoordinator>

    var body: some View {
        let routeStore = store.scope(state: \.route, action: \.route)

        ZStack {
            if store.isCheckingAuth {
                ProgressView()
            } else {
                switch routeStore.state {
                case .auth:
                    if let authStore = routeStore.scope(state: \.auth, action: \.auth) {
                        AuthView(store: authStore)
                            .transition(.opacity)
                    }

                case .onboarding:
                    if let onboardingStore = routeStore.scope(state: \.onboarding, action: \.onboarding) {
                        OnboardingCoordinatorView(store: onboardingStore)
                            .transition(.opacity)
                    }

                case .mainTab:
                    if let mainTabStore = routeStore.scope(state: \.mainTab, action: \.mainTab) {
                        MainTabView(store: mainTabStore)
                            .transition(.opacity)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: Constants.transitionDuration), value: store.route)
        .onAppear {
            store.send(.onAppear)
        }
        #if canImport(CoreLoggingDebug)
        .detectShakeForPulse(label: pulseLabel)
        #endif
    }
}

#if canImport(CoreLoggingDebug)
private extension AppRootView {
    var pulseLabel: String {
        switch store.route {
        case .auth:
            return "Auth"

        case .onboarding:
            return "Onboarding"

        case .mainTab:
            return "MainTab"
        }
    }
}
#endif

#Preview {
    AppRootView(
        store: Store(
            initialState: AppCoordinator.State(),
            reducer: {
                AppCoordinator()
            }
        )
    )
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
