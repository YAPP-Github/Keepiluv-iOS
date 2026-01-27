//
//  RootHomeView.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/27/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface

/// Home Feature의 NavigationStack을 제공하는 Root View입니다.
///
/// ## 사용 예시
/// ```swift
/// RootHomeView(
///     store: Store(
///         initialState: RootHomeReducer.State()
///     ) {
///         RootHomeReducer()
///     }
/// )
/// ```
public struct RootHomeView: View {
    @Bindable public var store: StoreOf<RootHomeReducer>

    /// RootHomeView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = RootHomeView(store: Store(initialState: RootHomeReducer.State()) { RootHomeReducer() })
    /// ```
    public init(store: StoreOf<RootHomeReducer>) {
        self.store = store
    }

    public var body: some View {
        NavigationStack(path: $store.routes) {
            HomeView(store: store.scope(state: \.home, action: \.home))
        }.navigationDestination(for: HomeRoute.self) { route in
            switch route {
            case .detail:
                Text("Detail")
            case .edit:
                Text("Edit")
            }
        }

    }
}

#Preview {
    RootHomeView(
        store: Store(
            initialState: RootHomeReducer.State(),
            reducer: {
                RootHomeReducer()
            },
            withDependencies: {
                $0.goalClient = .previewValue
            }
        )
    )
}
