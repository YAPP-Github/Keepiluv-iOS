//
//  StatsView.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/18/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureStatsInterface
import SharedDesignSystem

struct StatsView: View {
    @Bindable public var store: StoreOf<StatsReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            topTabBar
            monthNavigation
                .padding(.top, store.isOngoing ? 16 : 20)
            
            if store.hasItems {
                cardList
            } else {
                // TODO: - 디자인 확정되면 구현
                EmptyView()
            }
            
            Spacer()
        }
        .overlay {
            if store.isLoading {
                ProgressView()
            }
        }
        .onAppear { store.send(.onAppear) }
        .txToast(item: $store.toast)
    }
}

// MARK: - SubViews
private extension StatsView {
    var navigationBar: some View {
        TXNavigationBar(style: .mainTitle(title: "스탬프 통계"))
    }
    
    var topTabBar: some View {
        TXTopTabBar(
            config: .stats,
            onSelect: { item in
                store.send(.topTabBarSelected(item))
            }
        )
    }
    
    @ViewBuilder
    var monthNavigation: some View {
        if store.isOngoing {
            TXCalendarMonthNavigation(
                title: store.monthTitle,
                onTitleTap: { },
                isNextDisabled: store.isNextMonthDisabled,
                onPrevious: { store.send(.previousMonthTapped)},
                onNext: { store.send(.nextMonthTapped)}
            )
        } else { EmptyView() }
    }
    
    var cardList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.items, id: \.self.goalId) { item in
                    StatsCardView(
                        item: item,
                        isOngoing: store.isOngoing,
                        onTap: { goalId in
                            store.send(.statsCardTapped(goalId: goalId))
                        }
                    )
                }
            }
            .padding(.top, 12)
            .padding(.horizontal, 20)
        }
    }
}
