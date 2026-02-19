//
//  StatsReducer.swift
//  FeatureStatsInterface
//
//  Created by 정지훈 on 2/18/26.
//

import Foundation

import ComposableArchitecture
import SharedDesignSystem
import DomainStatsInterface

@Reducer
public struct StatsReducer {
    
    let reducer: Reduce<State, Action>
    
    @ObservableState
    public struct State: Equatable {
        public var monthTitle: String = "2026.02"
        public var items: [StatsCardItem] = []
        
        public init() { }
    }
    
    public enum Action {
        // MARK: - LifeCycle
        case onAppear
        
        // MARK: - Network
        case fetchStats
        case fetchedStats(Stats)
    }
    
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
