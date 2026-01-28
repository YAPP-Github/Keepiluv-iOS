//
//  HomeReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import SharedDesignSystem
import SharedUtil

/// 홈 화면의 상태와 액션을 관리하는 Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: HomeReducer.State()
/// ) {
///     HomeReducer()
/// }
/// ```
@Reducer
public struct HomeReducer {
    let reducer: Reduce<State, Action>
    
    @ObservableState
    /// 홈 화면에서 사용되는 상태 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = HomeReducer.State()
    /// ```
    public struct State {
        public var cards: [GoalCardItem] = []
        public var isLoading: Bool = true
        public var mainTitle: String = "KEEPILUV"
        public var calendarMonthTitle: String = ""
        public var calendarWeeks: [[TXCalendarDateItem]] = []
        public var calendarDate: TXCalendarDate = .init()
        public var calendarSheetDate: TXCalendarDate = .init()
        public var isRefreshHidden: Bool = true
        public var isCalendarSheetPresented: Bool = false
        public var pendingDeleteGoalID: String?
        public var hasCards: Bool { !cards.isEmpty }
        public let nowDate = CalendarNow()
        public var toast: TXToastType?
        public var modal: TXModalType?

        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = HomeReducer.State()
        /// ```
        public init() {
        }
    }
    
    /// 홈 화면에서 발생 가능한 모든 이벤트를 정의합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// store.send(.onAppear)
    /// ```
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // MARK: - LifeCycle
        case onAppear
        
        // MARK: - User Action
        case calendarDateSelected(TXCalendarDateItem)
        case navigationBarAction(TXNavigationBar.Action)
        case monthCalendarConfirmTapped
        case goalCheckButtonTapped(id: String, isChecked: Bool)
        case modalConfirmTapped
        case yourCardTapped(GoalCardItem)
        
        // MARK: - Update State
        case fetchGoalsCompleted([GoalCardItem])
        case setCalendarDate(TXCalendarDate)
        case setCalendarSheetPresented(Bool)
        case showToast(TXToastType)
        
    }
    
    /// 외부에서 주입한 Reduce로 HomeReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeReducer(reducer: Reduce { _, _ in .none })
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
    }
}
