//
//  MainTabView.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import SwiftUI

struct MainTabView: View {
    let store: StoreOf<MainTabReducer>

    init(store: StoreOf<MainTabReducer>) {
        self.store = store
    }

    var body: some View {
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

public struct MainTabViewFactory: Sendable {
    
    public var makeView: @Sendable @MainActor (_ store: StoreOf<MainTabReducer>) -> AnyView

    public init(
        makeView: @Sendable @escaping @MainActor (_ store: StoreOf<MainTabReducer>) -> AnyView
    ) {
        self.makeView = makeView
    }
}

extension MainTabViewFactory: TestDependencyKey {
    public static let testValue = Self { _ in
        assertionFailure("MainTabViewFactory.makeView is unimplemented")
        return AnyView(EmptyView())
    }
}

extension MainTabViewFactory: DependencyKey {
    public static let liveValue = Self { store in
        AnyView(MainTabView(store: store))
    }
}

public extension DependencyValues {
    var mainTabViewFactory: MainTabViewFactory {
        get { self[MainTabViewFactory.self] }
        set { self[MainTabViewFactory.self] = newValue }
    }
}
