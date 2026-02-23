//
//  MainTabView.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHome
import FeatureHomeInterface
import FeatureGoalDetail
import FeatureStats
import FeatureStatsInterface
import FeatureProofPhoto
import SharedDesignSystem

/// 메인 탭 화면을 표시하는 View입니다.
///
/// ## 사용 예시
/// ```swift
/// MainTabView(
///     store: Store(
///         initialState: MainTabReducer.State(),
///         reducer: { MainTabReducer() }
///     )
/// )
/// ```
public struct MainTabView: View {
    @Bindable public var store: StoreOf<MainTabReducer>

    /// MainTabView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = MainTabView(
    ///     store: Store(initialState: MainTabReducer.State()) { MainTabReducer() }
    /// )
    /// ```
    public init(store: StoreOf<MainTabReducer>) {
        self.store = store
    }

    public var body: some View {
        TXTabBarContainer(
            selectedItem: $store.selectedTab,
            isTabBarHidden: store.isTabBarHidden
        ) {
            HomeCoordinatorView(store: store.scope(state: \.home, action: \.home))
                .tag(TXTabItem.home)
            
            StatsCoordinatorView(store: store.scope(state: \.stats, action: \.stats))
                .tag(TXTabItem.statistics)
            
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .tag(TXTabItem.couple)
        }
        .overlay(alignment: .bottomTrailing) {
            if store.shouldShowHomeFloatingButton {
                homeFloatingButton
            }
        }
    }
}

private extension MainTabView {
    var homeFloatingButton: some View {
        TXCircleButton(config: .plus()) {
            store.send(.home(.home(.floatingButtonTapped)))
        }
        .insideBorder(
            Color.Gray.gray300,
            shape: .circle,
            lineWidth: LineWidth.m
        )
        .shadow(color: .black.opacity(0.16), radius: 20, x: 2, y: 1)
        .padding(.trailing, 16)
        .padding(.bottom, 12 + Constants.tabBarHeight)
    }
}

private extension MainTabView {
    enum Constants {
        static let tabBarHeight: CGFloat = 58
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTabReducer.State(), reducer: {
        MainTabReducer()
    }))
}
