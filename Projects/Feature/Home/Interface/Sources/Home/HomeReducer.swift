//
//  HomeReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 1/26/26.
//

import Foundation

import ComposableArchitecture
import DomainGoalInterface
import FeatureMakeGoalInterface
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

    /// 홈 화면에서 발생 가능한 에러
    public enum HomeError: Error, Equatable {
        case unknown
        case networkError
    }
    
    @ObservableState
    /// 홈 화면에서 사용되는 상태 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = HomeReducer.State()
    /// ```
    public struct State: Equatable {
        // MARK: - Nested Structs

        /// 도메인 데이터 (실제 데이터/캐시/선택값)
        public struct Data: Equatable {
            public var cards: [GoalCardItem] = []
            public var goalsCache: [String: [GoalCardItem]] = [:]
            public var calendarDate: TXCalendarDate = .init()
            public var calendarSheetDate: TXCalendarDate = .init()
            public var calendarWeeks: [[TXCalendarDateItem]] = []
            public var pendingDeleteGoalID: Int64?
            public var pendingDeletePhotologID: Int64?

            public init() {}
        }

        /// UI 상태 (화면 관련 상태)
        public struct UIState: Equatable {
            public var isLoading: Bool = true
            public var mainTitle: String = "KEEPILUV"
            public var calendarMonthTitle: String = ""
            public var isRefreshHidden: Bool = true
            public var hasUnreadNotification: Bool = false
            public let nowDate = CalendarNow()

            public init() {}
        }

        /// 프레젠테이션 (toast, modal, sheet 등)
        public struct Presentation: Equatable {
            public var toast: TXToastType?
            public var modal: TXModalStyle?
            public var isCalendarSheetPresented: Bool = false
            public var isProofPhotoPresented: Bool = false
            public var isAddGoalPresented: Bool = false
            public var isCameraPermissionAlertPresented: Bool = false

            public init() {}
        }

        // MARK: - State Instances

        public var data = Data()
        public var ui = UIState()
        public var presentation = Presentation()
        public var proofPhoto: ProofPhotoReducer.State?

        // MARK: - Computed Properties

        public var hasCards: Bool { !data.cards.isEmpty }

        public var goalSectionTitle: String {
            let now = CalendarNow()
            let today = TXCalendarDate(year: now.year, month: now.month, day: now.day)
            if data.calendarDate < today {
                return "지난 우리 목표"
            }
            if today < data.calendarDate {
                return "다음 우리 목표"
            }
            return "오늘 우리 목표"
        }

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
    /// store.send(.view(.onAppear))
    /// ```
    public enum Action: BindableAction {
        // MARK: - View (사용자 이벤트)

        public enum View: Equatable {
            case onAppear
            case calendarDateSelected(TXCalendarDateItem)
            case weekCalendarSwipe(TXCalendar.SwipeGesture)
            case navigationBarAction(TXNavigationBar.Action)
            case monthCalendarConfirmTapped
            case goalCheckButtonTapped(id: Int64, isChecked: Bool)
            case modalConfirmTapped
            case yourCardTapped(GoalCardItem)
            case myCardTapped(GoalCardItem)
            case headerTapped(GoalCardItem)
            case floatingButtonTapped
            case editButtonTapped
            case addGoalButtonTapped(GoalCategory)
            case cameraPermissionAlertDismissed
            case proofPhotoDismissed
        }

        // MARK: - Internal (Reducer 내부 Effect)

        public enum Internal: Equatable {
            case fetchGoals
            case setCalendarDate(TXCalendarDate)
            case setCalendarSheetPresented(Bool)
            case authorizationCompleted(id: Int64, isAuthorized: Bool)
        }

        // MARK: - Response (비동기 응답)

        public enum Response: Equatable {
            case fetchGoalsResult(Result<[GoalCardItem], HomeError>, date: TXCalendarDate)
            case deletePhotoLogResult(Result<Int64, HomeError>)
            case fetchUnreadResult(Bool)
            case pokePartnerResult(Result<Int64, HomeError>)
        }

        // MARK: - Delegate (부모에게 알림)

        public enum Delegate: Equatable {
            case goToGoalDetail(id: Int64, owner: GoalDetail.Owner, verificationDate: String)
            case goToStatsDetail(id: Int64)
            case goToMakeGoal(GoalCategory)
            case goToEditGoalList(date: TXCalendarDate)
            case goToSettings
            case goToNotification
        }

        // MARK: - Presentation (프레젠테이션 관련)

        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Top-level cases

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case delegate(Delegate)
        case presentation(Presentation)
        case proofPhoto(ProofPhotoReducer.Action)
        case binding(BindingAction<State>)
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
