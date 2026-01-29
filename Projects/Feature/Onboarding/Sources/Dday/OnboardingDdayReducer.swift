//
//  OnboardingDdayReducer.swift
//  FeatureOnboarding
//
//  Created by Claude on 01/29/26.
//

import ComposableArchitecture
import Foundation
import SharedDesignSystem

/// 기념일 등록 화면을 관리하는 Reducer입니다.
///
/// 커플의 기념일(D-day)을 선택하여 등록합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: OnboardingDdayReducer.State(),
///     reducer: { OnboardingDdayReducer() }
/// )
/// ```
@Reducer
public struct OnboardingDdayReducer {
    /// 기념일 등록 화면의 상태입니다.
    @ObservableState
    public struct State: Equatable {
        /// 선택된 날짜
        var selectedDate: TXCalendarDate

        /// 캘린더 시트 표시 여부
        var showCalendarSheet: Bool = false

        public init() {
            self.selectedDate = TXCalendarDate()
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case dateSelectorTapped
        case calendarCompleted
        case completeButtonTapped
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            case navigateBack
            case ddayCompleted(date: Date)
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .backButtonTapped:
                return .send(.delegate(.navigateBack))

            case .dateSelectorTapped:
                state.showCalendarSheet = true
                return .none

            case .calendarCompleted:
                state.showCalendarSheet = false
                return .none

            case .completeButtonTapped:
                guard let date = state.selectedDate.date else { return .none }
                return .send(.delegate(.ddayCompleted(date: date)))

            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - Computed Properties

extension OnboardingDdayReducer.State {
    /// 날짜가 선택되었는지 여부
    var isDateSelected: Bool {
        selectedDate.day != nil
    }

    /// 포맷된 날짜 문자열 (YYYY-MM-DD)
    var formattedDate: String? {
        guard let day = selectedDate.day else { return nil }
        return String(format: "%d-%02d-%02d", selectedDate.year, selectedDate.month, day)
    }
}
