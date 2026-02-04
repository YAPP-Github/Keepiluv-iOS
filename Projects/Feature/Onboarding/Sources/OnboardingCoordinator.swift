//
//  OnboardingCoordinator.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import DomainOnboardingInterface
import Foundation

/// 온보딩 플로우 전체를 관리하는 Coordinator Reducer입니다.
///
/// Connect → CodeInput → Profile → Dday 화면 전환을 NavigationStack으로 관리합니다.
///
/// ## 사용 예시
/// ```swift
/// let store = Store(
///     initialState: OnboardingCoordinator.State(myInviteCode: "KDJ34923"),
///     reducer: { OnboardingCoordinator() }
/// )
/// ```
@Reducer
public struct OnboardingCoordinator {
    @Dependency(\.onboardingClient)
    private var onboardingClient
    @ObservableState
    public struct State: Equatable {
        var routes: [OnboardingRoute] = []
        var connect: OnboardingConnectReducer.State
        var codeInput: OnboardingCodeInputReducer.State?
        var profile: OnboardingProfileReducer.State?
        var dday: OnboardingDdayReducer.State?
        var myInviteCode: String
        var pendingReceivedCode: String?
        var isLoadingInviteCode: Bool = false

        public init(
            myInviteCode: String = "",
            shareContent: String = "",
            pendingReceivedCode: String? = nil
        ) {
            self.myInviteCode = myInviteCode
            self.connect = OnboardingConnectReducer.State(shareContent: shareContent)
            self.pendingReceivedCode = pendingReceivedCode
        }
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - LifeCycle
        case onAppear

        // MARK: - API Response
        case fetchInviteCodeResponse(Result<String, Error>)

        // MARK: - Deep Link
        case deepLinkReceived(code: String)

        // MARK: - Child Action
        case connect(OnboardingConnectReducer.Action)
        case codeInput(OnboardingCodeInputReducer.Action)
        case profile(OnboardingProfileReducer.Action)
        case dday(OnboardingDdayReducer.Action)

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case navigateBack
            case onboardingCompleted
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.connect, action: \.connect) {
            OnboardingConnectReducer()
        }

        Reduce { state, action in
            switch action {
            case .binding:
                return .none

            // MARK: - LifeCycle
            case .onAppear:
                // 초대 코드가 비어있으면 API 호출
                if state.myInviteCode.isEmpty {
                    state.isLoadingInviteCode = true
                    return .run { send in
                        do {
                            let inviteCode = try await onboardingClient.fetchInviteCode()
                            await send(.fetchInviteCodeResponse(.success(inviteCode)))
                        } catch {
                            await send(.fetchInviteCodeResponse(.failure(error)))
                        }
                    }
                }

                // 딥링크로 받은 코드가 있으면 CodeInput으로 이동
                if let code = state.pendingReceivedCode {
                    state.pendingReceivedCode = nil
                    state.codeInput = OnboardingCodeInputReducer.State(
                        myInviteCode: state.myInviteCode,
                        receivedCode: code
                    )
                    state.routes.append(.codeInput)
                }
                return .none

            // MARK: - API Response
            case let .fetchInviteCodeResponse(.success(inviteCode)):
                state.isLoadingInviteCode = false
                state.myInviteCode = inviteCode
                state.connect.myInviteCode = inviteCode

                // 딥링크로 받은 코드가 있으면 CodeInput으로 이동
                if let code = state.pendingReceivedCode {
                    state.pendingReceivedCode = nil
                    state.codeInput = OnboardingCodeInputReducer.State(
                        myInviteCode: inviteCode,
                        receivedCode: code
                    )
                    state.routes.append(.codeInput)
                }
                return .none

            case .fetchInviteCodeResponse(.failure):
                state.isLoadingInviteCode = false
                // 에러 발생 시 임시 코드 사용 (또는 에러 처리)
                return .none

            // MARK: - Deep Link
            case let .deepLinkReceived(code):
                state.routes.removeAll()
                state.codeInput = OnboardingCodeInputReducer.State(
                    myInviteCode: state.myInviteCode,
                    receivedCode: code
                )
                state.profile = nil
                state.dday = nil
                state.routes.append(.codeInput)
                return .none

            // MARK: - Connect Delegate
            case .connect(.delegate(.navigateBack)):
                return .send(.delegate(.navigateBack))

            case .connect(.delegate(.navigateToCodeInput)):
                state.codeInput = OnboardingCodeInputReducer.State(
                    myInviteCode: state.myInviteCode,
                    receivedCode: state.pendingReceivedCode ?? ""
                )
                state.pendingReceivedCode = nil
                state.routes.append(.codeInput)
                return .none

            case .connect:
                return .none

            // MARK: - CodeInput Delegate
            case .codeInput(.delegate(.navigateBack)):
                state.routes.removeLast()
                state.codeInput = nil
                return .none

            case .codeInput(.delegate(.coupleConnected)):
                state.profile = OnboardingProfileReducer.State()
                state.routes.append(.profile)
                return .none

            case .codeInput:
                return .none

            // MARK: - Profile Delegate
            case .profile(.delegate(.navigateBack)):
                state.routes.removeLast()
                state.profile = nil
                return .none

            case .profile(.delegate(.profileCompleted)):
                state.dday = OnboardingDdayReducer.State()
                state.routes.append(.dday)
                return .none

            case .profile:
                return .none

            // MARK: - Dday Delegate
            case .dday(.delegate(.navigateBack)):
                state.routes.removeLast()
                state.dday = nil
                return .none

            case .dday(.delegate(.ddayCompleted)):
                return .send(.delegate(.onboardingCompleted))

            case .dday:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.codeInput, action: \.codeInput) {
            OnboardingCodeInputReducer()
        }
        .ifLet(\.profile, action: \.profile) {
            OnboardingProfileReducer()
        }
        .ifLet(\.dday, action: \.dday) {
            OnboardingDdayReducer()
        }
    }
}
