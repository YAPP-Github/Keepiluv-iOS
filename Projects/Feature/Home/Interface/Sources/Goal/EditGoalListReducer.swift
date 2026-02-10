//
//  EditGoalListReducer.swift
//  FeatureHome
//
//  Created by 정지훈 on 2/4/26.
//

import Foundation

import ComposableArchitecture
import SharedDesignSystem
import SharedUtil
import SwiftUI

@Reducer
/// 목표 편집 화면의 상태와 액션을 관리하는 Reducer입니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(initialState: EditGoalListReducer.State()) {
///     EditGoalListReducer()
/// }
/// ```
public struct EditGoalListReducer {
    
    let reducer: Reduce<State, Action>
    
    @ObservableState
    /// 목표 편집 화면에서 사용하는 상태 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = EditGoalListReducer.State()
    /// ```
    public struct State: Equatable {
        
        public var calendarDate: TXCalendarDate
        public var calendarWeeks: [[TXCalendarDateItem]]
        public var cards: [GoalEditCardItem] = []
        public var selectedCardMenu: GoalEditCardItem?
        public var modal: TXModalType?
        public var toast: TXToastType?
        public var isLoading: Bool = false
        public var pendingGoalId: Int64?
        public var pendingAction: PendingAction?

        public enum PendingAction: Equatable {
            case delete
            case complete
        }
        
        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = EditGoalListReducer.State()
        /// ```
        public init() {
            let nowDate = CalendarNow()
            let today = TXCalendarDate(
                year: nowDate.year,
                month: nowDate.month,
                day: nowDate.day
            )
            self.calendarDate = today
            self.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: today)
        }
    }
    
    /// 목표 편집 화면에서 발생 가능한 이벤트입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        // MARK: - LifeCycle
        case onAppear
        case onDisappear
        
        // MARK: - User Action
        case calendarDateSelected(TXCalendarDateItem)
        case navigationBackButtonTapped
        case cardMenuButtonTapped(GoalEditCardItem)
        case cardMenuItemSelected(TXDropdownItem)
        case backgroundTapped
        case modalConfirmTapped
        
        // MARK: - Update State
        case setCalendarDate(TXCalendarDate)
        case fetchGoalsCompleted([GoalEditCardItem])
        case deleteGoalCompleted(goalId: Int64)
        case completeGoalCompleted(goalId: Int64)
        case apiError(String)
        case showToast(TXToastType)

        // MARK: - Delegate
        case delegate(Delegate)
        
        public enum Delegate {
            case navigateBack
            case goToGoalEdit(goalId: Int64)
        }
    }
    
    /// 외부에서 주입한 Reduce로 EditGoalListReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = EditGoalListReducer(
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
