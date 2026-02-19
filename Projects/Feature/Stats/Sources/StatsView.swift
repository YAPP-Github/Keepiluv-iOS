//
//  StatsView.swift
//  FeatureStats
//
//  Created by 정지훈 on 2/18/26.
//

import SwiftUI

import FeatureStatsInterface
import ComposableArchitecture
import SharedDesignSystem

struct StatsView: View {
    let store: StoreOf<StatsReducer>
    
    var body: some View {
        VStack(spacing: 0) {
            navigationBar
            topTabBar
            monthNavigation
                .padding(.top, 16)
            cardList
                .padding(.top, 12)
                .padding(.horizontal, 20)
            
            Spacer()
        }
        .onAppear { store.send(.onAppear) }
    }
}

// MARK: - SubViews
private extension StatsView {
    var navigationBar: some View {
        TXNavigationBar(style: .mainTitle(title: "스탬프 통계"))
    }
    
    var topTabBar: some View {
        TXTopTabBar(config: .goal())
    }
    
    var monthNavigation: some View {
        TXCalendarMonthNavigation(
            title: store.monthTitle,
            onTitleTap: { },
            onPrevious: { },
            onNext: { }
        )
    }
    
    var cardList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(store.items, id: \.self.goalId) { item in
                    StatsCardView(
                        item: item,
                        isOngoing: true
                    )
                }
            }
        }
    }
}
