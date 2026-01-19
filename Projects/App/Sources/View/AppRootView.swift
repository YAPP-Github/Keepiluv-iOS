//
//  AppRootView.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import SwiftUI

import ComposableArchitecture
import Feature

#if DEBUG
import CoreLogging
#endif

struct AppRootView: View {

    private enum Constants {
        static let transitionDuration: TimeInterval = 0.3
    }

    let store: StoreOf<AppRootReducer>

    var body: some View {
        let pathStore = store.scope(state: \.path, action: \.path)

        ZStack {
            if store.isCheckingAuth {
                ProgressView()
            } else {
                switch pathStore.state {
                case .auth:
                    if let authStore = pathStore.scope(state: \.auth, action: \.auth) {
                        AuthView(store: authStore)
                            .transition(.opacity)
                    }

                case .mainTab:
                    if let mainTabStore = pathStore.scope(state: \.mainTab, action: \.mainTab) {
                        MainTabView(store: mainTabStore)
                            .transition(.opacity)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: Constants.transitionDuration), value: store.path)
        .onAppear {
            store.send(.onAppear)
        }
        #if DEBUG
        .detectShakeForPulse(label: pulseLabel)
        #endif
    }
}

#if DEBUG
private extension AppRootView {
    var pulseLabel: String {
        switch store.path {
        case .auth:
            return "Auth"

        case .mainTab:
            return "MainTab"
        }
    }
}
#endif

#Preview {
    AppRootView(
        store: Store(
            initialState: AppRootReducer.State(),
            reducer: {
                AppRootReducer()
            }
        )
    )
}
