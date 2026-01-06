import SwiftUI

import ComposableArchitecture

@main
struct TwixApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView(
                store: Store(
                    initialState: AppRootReducer
                        .State(),
                    reducer: {
                        AppRootReducer()
                    }
                )
            )
        }
    }
}
