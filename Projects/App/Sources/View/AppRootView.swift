//
//  AppRootView.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import SwiftUI

import ComposableArchitecture
import Feature
import FeatureMainTab

struct AppRootView: View {

    let store: StoreOf<AppRootReducer>

    var body: some View {
        MainTabView(
            store: store.scope(state: \.mainTab, action: \.mainTab)
        )
    }
}

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
