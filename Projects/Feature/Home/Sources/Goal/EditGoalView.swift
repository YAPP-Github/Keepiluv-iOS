//
//  EditGoalView.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface
import SharedDesignSystem

struct EditGoalView: View {
    
    @Bindable var store: StoreOf<EditGoalReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            weekCalendar
            cardScrollView
            .padding(.top, 16)
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
    }
}

private extension EditGoalView {
    var navigationBar: some View {
        TXNavigationBar(style: .subTitle(title: "편집", rightText: "")) { _ in }
    }
    
    var weekCalendar: some View {
        TXCalendar(
            mode: .weekly,
            weeks: store.calendarWeeks,
            onSelect: { _ in }
        )
        .frame(maxWidth: .infinity, maxHeight: 76)
        .padding(.top, 4)
    }
    
    var cardScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.cards) { card in
                    GoalEditCardView(
                        config: .goalEdit(
                            item: .init(
                                id: card.id,
                                goalName: card.goalName,
                                iconImage: card.iconImage,
                                repeatCycle: card.repeatCycle,
                                startDate: card.startDate,
                                endDate: card.endDate
                            ),
                            action: { }
                        )
                    )
                }
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    EditGoalView(store: Store(initialState: EditGoalReducer.State(), reducer: {
        EditGoalReducer()
    }))
}
