//
//  HomeReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureProofPhotoInterface
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
    private let proofPhotoReducer: ProofPhotoReducer
    
    @ObservableState
    /// 홈 화면에서 사용되는 상태 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = HomeReducer.State()
    /// ```
    public struct State: Equatable {
        public var cards: [GoalCardItem] = []
        public var isLoading: Bool = true
        public var mainTitle: String = "KEEPILUV"
        public var calendarMonthTitle: String = ""
        public var calendarWeeks: [[TXCalendarDateItem]] = []
        public var calendarDate: TXCalendarDate = .init()
        public var calendarSheetDate: TXCalendarDate = .init()
        public var isRefreshHidden: Bool = true
        public var isCalendarSheetPresented: Bool = false
        public var pendingDeleteGoalID: Int64?
        public var hasCards: Bool { !cards.isEmpty }
        public let nowDate = CalendarNow()
        public var toast: TXToastType?
        public var modal: TXModalType?
        public var isProofPhotoPresented: Bool = false
        public var isAddGoalPresented: Bool = false
        public var isCameraPermissionAlertPresented: Bool = false
        
        public var goalSectionTitle: String {
            let now = CalendarNow()
            let today = TXCalendarDate(year: now.year, month: now.month, day: now.day)
            if TXCalendarUtil.isEarlier(calendarDate, than: today) {
                return "지난 우리의 목표"
            }
            if TXCalendarUtil.isEarlier(today, than: calendarDate) {
                return "다음 우리의 목표"
            }
            return "오늘 우리의 목표"
        }
        
        public var proofPhoto: ProofPhotoReducer.State?

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
        
        // MARK: - Child Action
        case proofPhoto(ProofPhotoReducer.Action)
        
        // MARK: - LifeCycle
        case onAppear
        
        // MARK: - User Action
        case calendarDateSelected(TXCalendarDateItem)
        case navigationBarAction(TXNavigationBar.Action)
        case monthCalendarConfirmTapped
        case goalCheckButtonTapped(id: Int64, isChecked: Bool)
        case modalConfirmTapped
        case yourCardTapped(GoalCardItem)
        case myCardTapped(GoalCardItem)
        case floatingButtonTapped
        case editButtonTapped
        case weekCalendarSwipe(TXCalendar.SwipeGesture)
        
        // MARK: - Update State
        case fetchGoals
        case fetchGoalsCompleted([GoalCardItem], date: TXCalendarDate)
        case setCalendarDate(TXCalendarDate)
        case setCalendarSheetPresented(Bool)
        case showToast(TXToastType)
        case authorizationCompleted(id: Int64, isAuthorized: Bool)
        case proofPhotoDismissed
        case addGoalButtonTapped(GoalCategory)
        case cameraPermissionAlertDismissed
        case fetchGoalsFailed

        // MARK: - Delegate
        case delegate(Delegate)
        
        /// 홈 화면에서 외부로 전달하는 이벤트입니다.
        public enum Delegate {
            case goToGoalDetail(id: Int64, owner: GoalDetail.Owner, verificationDate: String)
            case goToMakeGoal(GoalCategory)
            case goToEditGoalList(date: TXCalendarDate)
            case goToSettings
        }
    }
    
    /// 외부에서 주입한 Reduce로 HomeReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = HomeReducer(reducer: Reduce { _, _ in .none })
    /// ```
    public init(
        reducer: Reduce<State, Action>,
        proofPhotoReducer: ProofPhotoReducer = ProofPhotoReducer(
            reducer: Reduce { _, _ in .none }
        )
    ) {
        self.reducer = reducer
        self.proofPhotoReducer = proofPhotoReducer
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
            .ifLet(\.proofPhoto, action: \.proofPhoto) {
                proofPhotoReducer
            }
    }
}
