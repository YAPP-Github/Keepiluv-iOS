//
//  MainTabExampleApp.swift
//  FeatureMainTab
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

import ComposableArchitecture
import Feature

@main
struct MainTabExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView(
                store: Store(
                    initialState: MainTabReducer.State(),
                    reducer: {
                        MainTabReducer()
                    }
                )
            )
        }
    }
}
