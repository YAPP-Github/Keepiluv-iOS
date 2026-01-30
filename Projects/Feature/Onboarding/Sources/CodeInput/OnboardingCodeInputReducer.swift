//
//  OnboardingCodeInputReducer.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import Foundation
import SharedDesignSystem
import UIKit

/// 커플 연결 초대 코드 입력 화면을 관리하는 Reducer입니다.
///
/// 8자리 초대 코드를 입력받아 커플 연결을 완료합니다.
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

        /// 상대방 초대 코드 입력값 (8자리)
        var receivedCode: String = ""

        /// 현재 포커스된 입력 필드 인덱스
        var focusedIndex: Int? = nil

        /// 토스트 상태
        var toast: TXToastType?

        /// 초대 코드 총 자릿수
        static let codeLength = 8

        public init(
            myInviteCode: String = "",
            receivedCode: String = ""
        ) {
            self.myInviteCode = myInviteCode
            let filtered = receivedCode.filter { $0.isNumber || $0.isLetter }
            self.receivedCode = String(filtered.prefix(Self.codeLength)).uppercased()
        }
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - User Action
        case backButtonTapped
        case codeInputChanged(String)
        case copyMyCodeButtonTapped
        case completeButtonTapped
        case codeFieldTapped

        // MARK: - Delegate
        case delegate(Delegate)

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
                UIPasteboard.general.string = state.myInviteCode
                state.toast = .success(message: "초대 코드가 복사되었어요")
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
    var isCodeComplete: Bool {
        receivedCode.count == Self.codeLength
    }

    var codeCharacters: [Character?] {
        let chars = Array(receivedCode)
        return (0..<Self.codeLength).map { index in
            index < chars.count ? chars[index] : nil
        }
    }
}
