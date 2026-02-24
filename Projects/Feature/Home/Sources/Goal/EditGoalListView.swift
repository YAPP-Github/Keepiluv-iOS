//
//  EditGoalListView.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface
import SharedDesignSystem

struct EditGoalListView: View {
    
    @Bindable var store: StoreOf<EditGoalListReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            weekCalendar
                .padding(.top, 4)
            if store.hasCards {
                cardScrollView
                    .padding(.bottom, 1)
            }
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay {
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            if !store.hasCards {
                emptyContent
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            store.send(.onAppear)
        }
        .onDisappear {
            store.send(.onDisappear)
        }
        .onTapGesture {
            guard store.selectedCardMenu != nil else { return }
            store.send(.backgroundTapped)
        }
        .txModal(
            item: $store.modal,
            onAction: { action in
                if action == .confirm {
                    store.send(.modalConfirmTapped)
                }
            }
        )
        .txToast(item: $store.toast)
    }
}

private extension EditGoalListView {
    var navigationBar: some View {
        TXNavigationBar(style: .subTitle(title: "편집", type: .back)) { _ in
            store.send(.navigationBackButtonTapped)
        }
    }
    
    var weekCalendar: some View {
        TXCalendar(
            mode: .weekly,
            weeks: store.calendarWeeks,
            onSelect: { item in
                store.send(.calendarDateSelected(item))
            },
            onSwipe: { swipe in
                store.send(.weekCalendarSwipe(swipe))
            }
        )
        .frame(maxWidth: .infinity, maxHeight: 76)
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
                                store.send(.cardMenuButtonTapped(card))
                            }
                        )
                    )
                    .overlay(alignment: .topTrailing) {
                        if store.selectedCardMenu == card {
                            dropdown
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
    }

    var dropdown: some View {
        TXDropdown(config: .goal) { action in
            store.send(.cardMenuItemSelected(action))
        }
        .offset(x: -16, y: 48)
    }
    
    var emptyContent: some View {
        VStack(spacing: 16) {
            Image.Illustration.emptyPoke
            
            Text("아직 목표가 없어요!")
                .typography(.t2_16b)
                .foregroundStyle(Color.Gray.gray400)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#Preview {
    EditGoalListView(
        store: Store(
            initialState: EditGoalListReducer.State(
                calendarDate: .init(year: 2026, month: 02, day: 15)
            ),
            reducer: {
                EditGoalListReducer()
            }
        )
    )
}
