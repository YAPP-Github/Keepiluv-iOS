//
//  EditGoalView.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface

struct EditGoalView: View {
    
    let store: StoreOf<EditGoalReducer>
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .toolbar(.hidden, for: .navigationBar)
    }
        
}

#Preview {
    EditGoalView(store: Store(initialState: EditGoalReducer.State(), reducer: {
        EditGoalReducer()
    }))
}
