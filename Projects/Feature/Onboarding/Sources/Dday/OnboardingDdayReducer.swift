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

        // MARK: - View (사용자 이벤트)
        public enum View: Equatable {
            case backButtonTapped
            case dateSelectorTapped
            case completeButtonTapped
        }

        // MARK: - Internal (Reducer 내부 Effect)
        public enum Internal: Equatable {
            case calendarCompleted
        }

        // MARK: - Response (비동기 응답)
        public enum Response {
            case setAnniversaryResponse(Result<Void, Error>)
        }

        // MARK: - Delegate (부모에게 알림)
        public enum Delegate: Equatable {
            case navigateBack
            case ddayCompleted
        }

        case view(View)
        case `internal`(Internal)
        case response(Response)
        case delegate(Delegate)
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            case .view(let viewAction):
                return reduceView(state: &state, action: viewAction)

            case .internal(let internalAction):
                return reduceInternal(state: &state, action: internalAction)

            case .response(let responseAction):
                return reduceResponse(state: &state, action: responseAction)

            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - View

private extension OnboardingDdayReducer {
    func reduceView(
        state: inout State,
        action: Action.View
    ) -> Effect<Action> {
        switch action {
        case .backButtonTapped:
            return .send(.delegate(.navigateBack))

        case .dateSelectorTapped:
            state.showCalendarSheet = true
            return .none

        case .completeButtonTapped:
            guard let date = state.selectedDate.date, !state.isLoading else { return .none }
            state.isLoading = true
            return .run { send in
                do {
                    try await onboardingClient.setAnniversary(date)
                    await send(.response(.setAnniversaryResponse(.success(()))))
                } catch {
                    await send(.response(.setAnniversaryResponse(.failure(error))))
                }
            }
        }
    }
}

// MARK: - Internal

private extension OnboardingDdayReducer {
    func reduceInternal(
        state: inout State,
        action: Action.Internal
    ) -> Effect<Action> {
        switch action {
        case .calendarCompleted:
            state.showCalendarSheet = false
            return .none
        }
    }
}

// MARK: - Response

private extension OnboardingDdayReducer {
    func reduceResponse(
        state: inout State,
        action: Action.Response
    ) -> Effect<Action> {
        switch action {
        case .setAnniversaryResponse(.success):
            state.isLoading = false
            return .send(.delegate(.ddayCompleted))

        case let .setAnniversaryResponse(.failure(error)):
            state.isLoading = false
            // 이미 온보딩이 완료된 경우 (G4000), 성공과 동일하게 처리
            if let onboardingError = error as? OnboardingError,
               onboardingError == .alreadyOnboarded {
                return .send(.delegate(.ddayCompleted))
            }
            state.toast = .fit(message: "기념일 등록에 실패했어요. 다시 시도해주세요")
            return .none
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
