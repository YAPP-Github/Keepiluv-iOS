//
//  GoalDetailExampleView.swift
//  FeatureGoalDetailExample
//
//  Created by 정지훈 on 1/23/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureGoalDetail
import FeatureGoalDetailInterface
import SharedDesignSystem

struct GoalDetailExampleView: View {
    
    @State var isPresented: Bool = false
    
    var body: some View {
        VStack {
            Button("Camera") {
                isPresented = true
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            GoalDetailView(
                store: Store(
                    initialState: GoalDetailReducer.State(
                        item: .init(
                            image: SharedDesignSystemAsset.ImageAssets.boy.swiftUIImage,
                            commentText: "차타고슝슝",
                            createdAt: "6시간전",
                            selectedEmojiIndex: nil,
                            name: "민정"
                        ),
                        currentUser: .me,
                        status: .pending
                    ),
                    reducer: {
                        GoalDetailReducer()
                    })
            )
        }
    }
}

#Preview {
    GoalDetailExampleView()
}
