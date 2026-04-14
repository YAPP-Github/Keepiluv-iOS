//
//  StatsReducer.swift
//  FeatureStatsInterface
//
//  Created by 정지훈 on 2/18/26.
//

import Foundation

import ComposableArchitecture
import DomainStatsInterface
import SharedDesignSystem

/// 통계 메인 화면의 상태와 액션을 관리하는 Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: StatsReducer.State()
/// ) {
///     StatsReducer(reducer: Reduce { _, _ in .none })
/// }
/// ```
@Reducer
public struct StatsReducer {

    let reducer: Reduce<State, Action>

    /// 통계 메인 화면에서 사용하는 상태입니다.
    @ObservableState
    public struct State: Equatable {

        // MARK: - Nested Structs

        /// 도메인 데이터 (실제 데이터/캐시/선택값)
        public struct Data: Equatable {
            public var currentMonth: TXCalendarDate = .init()
            public var ongoingItems: [StatsCardItem]?
            public var completedItems: [StatsCardItem]?
            public var ongoingItemsCache: [String: [StatsCardItem]] = [:]

            public init() {}
        }

        /// UI 상태 (화면 관련 상태)
        public struct UIState: Equatable {
            public var isLoading: Bool = false
            public var isOngoing: Bool = true

            public init() {}
        }

        /// 프레젠테이션 (toast, modal, sheet 등)
        public struct Presentation: Equatable {
            public var toast: TXToastType?

            public init() {}
        }

        // MARK: - State Instances

        public var data = Data()
        public var ui = UIState()
        public var presentation = Presentation()

        // MARK: - Computed Properties

        public var monthTitle: String { data.currentMonth.formattedYearMonth }

        public var isNextMonthDisabled: Bool {
            data.currentMonth >= TXCalendarDate()
        }

        public var items: [StatsCardItem]? {
            ui.isOngoing ? data.ongoingItems : data.completedItems
        }

        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = StatsReducer.State()
        /// ```
        public init() { }
    }

    /// 통계 메인 화면에서 발생 가능한 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case onAppear
            case topTabBarSelected(StatsTopTabItem)
            case statsCardTapped(goalId: Int64)
            case previousMonthTapped
            case nextMonthTapped
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case fetchStats
        }

        // MARK: - Response (비동기 응답)
        public enum Response: Equatable {
            case fetchedStats(stats: Stats, month: String)
            case fetchStatsFailed
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Delegate (부모에게 알림)
        public enum Delegate {
            case goToStatsDetail(goalId: Int64)
        }

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case presentation(Presentation)
        case delegate(Delegate)
    }

    /// 외부에서 주입된 Reduce로 StatsReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = StatsReducer(
    ///     reducer: Reduce { _, _ in .none }
    /// )
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
    }
}
