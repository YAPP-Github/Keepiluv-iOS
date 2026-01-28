//
//  HomeView.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/26/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface
import SharedDesignSystem

/// 홈 화면을 렌더링하는 View입니다.
///
/// ## 사용 예시
/// ```swift
/// HomeView(
///     store: Store(
///         initialState: HomeReducer.State()
///     ) {
///         HomeReducer()
///     }
/// )
/// ```
public struct HomeView: View {
    
    @Bindable public var store: StoreOf<HomeReducer>
    
    /// HomeView를 생성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let view = HomeView(store: Store(initialState: HomeReducer.State()) { HomeReducer() })
    /// ```
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            navigationBar
            calendar
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else if store.hasCards {
                content
            } else {
                goalEmptyView
            }
            
            Spacer()
        }
        .overlay(alignment: .bottomTrailing) {
            if store.hasCards {
                floatingButton
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .calendarSheet(
            isPresented: $store.isCalendarSheetPresented,
            selectedDate: $store.calendarSheetDate,
            onComplete: {
                store.send(.monthCalendarConfirmTapped)
            }
        )
        .txToast(item: $store.toast) {
            print("2")
        }
    }
}

// MARK: - SubViews
private extension HomeView {
    var navigationBar: some View {
        TXNavigationBar(
            style: .home(
                .init(
                    subTitle: store.calendarMonthTitle,
                    mainTitle: store.mainTitle,
                    isHiddenRefresh: store.isRefreshHidden,
                    isRemainedAlarm: false,
                )
            )) { action in
                store.send(.navigationBarAction(action))
            }
    }
    
    // FIXME: - Calendar
    var calendar: some View {
        TXCalendar(
            mode: .weekly,
            weeks: store.calendarWeeks,
            onSelect: { item in
                store.send(.calendarDateSelected(item))
            }
        )
        .frame(maxWidth: .infinity, maxHeight: 76)
    }
    
    var content: some View {
        ScrollView {
            Group {
                headerRow
                cardList
            }
            .padding(.horizontal, 20)
        }
    }
    
    var headerRow: some View {
        HStack(spacing: 0) {
            Text("오늘 우리 목표")
                .typography(.b1_14b)
            
            Spacer()
            
            Button {
                
            } label: {
                Image.Icon.Symbol.edit
            }
        }
        .frame(height: 24)
        .padding(.top, 12)
    }
    
    var cardList: some View {
        LazyVStack(spacing: 16) {
            ForEach(store.cards) { card in
                goalCard(for: card)
            }
        }
        .padding(.top, 12)
    }
    
    func goalCard(for card: GoalCardItem) -> some View {
        GoalCardView(
            config: .goalCheck(
                item: .init(
                    id: card.id,
                    goalName: card.goalName,
                    goalEmoji: card.goalEmoji,
                    myCard: card.myCard,
                    yourCard: card.yourCard
                ),
                isMyChecked: card.myCard.isSelected,
                isCoupleChecked: card.yourCard.isSelected,
                action: {
                    store.send(.goalCheckButtonTapped(id: card.id, isChecked: card.myCard.isSelected))
                }
            ),
            actionLeft: {
            },
            actionRight: {
                store.send(.yourCardTapped(card))
            }
        )
    }
    
    var floatingButton: some View {
        TXCircleButton(config: .plus()) {
            
        }
        .padding(.trailing, 16)
        .padding(.bottom, 12)
    }
    
    var goalEmptyView: some View {
        VStack(spacing: 10) {
            Image.Icon.Illustration.goalEmpty
            
            Text("첫 목표를 세워볼까요?")
                .typography(.t2_16b)
                .foregroundStyle(Color.Gray.gray200)
            
            Image.Vector.curveArrow
                .padding(.leading, 74)
        }
        .padding(.top, 136)
    }
}

#Preview {
    HomeView(
        store: Store(
            initialState: HomeReducer.State(),
            reducer: {
                HomeReducer()
            },
            withDependencies: {
                $0.goalClient = .previewValue
            }
        )
    )
}
