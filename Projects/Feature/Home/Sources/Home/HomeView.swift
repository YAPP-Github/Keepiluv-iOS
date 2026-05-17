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
import SharedPerfTestingSupport

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
    @State private var emptyScrollHeight: CGFloat = 0
    
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
            if UITestMode.isEnabled {
                perfActionHarness
            }
            navigationBar
            calendar
            if store.hasCards {
                content
            } else if store.isEmptyVisible {
                emptyContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .perfStateMarker(
            slug: "home",
            key: "calendar-month",
            value: "\(store.calendarDate.year)-\(store.calendarDate.month)"
        )
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
        .transaction { transaction in
            transaction.disablesAnimations = false
        }
        .fullScreenCover(
            isPresented: $store.isProofPhotoPresented,
            onDismiss: { store.send(.proofPhotoDismissed) },
        ) {
            if let proofPhotoStore = store.scope(state: \.proofPhoto, action: \.proofPhoto) {
                proofPhotoFactory.makeView(proofPhotoStore)
            }
        }
        .cameraPermissionAlert(
            isPresented: $store.isCameraPermissionAlertPresented,
            onDismiss: { store.send(.cameraPermissionAlertDismissed) }
        )
        .toolbar(.hidden, for: .navigationBar)
        .toolbar(.hidden, for: .tabBar)
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
            currentDate: $store.calendarDate,
            weeks: store.calendarWeeks,
            config: .init(
                dateStyle: .init(lastDateTextColor: Color.Gray.gray500)
            ),
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

    var emptyContent: some View {
        VStack(spacing: 0) {
            headerRow
                .padding(.horizontal, 20)
                .padding(.top, 16)

            ScrollView {
                goalEmptyView
                    // 실제 가시 영역 기준으로 중앙 정렬되도록 탭바 높이만큼 차감
                    .frame(maxWidth: .infinity, minHeight: max(0, emptyScrollHeight - 58))
                    .padding(.bottom, 58)
            }
            .scrollIndicators(.hidden)
            .refreshable {
                store.send(.fetchGoals)
            }
            .overlay(alignment: .bottomTrailing) {
                emptyArrow
            }
            .frame(maxHeight: .infinity)
            .background {
                GeometryReader { geo in
                    Color.clear
                        .onAppear { emptyScrollHeight = geo.size.height }
                        .onChange(of: geo.size.height) { _, newValue in
                            emptyScrollHeight = newValue
                        }
                }
            }
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
                Text("편집")
                    .typography(.b1_14b)
                    .foregroundStyle(Color.Gray.gray500)
            }
        }
        .frame(height: 24)
    }
    
    var cardList: some View {
        LazyVStack(spacing: 16) {
            ForEach(store.items) { item in
                goalCard(for: item)
                    .perfCell(slug: "home", stableId: item.id)
            }
        }
        .padding(.top, 12)
        .perfFeed("home")
    }

    func goalCard(for item: HomeGoalItem) -> some View {
        GoalCardView(
            item: item.card,
            onHeaderTapped: { store.send(.headerTapped(item.card)) },
            onCheckButtonTapped: {
                store.send(.goalCheckButtonTapped(
                    id: item.id,
                    isChecked: item.card.myCard.isSelected
                ))
            },
            actionLeft: { store.send(.myCardTapped(item.card)) },
            actionRight: { store.send(.yourCardTapped(item.card)) }
        )
    }
    
    @ViewBuilder
    var goalEmptyView: some View {
        Group {
            if store.hadFirstGoal == true {
                VStack(spacing: 8) {
                    Image.Illustration.scare
                        .resizable()
                        .frame(width: 164, height: 164)
                    
                    Text("이 날은 목표가 없어요!")
                        .typography(.t2_16b)
                        .foregroundStyle(Color.Gray.gray400)
                }
            } else if store.hadFirstGoal == false {
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
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    var emptyArrow: some View {
        Image.Illustration.arrow
            .padding(.bottom, 71 + 58)
            .padding(.trailing, 86)
            .ignoresSafeArea()
    }

    /// PERF-only controls used by Pass 3 same-screen state-change scenarios.
    /// Production builds never enter this branch because `UITestMode.isEnabled`
    /// requires the `-UITEST` launch argument. Buttons use a `Text` label
    /// (44pt minimum hit target) so `XCUIElement.tap()` can resolve a valid
    /// hit point. Visual opacity is `0.05` (effectively invisible) while
    /// keeping the accessibility frame valid.
    @ViewBuilder
    var perfActionHarness: some View {
        HStack(spacing: 0) {
            Button {
                var next = store.calendarDate
                next.goToNextMonth()
                store.send(.setCalendarDate(next))
            } label: {
                Text(verbatim: "▶")
                    .frame(width: 44, height: 44)
            }
            .accessibilityIdentifier("feature.home.perf.calendar-next")

            Button {
                var prev = store.calendarDate
                prev.goToPreviousMonth()
                store.send(.setCalendarDate(prev))
            } label: {
                Text(verbatim: "◀")
                    .frame(width: 44, height: 44)
            }
            .accessibilityIdentifier("feature.home.perf.calendar-prev")
        }
        .opacity(0.05)
    }
}
