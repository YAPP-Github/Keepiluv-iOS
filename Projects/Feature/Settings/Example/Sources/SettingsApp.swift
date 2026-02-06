//
//  SettingsApp.swift
//  FeatureSettingsExample
//
//  Created by Jiyong on 02/05/26.
//

import ComposableArchitecture
import FeatureSettings
import FeatureSettingsInterface
import SharedDesignSystem
import SwiftUI

@main
struct SettingsApp: App {
    var body: some Scene {
        WindowGroup {
            SettingsView(
                store: Store(
                    initialState: SettingsReducer.State(
                        nickname: "김민정",
                        coupleCode: "JF2342S"
                    ),
                    reducer: { SettingsReducer() }
                )
            )
        }
    }
}
