//
//  HomeCoordinatorView.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetailInterface
import FeatureHomeInterface
import FeatureNotificationInterface
import FeatureMakeGoalInterface
import FeatureSettingsInterface

/// Home Feature의 NavigationStack을 제공하는 Root View입니다.
///
/// ## 사용 예시
/// ```swift
/// HomeCoordinatorView(
///     store: Store(
///         initialState: HomeCoordinatorReducer.State()
///     ) {
///         HomeCoordinatorReducer()
///     }
/// )
/// ```
public struct HomeCoordinatorView: View {
    @Dependency(\.goalDetailFactory) var goalDetailFactory
    @Dependency(\.notificationFactory) var notificationFactory
    @Dependency(\.makeGoalFactory) var makeGoalFactory
    @Dependency(\.settingsFactory) var settingsFactory
    @Bindable public var store: StoreOf<HomeCoordinator>

    /// HomeCoordinatorView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = HomeCoordinatorView(store: Store(initialState: HomeCoordinatorReducer.State()) { HomeCoordinatorReducer() })
    /// ```
    public init(store: StoreOf<HomeCoordinator>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.routes) {
            HomeView(store: store.scope(state: \.home, action: \.home))
                .navigationDestination(for: HomeRoute.self) { route in
                    switch route {
                    case .detail:
                        IfLetStore(store.scope(state: \.goalDetail, action: \.goalDetail)) { store in
                            goalDetailFactory.makeView(store)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .editGoalList:
                        IfLetStore(store.scope(state: \.editGoalList, action: \.editGoalList)) { store in
                            EditGoalListView(store: store)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .makeGoal:
                        IfLetStore(store.scope(state: \.makeGoal, action: \.makeGoal)) { store in
                            makeGoalFactory.makeView(store)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .settings:
                        if let settingsStore = store.scope(
                            state: \.settings,
                            action: \.settings
                        ) {
                            settingsFactory.makeView(settingsStore)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .settingsAccount:
                        if let settingsStore = store.scope(
                            state: \.settings,
                            action: \.settings
                        ) {
                            settingsFactory.makeAccountView(settingsStore)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .settingsInfo:
                        if let settingsStore = store.scope(
                            state: \.settings,
                            action: \.settings
                        ) {
                            settingsFactory.makeInfoView(settingsStore)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .settingsNotificationSettings:
                        if let settingsStore = store.scope(
                            state: \.settings,
                            action: \.settings
                        ) {
                            settingsFactory.makeNotificationSettingsView(settingsStore)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case let .settingsWebView(url, title):
                        if let settingsStore = store.scope(
                            state: \.settings,
                            action: \.settings
                        ) {
                            settingsFactory.makeWebView(settingsStore, url, title)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        }

                    case .notification:
                        if let notificationStore = store.scope(
                            state: \.notification,
                            action: \.notification
                        ) {
                            notificationFactory.makeView(notificationStore)
                                .navigationBarBackButtonHidden(true)
                                .toolbar(.hidden, for: .tabBar)
                        }
                    }
                }
        }
    }
}
