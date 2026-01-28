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
import SharedDesignSystem

public struct MainTabView: View {
    @Bindable public var store: StoreOf<MainTabReducer>

    public init(store: StoreOf<MainTabReducer>) {
        self.store = store
    }

    public var body: some View {
        TXTabBarContainer(selectedItem: $store.selectedTab) {
            switch store.selectedTab {
            case .home:
                RootHomeView(store: store.scope(state: \.home, action: \.home))
            case .statistics:
                EmptyView()
            case .couple:
                EmptyView()
            }
        }
        .txModal(
            item: $store.modal,
            onConfirm: { store.send(.modalConfirmTapped) }
        )
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTabReducer.State(), reducer: {
        MainTabReducer()
    }))
}
