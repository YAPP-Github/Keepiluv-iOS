//
//  MakeGoalReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import SwiftUI

import ComposableArchitecture
import DomainGoalInterface
import SharedDesignSystem
import SharedUtil

/// 목표 생성/수정 화면의 상태와 액션을 관리하는 Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: MakeGoalReducer.State(category: .book)
/// ) {
///     MakeGoalReducer()
/// }
/// ```
@Reducer
public struct MakeGoalReducer {

    let reducer: Reduce<State, Action>

    @ObservableState
    /// 목표 생성/수정 화면에서 사용하는 상태입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = MakeGoalReducer.State(category: .book)
    /// ```
    public struct State: Equatable {
        // MARK: - Constants

        public static let minimumPeriodCount = 1
        public static let weeklyMaximumPeriodCount = 6
        public static let monthlyMaximumPeriodCount = 25
        public static let icons: [GoalIcon] = GoalIcon.allCases
        public static let dailyPeriodText: String = Goal.RepeatCycle.daily.text
        public static let weeklyPeriodText: String = Goal.RepeatCycle.weekly.text
        public static let monthlyPeriodText: String = Goal.RepeatCycle.monthly.text

        // MARK: - Nested Structs

        /// 도메인 데이터
        public struct Data: Equatable {
            public var mode: Mode
            public var editingGoalId: Int64?
            public var category: GoalCategory
            public var goalTitle: String
            public var selectedPeriod: Goal.RepeatCycle
            public var weeklyPeriodCount: Int = 1
            public var monthlyPeriodCount: Int = 1
            public var startDate: TXCalendarDate
            public var endDate: TXCalendarDate
            public var calendarSheetDate: TXCalendarDate
            public var calendarTarget: CalendarTarget?
            public var selectedEmojiIndex: Int

            public init(
                mode: Mode,
                editingGoalId: Int64? = nil,
                category: GoalCategory,
                goalTitle: String,
                selectedPeriod: Goal.RepeatCycle,
                weeklyPeriodCount: Int = 1,
                monthlyPeriodCount: Int = 1,
                startDate: TXCalendarDate,
                endDate: TXCalendarDate,
                calendarSheetDate: TXCalendarDate,
                selectedEmojiIndex: Int
            ) {
                self.mode = mode
                self.editingGoalId = editingGoalId
                self.category = category
                self.goalTitle = goalTitle
                self.selectedPeriod = selectedPeriod
                self.weeklyPeriodCount = weeklyPeriodCount
                self.monthlyPeriodCount = monthlyPeriodCount
                self.startDate = startDate
                self.endDate = endDate
                self.calendarSheetDate = calendarSheetDate
                self.selectedEmojiIndex = selectedEmojiIndex
            }
        }

        /// UI 상태
        public struct UIState: Equatable {
            public var isCalendarSheetPresented: Bool = false
            public var isEndDateOn: Bool = false
            public var isPeriodSheetPresented: Bool = false
            public var isGoalTitleFocused: Bool = false
            public var isLoading: Bool = false
            public var startDateText: String
            public var endDateText: String

            public init(startDateText: String, endDateText: String) {
                self.startDateText = startDateText
                self.endDateText = endDateText
            }
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

        public var showPeriodCount: Bool { data.selectedPeriod != .daily }
        public var periodCountText: String { "\(data.selectedPeriod.text) \(periodCount)번" }
        public var selectedEmoji: GoalIcon { Self.icons[data.selectedEmojiIndex] }
        public var completeButtonDisabled: Bool { !isValidTitleLength || ui.isLoading }
        public var isInvalidTitle: Bool { isValidTitleLength }
        public var isValidTitleLength: Bool { 2 <= data.goalTitle.count && data.goalTitle.count <= 14 }

        /// 화면 모드를 구분합니다.
        public enum Mode: Equatable {
            case add
            case edit
        }

        public enum CalendarTarget: Equatable {
            case startDate
            case endDate
        }

        /// 목표 생성/수정 화면의 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = MakeGoalReducer.State(category: .book, mode: .add)
        /// ```
        public init(
            category: GoalCategory,
            mode: Mode,
            editingGoalId: Int64? = nil
        ) {
            let now = CalendarNow()
            let today = TXCalendarDate(
                year: now.year,
                month: now.month,
                day: now.day
            )

            let repeatCycle = category.repeatCycle
            let weeklyCount = repeatCycle == .weekly ? category.repeatCount : 1
            let monthlyCount = repeatCycle == .monthly ? category.repeatCount : 1
            let startDateText = "\(today.month)월 \(today.day ?? 1)일"

            self.data = Data(
                mode: mode,
                editingGoalId: editingGoalId,
                category: category,
                goalTitle: category != .custom ? category.title : "",
                selectedPeriod: repeatCycle,
                weeklyPeriodCount: weeklyCount,
                monthlyPeriodCount: monthlyCount,
                startDate: today,
                endDate: today,
                calendarSheetDate: today,
                selectedEmojiIndex: category.iconIndex
            )
            self.ui = UIState(startDateText: startDateText, endDateText: startDateText)
            self.presentation = Presentation()
        }
    }

    /// 목표 생성/수정 화면에서 발생 가능한 액션입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case emojiButtonTapped
            case goalTitleFocusChanged(Bool)
            case dismissKeyboard
            case periodTabSelected(PeriodItem)
            case periodSelected
            case periodSheetWeeklyTapped
            case periodSheetMonthlyTapped
            case periodSheetMinusTapped
            case periodSheetPlusTapped
            case periodSheetCompleteTapped
            case startDateTapped
            case endDateTapped
            case monthCalendarConfirmTapped
            case completeButtonTapped
            case navigationBackButtonTapped
            case modalConfirmTapped(Int)
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case onAppear
            case onDisappear
            case updateDateText
        }

        // MARK: - Response (비동기 응답)
        public enum Response {
            case fetchGoalCompleted(Goal)
            case fetchGoalFailed
            case createGoalFailed
            case updateGoalFailed
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Delegate (부모에게 알림)
        /// MakeGoalReducer 화면에서 외부로 전달하는 이벤트입니다.
        public enum Delegate {
            case navigateBack
        }

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case presentation(Presentation)
        case delegate(Delegate)
    }

    /// 외부에서 주입한 Reduce로 MakeGoalReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = MakeGoalReducer(reducer: Reduce { _, _ in .none })
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()
        reducer
    }
}

// MARK: - Functions
public extension MakeGoalReducer.State {
    var periodCount: Int {
        switch data.selectedPeriod {
        case .daily: return 1
        case .weekly: return data.weeklyPeriodCount
        case .monthly: return data.monthlyPeriodCount
        }
    }

    var isMinusEnable: Bool { periodCount > Self.minimumPeriodCount }

    var isPlusEnable: Bool {
        if case .monthly = data.selectedPeriod {
            return periodCount < Self.monthlyMaximumPeriodCount
        } else if case .weekly = data.selectedPeriod {
            return periodCount < Self.weeklyMaximumPeriodCount
        } else {
            return false
        }
    }

    var selectedPeriodName: String {
        get {
            data.selectedPeriod.text
        } set {
            if newValue == Self.dailyPeriodText {
                data.selectedPeriod = .daily
            } else if newValue == Self.weeklyPeriodText {
                data.selectedPeriod = .weekly
            } else if newValue == Self.monthlyPeriodText {
                data.selectedPeriod = .monthly
            }
        }
    }

    var calendarMinimumDate: TXCalendarDate? {
        switch data.calendarTarget {
        case .startDate:
            let now = CalendarNow()
            return TXCalendarDate(year: now.year, month: now.month, day: now.day)
        case .endDate:
            return data.startDate
        case .none:
            return nil
        }
    }

    var isCalendarDateEnabled: (TXCalendarDateItem) -> Bool {
        { item in
            guard let minimumDate = calendarMinimumDate else { return true }
            guard let components = item.dateComponents,
                  let year = components.year,
                  let month = components.month,
                  let day = components.day else {
                return true
            }
            let itemDate = TXCalendarDate(year: year, month: month, day: day)
            return itemDate >= minimumDate
        }
    }
}


public extension MakeGoalReducer.State.Mode {
    var title: String {
        switch self {
        case .add: return "직접 만들기"
        case .edit: return "목표 수정"
        }
    }
}

extension Goal.RepeatCycle {
    public var text: String {
        switch self {
        case .daily: return "매일"
        case .weekly: return "매주"
        case .monthly: return "매월"
        }
    }
}
