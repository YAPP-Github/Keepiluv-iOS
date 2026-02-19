//
//  StatsDetailView.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/19/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureStatsInterface

struct StatsDetailView: View {
    
    let store: StoreOf<StatsDetailReducer>
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    StatsDetailView(
        store: Store(
            initialState: StatsDetailReducer.State(goalId: 1),
            reducer: { StatsDetailReducer() }
        )
    )
}
