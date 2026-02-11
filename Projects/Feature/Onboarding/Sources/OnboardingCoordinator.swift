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
        var initialStatus: OnboardingStatus

        public init(
            initialStatus: OnboardingStatus = .coupleConnection,
            myInviteCode: String = "",
            pendingReceivedCode: String? = nil
        ) {
            self.initialStatus = initialStatus
            self.myInviteCode = myInviteCode
            self.connect = OnboardingConnectReducer.State()
            self.pendingReceivedCode = pendingReceivedCode

            // 초기 상태에 따라 시작 화면 설정
            switch initialStatus {
            case .coupleConnection:
                // Connect부터 시작 (기본)
                break

            case .profileSetup:
                // Profile부터 시작
                self.profile = OnboardingProfileReducer.State()
                self.routes = [.profile]

            case .anniversarySetup:
                // Dday부터 시작하지만, back 버튼으로 Profile로 돌아갈 수 있도록 설정
                self.profile = OnboardingProfileReducer.State()
                self.dday = OnboardingDdayReducer.State()
                self.routes = [.profile, .dday]

            case .completed:
                // 완료 상태면 여기 오면 안됨
                break
            }
        }
    }

    public enum Action: BindableAction {
        // MARK: - Binding
        case binding(BindingAction<State>)

        // MARK: - LifeCycle
        case onAppear

        // MARK: - API Response
        case fetchInviteCodeResponse(Result<String, Error>)
        case fetchStatusResponse(Result<OnboardingStatus, Error>)

        // MARK: - Navigation
        case navigateToCodeInputWithCode(myInviteCode: String, receivedCode: String)

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
            case logoutRequested
            case onboardingCompleted
        }
    }

    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Scope(state: \.connect, action: \.connect) {
            OnboardingConnectReducer()
        }

        // swiftlint:disable:next closure_body_length
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
                    return .send(.navigateToCodeInputWithCode(
                        myInviteCode: state.myInviteCode,
                        receivedCode: code
                    ))
                }
                return .none

            // MARK: - API Response
            case let .fetchInviteCodeResponse(.success(inviteCode)):
                state.isLoadingInviteCode = false
                state.myInviteCode = inviteCode
                state.connect.myInviteCode = inviteCode
                if let deeplinkHost = Bundle.main.object(forInfoDictionaryKey: "DEEPLINK_HOST") as? String {
                    state.connect.shareContent = "https://\(deeplinkHost)/invite?code=\(inviteCode)"
                }

                // 딥링크로 받은 코드가 있으면 CodeInput으로 이동
                if let code = state.pendingReceivedCode {
                    state.pendingReceivedCode = nil
                    return .send(.navigateToCodeInputWithCode(
                        myInviteCode: inviteCode,
                        receivedCode: code
                    ))
                }
                return .none

            case .fetchInviteCodeResponse(.failure):
                state.isLoadingInviteCode = false
                // 에러 발생 시 임시 코드 사용 (또는 에러 처리)
                return .none

            // MARK: - Navigation
            case let .navigateToCodeInputWithCode(myInviteCode, receivedCode):
                state.codeInput = OnboardingCodeInputReducer.State(
                    myInviteCode: myInviteCode,
                    receivedCode: receivedCode
                )
                state.routes.append(.codeInput)
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
            case .connect(.delegate(.logoutRequested)):
                return .send(.delegate(.logoutRequested))

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
                // Profile 완료 후 status 체크하여 다음 화면 결정
                return .run { send in
                    do {
                        let status = try await onboardingClient.fetchStatus()
                        await send(.fetchStatusResponse(.success(status)))
                    } catch {
                        await send(.fetchStatusResponse(.failure(error)))
                    }
                }

            case .profile:
                return .none

            // MARK: - Status Response (Profile 완료 후)
            case let .fetchStatusResponse(.success(status)):
                switch status {
                case .completed:
                    // 이미 온보딩 완료 → MainTab으로 이동
                    return .send(.delegate(.onboardingCompleted))
                case .anniversarySetup:
                    // 기념일 설정 필요 → Dday로 이동
                    state.dday = OnboardingDdayReducer.State()
                    state.routes.append(.dday)
                    return .none
                default:
                    // profileSetup, coupleConnection 등 예상치 못한 상태
                    // 프로필 등록 API 성공 후 이 상태가 나오면 서버 이슈이므로 에러 로그만 남김
                    // 일단 Dday로 진행 (사용자 경험 우선)
                    state.dday = OnboardingDdayReducer.State()
                    state.routes.append(.dday)
                    return .none
                }

            case .fetchStatusResponse(.failure):
                // Status 조회 실패 시에도 Dday로 진행
                // 프로필 등록은 이미 성공했으므로 다음 단계로 진행하는 것이 UX에 유리
                state.dday = OnboardingDdayReducer.State()
                state.routes.append(.dday)
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
