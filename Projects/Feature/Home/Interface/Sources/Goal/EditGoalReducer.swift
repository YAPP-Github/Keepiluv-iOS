//
//  EditGoalReducer.swift
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
/// let store = Store(initialState: EditGoalReducer.State()) {
///     EditGoalReducer()
/// }
/// ```
public struct EditGoalReducer {
    
    let reducer: Reduce<State, Action>
    
    @ObservableState
    /// 목표 편집 화면에서 사용하는 상태 모델입니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let state = EditGoalReducer.State()
    /// ```
    public struct State: Equatable {
        
        public var calendarDate: TXCalendarDate
        public var calendarWeeks: [[TXCalendarDateItem]]
        public var cards: [GoalEditCardItem]
        
        /// 기본 상태를 생성합니다.
        ///
        /// ## 사용 예시
        /// ```swift
        /// let state = EditGoalReducer.State()
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
            self.cards = []
        }
    }
    
    /// 목표 편집 화면에서 발생 가능한 이벤트입니다.
    public enum Action {
        // MARK: - LifeCycle
        case onAppear
        
        // MARK: - User Action
        case calendarDateSelected(TXCalendarDateItem)
        
        // MARK: - Update State
        case setCalendarDate(TXCalendarDate)
        case fetchGoalsCompleted([GoalEditCardItem])
    }
    
    /// 외부에서 주입한 Reduce로 EditGoalReducer를 구성합니다.
    ///
    /// ## 사용 예시
    /// ```swift
    /// let reducer = EditGoalReducer(
    ///     reducer: Reduce { _, _ in .none }
    /// )
    /// ```
    public init(reducer: Reduce<State, Action>) {
        self.reducer = reducer
    }
    
    public var body: some ReducerOf<Self> {
        reducer
    }
}
