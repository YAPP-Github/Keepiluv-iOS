//
//  MakeGoalReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture

@Reducer
public struct MakeGoalReducer {
    
    let reducer: Reduce<State, Action>
    
    @ObservableState
    public struct State: Equatable {
        
        
        public init() {
            
        }
    }
    
    public enum Action {
        
    }
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}

