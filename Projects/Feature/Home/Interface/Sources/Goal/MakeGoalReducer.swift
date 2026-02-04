//
//  MakeGoalReducer.swift
//  FeatureHomeInterface
//
//  Created by 정지훈 on 2/1/26.
//

import Foundation

import ComposableArchitecture
import SwiftUI
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
        public let minimumPeriodCount = 1
        public let weeklyMaximumPeriodCount = 6
        public let monthlyMaximumPeriodCount = 25
        public let dailyPeriodText = GoalCategory.RepeatCycle.daily.text
        public let weeklyPeriodText = GoalCategory.RepeatCycle.weekly(count: 1).text
        public let monthlyPeriodText = GoalCategory.RepeatCycle.monthly(count: 1).text
        public let iconImages: [Image] = GoalCategory.images
        public var mode: Mode
        public var category: GoalCategory
        public var goalTitle: String
        public var selectedPeriod: GoalCategory.RepeatCycle
        public var weeklyPeriodCount: Int = 1
        public var monthlyPeriodCount: Int = 1
        public var startDate: TXCalendarDate
        public var endDate: TXCalendarDate
        public var calendarSheetDate: TXCalendarDate
        public var isCalendarSheetPresented: Bool = false
        public var calendarTarget: CalendarTarget?
        public var isEndDateOn: Bool = false
        public var isPeriodSheetPresented: Bool = false
        public var selectedEmojiIndex: Int
        
        public var showPeriodCount: Bool { !selectedPeriod.isDaily }
        public var periodCountText: String { "\(selectedPeriod.text) \(periodCount)번" }
        public var selectedEmoji: Image { iconImages[selectedEmojiIndex] }
        public var completeButtonDisabled: Bool { goalTitle.isEmpty }
        
        public var modal: TXModalType?
        
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
        ) {
            let now = CalendarNow()
            let today = TXCalendarDate(
                year: now.year,
                month: now.month,
                day: now.day
            )

            self.mode = mode
            self.category = category
            self.goalTitle = category != .custom ? category.title : ""
            self.selectedPeriod = category.repeatCycle
            self.selectedEmojiIndex = category.iconIndex
            
            self.startDate = today
            self.endDate = today
            self.calendarSheetDate = today

            let repeatCycle = category.repeatCycle
            self.weeklyPeriodCount = repeatCycle.isWeekly ? repeatCycle.count : minimumPeriodCount
            self.monthlyPeriodCount = repeatCycle.isMonthly ? repeatCycle.count : minimumPeriodCount
        }
    }
    
    /// 목표 생성/수정 화면에서 발생 가능한 액션입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// store.send(.completeButtonTapped)
    /// ```
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // MARK: - LifeCycle
        case onDisappear
        
        // MARK: - User Action
        case emojiButtonTapped
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
        
        // MARK: - Delegate
        case delegate(Delegate)
        
        /// MakeGoalReducer 화면에서 외부로 전달하는 이벤트입니다.
        public enum Delegate {
            case navigateBack
        }
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
        switch selectedPeriod {
        case .daily: return 0
        case let .weekly(count): return count
        case let .monthly(count): return count
        }
    }

    var isMinusEnable: Bool { periodCount > minimumPeriodCount }

    var isPlusEnable: Bool {
        if case .monthly = selectedPeriod {
            return periodCount < monthlyMaximumPeriodCount
        } else if case .weekly = selectedPeriod {
            return periodCount < weeklyMaximumPeriodCount
        } else {
            return false
        }
    }
    
    var selectedPeriodName: String {
        get {
            selectedPeriod.text
        } set {
            if newValue == dailyPeriodText {
                selectedPeriod = .daily
            } else if newValue == weeklyPeriodText {
                selectedPeriod = .weekly(count: weeklyPeriodCount)
            } else if newValue == monthlyPeriodText {
                selectedPeriod = .monthly(count: monthlyPeriodCount)
            }
        }
    }
}
