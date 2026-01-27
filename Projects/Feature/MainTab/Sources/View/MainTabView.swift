//
//  MainTabView.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import SwiftUI

import ComposableArchitecture
import DomainGoalInterface
import FeatureHome
import FeatureHomeInterface
import SharedDesignSystem

// FIXME: -  Reducer 연결
public struct MainTabView: View {
    let store: StoreOf<MainTabReducer>
    @State var selectedItem: TXTabItem = .home

    public init(store: StoreOf<MainTabReducer>) {
        self.store = store
    }

    public var body: some View {
        TXTabBarContainer(selectedItem: $selectedItem) {
            switch selectedItem {
            case .home:
                RootHomeView(
                    store: Store(
                        initialState: RootHomeReducer.State(),
                        reducer: {
                            RootHomeReducer()
                        }, withDependencies: {
                            $0.goalClient = .previewValue
                        }
                    )
                )
                
            case .statistics:
                Text("Stats")
                
            case .couple:
                Text("Couple")
            }
        }
        .ignoresSafeArea()
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    MainTabView(store: Store(initialState: MainTabReducer.State(), reducer: {
        MainTabReducer()
    }))
}
