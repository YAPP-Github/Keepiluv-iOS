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
        .onDisappear {
            store.send(.onDisappear)
        }
        .onTapGesture {
            guard store.selectedCardMenuID != nil else { return }
            store.send(.backgroundTapped)
        }
    }
}

private extension EditGoalView {
    var navigationBar: some View {
        TXNavigationBar(style: .subTitle(title: "편집", rightText: "")) { _ in
            store.send(.navigationBackButtonTapped)
        }
    }
    
    var weekCalendar: some View {
        TXCalendar(
            mode: .weekly,
            weeks: store.calendarWeeks,
            onSelect: { item in
                store.send(.calendarDateSelected(item))
            }
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
                            action: {
                                store.send(.cardMenuButtonTapped(card.id))
                            }
                        )
                    )
                    .overlay(alignment: .topTrailing) {
                        if store.selectedCardMenuID == card.id {
                            dropdown
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    var dropdown: some View {
        TXDropdown(config: .goal) { action in
            store.send(.cardMenuItemSelected(action))
        }
        .offset(x: -16, y: 48)
    }
}
#Preview {
    EditGoalView(store: Store(initialState: EditGoalReducer.State(), reducer: {
        EditGoalReducer()
    }))
}
