//
//  StatsDetailReducer.swift
//  FeatureStatsInterface
//
//  Created by 정지훈 on 2/19/26.
//

import Foundation

import ComposableArchitecture
import DomainStatsInterface
import SharedDesignSystem

/// 통계 상세 화면의 상태와 액션을 관리하는 Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: StatsDetailReducer.State()
/// ) {
///     StatsDetailReducer(reducer: Reduce { _, _ in .none })
/// }
/// ```
@Reducer
public struct StatsDetailReducer {
    let reducer: Reduce<State, Action>

    /// 통계 상세 화면에서 사용하는 상태입니다.
    @ObservableState
    public struct State: Equatable {

        // MARK: - Nested Structs

        /// 도메인 데이터
        public struct Data: Equatable {
            public let goalId: Int64
            public var currentMonth: TXCalendarDate
            public var monthlyData: [[TXCalendarDateItem]]
            public var statsDetail: StatsDetail?
            public var statsSummary: StatsDetail.Summary?
            public var completedDateByKey: [String: StatsDetail.CompletedDate] = [:]
            public var completedDateCache: [String: [StatsDetail.CompletedDate]] = [:]
            public var statsSummaryInfo: [StatsSummaryInfo] = []

            public init(goalId: Int64) {
                self.goalId = goalId
                let currentMonth = TXCalendarDate()
                self.currentMonth = currentMonth
                self.monthlyData = TXCalendarDataGenerator.generateMonthData(
                    for: currentMonth,
                    hideAdjacentDates: true
                )
            }
        }

        /// UI 상태
        public struct UIState: Equatable {
            public var isLoading: Bool = false
            public var isDropdownPresented: Bool = false
            public var selectedDropDownItem: GoalDropList?

            public init() {}
        }

        /// 프레젠테이션
        public struct Presentation: Equatable {
            public var modal: TXModalStyle?
            public var toast: TXToastType?

            public init() {}
        }

        // MARK: - State Instances

        public var data: Data
        public var ui: UIState
        public var presentation: Presentation

        // MARK: - Computed Properties

        public var currentMonthTitle: String { data.currentMonth.formattedYearMonth }
        public var nextMonthDisabled: Bool { data.currentMonth >= TXCalendarDate() }
        public var previousMonthDisabled: Bool {
            guard let startDateString = data.statsSummary?.startDate,
                let startDate = TXCalendarUtil.parseAPIDateString(startDateString) else {
                return false
            }
            return data.currentMonth <= startDate
        }
        public var naviBarTitle: String { data.statsDetail?.goalName ?? "" }
        public var isCompleted: Bool { data.statsDetail?.isCompleted == true }

        /// 통계 요약 영역의 단일 행 정보를 표현합니다.
        public struct StatsSummaryInfo: Equatable {
            public let title: String
            public let content: [String]

            public var isCompletedCount: Bool { content.count > 1 }

            public init(
                title: String,
                content: [String]
            ) {
                self.title = title
                self.content = content
            }
        }

        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = StatsDetailReducer.State(goalId: 1)
        /// ```
        public init(goalId: Int64) {
            self.data = Data(goalId: goalId)
            self.ui = UIState()
            self.presentation = Presentation()
        }
    }

    /// 통계 상세 화면에서 발생 가능한 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case navigationBarTapped(TXNavigationBar.Action)
            case previousMonthTapped
            case nextMonthTapped
            case calendarSwiped(TXCalendar.SwipeGesture)
            case calendarCellTapped(TXCalendarDateItem)
            case dropDownSelected(GoalDropList)
            case backgroundTapped
            case modalConfirmTapped
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case onAppear
            case onDisappear
            case fetchStatsDetailCalendar
            case fetchStatsDetailSummary
            case patchCompleteGoal
            case deleteGoal
            case updateStatsDetail(StatsDetail)
            case updateStatsSummary(StatsDetail.Summary)
            case updateMonthlyDate([StatsDetail.CompletedDate])
        }

        // MARK: - Response (비동기 응답)
        public enum Response: Equatable {
            case fetchStatsDetailCalendarSuccess(StatsDetail, month: String)
            case fetchStatsDetailCalendarFailed
            case fetchStatsDetailSummarySuccess(StatsDetail.Summary)
            case fetchStatsDetailSummaryFailed
            case completeGoalSuccees
            case deleteGoalSuccees
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(String)
        }

        // MARK: - Delegate (부모에게 알림)
        public enum Delegate {
            case navigateBack
            case goToGoalDetail(goalId: Int64, isCompletedPartner: Bool, date: String)
            case goToGoalEdit(goalId: Int64)
        }

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case presentation(Presentation)
        case delegate(Delegate)
    }

    /// 외부에서 주입된 Reduce로 StatsDetailReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = StatsDetailReducer(
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
