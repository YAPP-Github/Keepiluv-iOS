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
            } else if !store.hasCards {
                headerRow
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay {
            if store.ui.isLoading {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if !store.hasCards {
                goalEmptyView
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if !store.hasCards {
                emptyArrow
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
        .txBottomSheet(
            isPresented: $store.presentation.isAddGoalPresented,
            showDragIndicator: true,
            sheetContent: {
                AddGoalListView { category in
                    store.send(.view(.addGoalButtonTapped(category)))
                }
            }
        )
        .txBottomSheet(
            isPresented: $store.presentation.isCalendarSheetPresented,
            sheetContent: {
                TXCalendarBottomSheet(
                    selectedDate: $store.data.calendarSheetDate,
                    completeButtonText: "완료",
                    onComplete: {
                        store.send(.view(.monthCalendarConfirmTapped))
                    }
                )
            }
        )
        .txModal(
            item: $store.presentation.modal,
            onAction: { action in
                if action == .confirm {
                    store.send(.view(.modalConfirmTapped))
                }
            }
        )
        .transaction { transaction in
            transaction.disablesAnimations = false
        }
        .fullScreenCover(
            isPresented: $store.presentation.isProofPhotoPresented,
            onDismiss: { store.send(.view(.proofPhotoDismissed)) },
        ) {
            IfLetStore(store.scope(state: \.proofPhoto, action: \.proofPhoto)) { store in
                proofPhotoFactory.makeView(store)
            }
        }
        .cameraPermissionAlert(
            isPresented: $store.presentation.isCameraPermissionAlertPresented,
            onDismiss: { store.send(.view(.cameraPermissionAlertDismissed)) }
        )
        .toolbar(.hidden, for: .navigationBar)
    }
}

// MARK: - SubViews
private extension HomeView {
    var navigationBar: some View {
        TXNavigationBar(
            style: .home(
                .init(
                    subTitle: store.ui.calendarMonthTitle,
                    mainTitle: store.ui.mainTitle,
                    isHiddenRefresh: store.ui.isRefreshHidden,
                    isRemainedAlarm: store.ui.hasUnreadNotification
                )
            ), onAction: { action in
                store.send(.view(.navigationBarAction(action)))
            }
        )
    }

    var calendar: some View {
        TXCalendar(
            mode: .weekly,
            weeks: store.data.calendarWeeks,
            config: .init(
                dateStyle: .init(lastDateTextColor: Color.Gray.gray500)
            ),
            onSelect: { item in
                store.send(.view(.calendarDateSelected(item)))
            },
            onSwipe: { swipe in
                store.send(.view(.weekCalendarSwipe(swipe)))
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
            store.send(.internal(.fetchGoals))
        }
    }

    var headerRow: some View {
        HStack(spacing: 0) {
            Text(store.goalSectionTitle)
                .typography(.b1_14b)

            Spacer()

            Button {
                store.send(.view(.editButtonTapped))
            } label: {
                Text("편집")
                    .typography(.b1_14b)
                    .foregroundStyle(Color.Gray.gray500)
            }
        }
        .frame(height: 24)
    }

    var cardList: some View {
        LazyVStack(spacing: 16) {
            ForEach(store.data.cards) { card in
                goalCard(for: card)
            }
        }
        .padding(.top, 12)
    }

    func goalCard(for card: GoalCardItem) -> some View {
        GoalCardView(
            item: card,
            onHeaderTapped: {
                store.send(.view(.headerTapped(card)))
            },
            onCheckButtonTapped: {
                store.send(.view(.goalCheckButtonTapped(id: card.id, isChecked: card.myCard.isSelected)))
            },
            actionLeft: {
                store.send(.view(.myCardTapped(card)))
            },
            actionRight: {
                store.send(.view(.yourCardTapped(card)))
            }
        )
    }

    var goalEmptyView: some View {
        VStack(spacing: 0) {
            Image.Illustration.emptyPoke
                .frame(height: 116)

            Text("첫 목표를 세워볼까요?")
                .typography(.t2_16b)
                .foregroundStyle(Color.Gray.gray400)
                .padding(.top, 16)

            Text("+ 버튼을 눌러 목표를 추가해보세요")
                .typography(.c1_12r)
                .foregroundStyle(Color.Gray.gray300)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
    }

    var emptyArrow: some View {
        Image.Illustration.arrow
            .padding(.bottom, 71)
            .padding(.trailing, 86)
            .ignoresSafeArea()
    }
}
