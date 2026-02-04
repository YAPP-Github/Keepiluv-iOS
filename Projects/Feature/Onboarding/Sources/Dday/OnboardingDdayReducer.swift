//
//  OnboardingDdayReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/29/26.
//

import ComposableArchitecture
import DomainOnboardingInterface
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
    @Dependency(\.onboardingClient)
    private var onboardingClient

    @ObservableState
    public struct State: Equatable {
        var selectedDate: TXCalendarDate
        var showCalendarSheet: Bool = false
        var isLoading: Bool = false
        var toast: TXToastType?

        public init() {
            self.selectedDate = TXCalendarDate()
        }
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - User Action
        case backButtonTapped
        case dateSelectorTapped
        case completeButtonTapped

        // MARK: - Update State
        case calendarCompleted

        // MARK: - API Response
        case setAnniversaryResponse(Result<Void, Error>)

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateBack
            case ddayCompleted
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
                guard let date = state.selectedDate.date, !state.isLoading else { return .none }
                state.isLoading = true
                return .run { send in
                    do {
                        try await onboardingClient.setAnniversary(date)
                        await send(.setAnniversaryResponse(.success(())))
                    } catch {
                        await send(.setAnniversaryResponse(.failure(error)))
                    }
                }

            case .setAnniversaryResponse(.success):
                state.isLoading = false
                return .send(.delegate(.ddayCompleted))

            case .setAnniversaryResponse(.failure):
                state.isLoading = false
                state.toast = .fit(message: "기념일 등록에 실패했어요. 다시 시도해주세요")
                return .none

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
