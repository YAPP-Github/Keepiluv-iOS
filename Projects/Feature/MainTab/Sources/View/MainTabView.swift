//
//  MainTabView.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import SwiftUI

public struct MainTabView: View {
    let store: StoreOf<MainTabReducer>

    public init(store: StoreOf<MainTabReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            TabView {
                Text("홈")
                    .tabItem { Label("홈", systemImage: "house") }

                Text("통계")
                    .tabItem { Label("통계", systemImage: "chart.bar") }

                Text("커플")
                    .tabItem { Label("커플", systemImage: "heart") }

                Text("마이페이지")
                    .tabItem { Label("마이페이지", systemImage: "person") }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            store.send(.onAppear)
        }
    }
}
