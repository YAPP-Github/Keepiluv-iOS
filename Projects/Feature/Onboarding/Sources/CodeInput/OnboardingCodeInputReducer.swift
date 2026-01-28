//
//  OnboardingCodeInputReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import Foundation

/// 커플 연결 초대 코드 입력 화면을 관리하는 Reducer입니다.
///
/// 7자리 초대 코드를 입력받아 커플 연결을 완료합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: OnboardingCodeInputReducer.State(myInviteCode: "KDJ34923"),
///     reducer: { OnboardingCodeInputReducer() }
/// )
/// ```
@Reducer
public struct OnboardingCodeInputReducer {
    /// 초대 코드 입력 화면의 상태입니다.
    @ObservableState
    public struct State: Equatable {
        /// 내 초대 코드 (표시용)
        var myInviteCode: String

        /// 상대방 초대 코드 입력값 (7자리)
        var receivedCode: String = ""

        /// 현재 포커스된 입력 필드 인덱스
        var focusedIndex: Int? = nil

        /// 초대 코드 총 자릿수
        static let codeLength = 7

        public init(myInviteCode: String = "") {
            self.myInviteCode = myInviteCode
        }
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case codeInputChanged(String)
        case copyMyCodeButtonTapped
        case completeButtonTapped
        case codeFieldTapped
        case delegate(Delegate)

        @CasePathable
        public enum Delegate: Equatable {
            case navigateBack
            case coupleConnected
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

            case let .codeInputChanged(newCode):
                let filtered = newCode.filter { $0.isNumber || $0.isLetter }
                let uppercased = String(filtered.prefix(State.codeLength)).uppercased()
                state.receivedCode = uppercased

                if uppercased.count < State.codeLength {
                    state.focusedIndex = uppercased.count
                } else {
                    state.focusedIndex = nil
                }
                return .none

            case .copyMyCodeButtonTapped:
                // TODO: 클립보드 복사 기능 구현
                return .none

            case .completeButtonTapped:
                guard state.isCodeComplete else { return .none }
                // TODO: API 호출 후 연결 완료 처리
                return .send(.delegate(.coupleConnected))

            case .codeFieldTapped:
                state.focusedIndex = min(state.receivedCode.count, State.codeLength - 1)
                return .none

            case .delegate:
                return .none
            }
        }
    }
}

// MARK: - Computed Properties

extension OnboardingCodeInputReducer.State {
    /// 코드 입력이 완료되었는지 여부
    var isCodeComplete: Bool {
        receivedCode.count == Self.codeLength
    }

    /// 각 자릿수별 문자 배열
    var codeCharacters: [Character?] {
        let chars = Array(receivedCode)
        return (0..<Self.codeLength).map { index in
            index < chars.count ? chars[index] : nil
        }
    }

    /// 코드 입력이 시작되었는지 여부 (타이틀 표시 조건)
    var hasStartedInput: Bool {
        !receivedCode.isEmpty || focusedIndex != nil
    }
}
