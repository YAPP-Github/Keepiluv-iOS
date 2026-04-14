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

        // MARK: - Nested Structs

        /// 도메인 데이터
        public struct Data: Equatable {
            public var calendarDate: TXCalendarDate
            public var calendarWeeks: [[TXCalendarDateItem]]
            public var cards: [GoalEditCardItem]?
            public var selectedCardMenu: GoalEditCardItem?
            public var pendingGoalId: Int64?
            public var pendingAction: PendingAction?

            public init(calendarDate: TXCalendarDate) {
                self.calendarDate = calendarDate
                self.calendarWeeks = TXCalendarDataGenerator.generateWeekData(for: calendarDate)
            }
        }

        /// UI 상태
        public struct UIState: Equatable {
            public var isLoading: Bool = true

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

        public var hasCards: Bool { !(data.cards?.isEmpty ?? true) }

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
        public init(calendarDate: TXCalendarDate) {
            self.data = Data(calendarDate: calendarDate)
            self.ui = UIState()
            self.presentation = Presentation()
        }
    }

    /// 목표 편집 화면에서 발생 가능한 이벤트입니다.
    public enum Action: BindableAction {
        case binding(BindingAction<State>)

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case calendarDateSelected(TXCalendarDateItem)
            case weekCalendarSwipe(TXCalendar.SwipeGesture)
            case navigationBackButtonTapped
            case cardMenuButtonTapped(GoalEditCardItem)
            case cardMenuItemSelected(GoalDropList)
            case backgroundTapped
            case modalConfirmTapped
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case onAppear
            case onDisappear
            case setCalendarDate(TXCalendarDate)
            case fetchGoals
            case completeGoal(Int64)
            case deleteGoal(Int64)
        }

        // MARK: - Response (비동기 응답)
        public enum Response: Equatable {
            case fetchGoalsCompleted([GoalEditCardItem], date: TXCalendarDate)
            case deleteGoalCompleted(goalId: Int64)
            case completeGoalCompleted(goalId: Int64)
            case apiError(String)
        }

        // MARK: - Presentation (프레젠테이션 관련)
        public enum Presentation: Equatable {
            case showToast(TXToastType)
        }

        // MARK: - Delegate (부모에게 알림)
        public enum Delegate {
            case navigateBack
            case goToGoalEdit(goalId: Int64)
        }

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case presentation(Presentation)
        case delegate(Delegate)
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
