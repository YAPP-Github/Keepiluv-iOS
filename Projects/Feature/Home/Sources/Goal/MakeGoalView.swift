//
//  MakeGoalView.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface

struct MakeGoalView: View {
    
    let store: StoreOf<MakeGoalReducer>
    
    var body: some View {
        VStack(spacing: 0) {
        }
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    MakeGoalView(
        store: Store(
            initialState: MakeGoalReducer.State(),
            reducer: {
                MakeGoalReducer()
            })
    )
}
