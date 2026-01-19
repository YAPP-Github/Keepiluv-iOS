//
//  AuthApp.swift
//
//
//  Created by Jiyong
//

import ComposableArchitecture
import FeatureAuth
import SwiftUI

@main
struct AuthApp: App {
    var body: some Scene {
        WindowGroup {
            AuthView(
                store: Store(
                    initialState: AuthReducer.State(),
                    reducer: { AuthReducer() }
                )
            )
        }
    }
}
