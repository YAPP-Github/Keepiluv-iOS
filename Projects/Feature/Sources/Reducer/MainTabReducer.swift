//
//  MainTabStore.swift
//  Feature
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture

@Reducer
public struct MainTabReducer {
        
    @ObservableState
    public struct State: Equatable {
        public init() { }
    }
    
    public enum Action: Equatable {
        
    }
    
    public init() { }
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            
            return .none
        }
    }
}
