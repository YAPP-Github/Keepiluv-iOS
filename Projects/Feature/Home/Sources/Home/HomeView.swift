//
//  HomeView.swift
//  FeatureHome
//
//  Created by 정지훈 on 1/26/26.
//

import SwiftUI

import ComposableArchitecture
import FeatureHomeInterface
import FeatureProofPhotoInterface
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
    @Dependency(\.proofPhotoFactory) var proofPhotoFactory
    
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
            if store.hasCards {
                content
            } else {
                goalEmptyView
            }
            Spacer()
        }
        .overlay {
            if store.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .txBottomSheet(
            isPresented: $store.isAddGoalPresented,
            showDragIndicator: true,
            sheetContent: {
                AddGoalListView { category in
                    store.send(.addGoalButtonTapped(category))
                }
                .frame(height: UIScreen.main.bounds.height - 92)
            }
        )
        .txBottomSheet(
            isPresented: $store.isCalendarSheetPresented,
            sheetContent: {
                TXCalendarBottomSheet(
                    selectedDate: $store.calendarSheetDate,
                    completeButtonText: "완료",
                    onComplete: {
                        store.send(.monthCalendarConfirmTapped)
                    }
                )
            }
        )
        .txModal(
            item: $store.modal,
            onAction: { action in
                if action == .confirm {
                    store.send(.modalConfirmTapped)
                }
            }
        )
        .txToast(
            item: $store.toast,
            onButtonTap: { }
        )
        .transaction { transaction in
            transaction.disablesAnimations = false
        }
        .fullScreenCover(
            isPresented: $store.isProofPhotoPresented,
            onDismiss: { store.send(.proofPhotoDismissed) },
        ) {
            IfLetStore(store.scope(state: \.proofPhoto, action: \.proofPhoto)) { store in
                proofPhotoFactory.makeView(store)
            }
        }
        .cameraPermissionAlert(
            isPresented: $store.isCameraPermissionAlertPresented,
            onDismiss: { store.send(.cameraPermissionAlertDismissed) }
        )
        .frame(alignment: .center)
        .toolbar(.hidden, for: .navigationBar)
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
                    isRemainedAlarm: store.hasUnreadNotification
                )
            ), onAction: { action in
                store.send(.navigationBarAction(action))
            }
        )
    }
    
    var calendar: some View {
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
    
    var content: some View {
        ScrollView {
            Group {
                headerRow
                cardList
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 103)
        }
        .refreshable {
            store.send(.fetchGoals)
        }
    }
    
    var headerRow: some View {
        HStack(spacing: 0) {
            Text(store.goalSectionTitle)
                .typography(.b1_14b)
            
            Spacer()
            
            Button {
                store.send(.editButtonTapped)
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
                store.send(.myCardTapped(card))
            }, actionRight: {
                
                store.send(.yourCardTapped(card))
            }
        )
    }
    
    var goalEmptyView: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(alignment: .center, spacing: 0) {
                    Image.Illustration.emptyPoke

                    Text("첫 목표를 세워볼까요?")
                        .typography(.t2_16b)
                        .foregroundStyle(Color.Gray.gray400)

                    Text("+ 버튼을 눌러 목표를 추가해보세요")
                        .typography(.c1_12r)
                        .foregroundStyle(Color.Gray.gray300)
                        .padding(.top, 5)
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .overlay(alignment: .bottomTrailing) {
                    Image.Illustration.arrow
                        .padding(.bottom, 63)
                        .padding(.trailing, 86)
                }
            }
            .refreshable {
                store.send(.fetchGoals)
            }
        }
    }
}
