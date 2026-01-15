//
//  AppRootReducer.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import Feature
import FeatureMainTab

@Reducer
struct AppRootReducer {
    
    @ObservableState
    struct State: Equatable {
        var mainTab: MainTabReducer.State = .init()
        
        public init() { }
    }
    
    enum Action {
        case mainTab(MainTabReducer.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.mainTab, action: \.mainTab) {
            MainTabReducer()
        }
    }
}
