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
            switch store.selectedTab {
            case .home:
                HomeCoordinatorView(store: store.scope(state: \.home, action: \.home))
                
            case .statistics:
                EmptyView()
                
            case .couple:
                EmptyView()
            }
        }
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTabReducer.State(), reducer: {
        MainTabReducer()
    }))
}
