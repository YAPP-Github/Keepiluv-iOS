//
//  OnboardingCoordinator.swift
//  FeatureOnboarding
//
//  Created by Jiyong on 01/28/26.
//

import ComposableArchitecture
import CorePushInterface
import DomainOnboardingInterface
import Foundation
import SharedDesignSystem

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
    @Dependency(\.pushClient)
    private var pushClient
    @Dependency(\.continuousClock)
    private var clock

    private enum CancelID {
        case couplePolling
    }

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
        var isCouplePolling: Bool = false

        // MARK: - Notification Permission
        var isNotificationModalPresented: Bool = false
        var isPushPermissionGranted: Bool = false

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

        // MARK: - Couple Polling (커플 연결 대기 중 상태 확인)
        case startCouplePolling
        case stopCouplePolling
        case couplePollingTick
        case couplePollingResult(Result<OnboardingStatus, Error>)

        // MARK: - Deep Link
        case deepLinkReceived(code: String)

        // MARK: - Child Action
        case connect(OnboardingConnectReducer.Action)
        case codeInput(OnboardingCodeInputReducer.Action)
        case profile(OnboardingProfileReducer.Action)
        case dday(OnboardingDdayReducer.Action)

        // MARK: - Notification Permission
        case startNotificationPermission
        case pushPermissionResponse(granted: Bool)
        case notificationModalConfirmed(isMarketing: Bool, isNight: Bool)

        // MARK: - Delegate
        case delegate(Delegate)

        public enum Delegate: Equatable {
            case logoutRequested
            case onboardingCompleted(isPushEnabled: Bool, isMarketingEnabled: Bool, isNightEnabled: Bool)
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
                // 커플 연결 단계가 아니면 폴링 불필요
                guard state.initialStatus == .coupleConnection else { return .none }

                var effects: [Effect<Action>] = [.send(.startCouplePolling)]

                // 초대 코드가 비어있으면 API 호출
                if state.myInviteCode.isEmpty {
                    state.isLoadingInviteCode = true
                    effects.append(.run { send in
                        do {
                            let inviteCode = try await onboardingClient.fetchInviteCode()
                            await send(.fetchInviteCodeResponse(.success(inviteCode)))
                        } catch {
                            await send(.fetchInviteCodeResponse(.failure(error)))
                        }
                    })
                }

                // 딥링크로 받은 코드가 있고 내 초대 코드도 준비된 경우에만 이동
                // myInviteCode가 비어있으면 fetchInviteCodeResponse에서 처리
                if let code = state.pendingReceivedCode, !state.myInviteCode.isEmpty {
                    state.pendingReceivedCode = nil
                    effects.append(.send(.navigateToCodeInputWithCode(
                        myInviteCode: state.myInviteCode,
                        receivedCode: code
                    )))
                }

                return .merge(effects)

            // MARK: - Couple Polling
            case .startCouplePolling:
                guard !state.isCouplePolling else { return .none }
                state.isCouplePolling = true
                return .run { [clock] send in
                    for await _ in clock.timer(interval: .seconds(3)) {
                        await send(.couplePollingTick)
                    }
                }
                .cancellable(id: CancelID.couplePolling, cancelInFlight: true)

            case .stopCouplePolling:
                state.isCouplePolling = false
                return .cancel(id: CancelID.couplePolling)

            case .couplePollingTick:
                return .run { [onboardingClient] send in
                    do {
                        let status = try await onboardingClient.fetchStatus()
                        await send(.couplePollingResult(.success(status)))
                    } catch {
                        await send(.couplePollingResult(.failure(error)))
                    }
                }

            case let .couplePollingResult(.success(status)):
                switch status {
                case .profileSetup, .anniversarySetup, .completed:
                    // 상대방이 연결 완료 → 폴링 중단 후 Profile로 이동
                    state.isCouplePolling = false
                    state.profile = OnboardingProfileReducer.State()
                    state.routes.removeAll(where: { $0 == .codeInput })
                    state.routes.append(.profile)
                    return .cancel(id: CancelID.couplePolling)

                case .coupleConnection:
                    return .none
                }

            case .couplePollingResult(.failure):
                // 에러 발생 시 다음 틱에서 재시도
                return .none

            // MARK: - API Response
            case let .fetchInviteCodeResponse(.success(inviteCode)):
                state.isLoadingInviteCode = false
                state.myInviteCode = inviteCode
                state.connect.myInviteCode = inviteCode
                if let deeplinkHost = Bundle.main.object(forInfoDictionaryKey: "DEEPLINK_HOST") as? String {
                    state.connect.shareContent = """
                    [키피럽 함께 시작해요]
                    함께 시작하고 일상 속 시너지를!

                    1. '키피럽'을 설치해 주세요. [스토어 링크]
                    2. 회원가입을 해 주세요.
                    3. 아래 링크를 통해 연결하거나, 연결 코드를 메이트과 공유하세요!

                    https://\(deeplinkHost)/invite?code=\(inviteCode)
                    """
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
                state.profile = nil
                state.dday = nil

                if state.myInviteCode.isEmpty {
                    state.pendingReceivedCode = code
                } else {
                    state.codeInput = OnboardingCodeInputReducer.State(
                        myInviteCode: state.myInviteCode,
                        receivedCode: code
                    )
                    state.routes.append(.codeInput)
                }
                return .none

            // MARK: - Connect Delegate
            case .connect(.delegate(.logoutRequested)):
                state.isCouplePolling = false
                return .merge(
                    .cancel(id: CancelID.couplePolling),
                    .send(.delegate(.logoutRequested))
                )

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
                popLastRoute(&state.routes)
                state.codeInput = nil
                return .none

            case .codeInput(.delegate(.coupleConnected)):
                // 사용자가 직접 코드 입력으로 연결 → 폴링 중단 후 Profile로 이동
                state.isCouplePolling = false
                state.profile = OnboardingProfileReducer.State()
                state.routes.append(.profile)
                return .cancel(id: CancelID.couplePolling)

            case .codeInput:
                return .none

            // MARK: - Profile Delegate
            case .profile(.delegate(.navigateBack)):
                popLastRoute(&state.routes)
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
                    // 이미 온보딩 완료 → 알림 권한 요청 시작
                    return .send(.startNotificationPermission)

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
                popLastRoute(&state.routes)
                state.dday = nil
                return .none

            case .dday(.delegate(.ddayCompleted)):
                return .send(.startNotificationPermission)

            case .dday:
                return .none

            // MARK: - Notification Permission
            case .startNotificationPermission:
                return .run { [pushClient] send in
                    let granted = (try? await pushClient.requestAuthorization()) ?? false
                    await send(.pushPermissionResponse(granted: granted))
                }

            case let .pushPermissionResponse(granted):
                state.isPushPermissionGranted = granted
                state.isNotificationModalPresented = true
                return .none

            case let .notificationModalConfirmed(isMarketing, isNight):
                state.isNotificationModalPresented = false
                return .send(.delegate(.onboardingCompleted(
                    isPushEnabled: state.isPushPermissionGranted,
                    isMarketingEnabled: isMarketing,
                    isNightEnabled: isNight
                )))

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

private func popLastRoute(_ routes: inout [OnboardingRoute]) {
    guard !routes.isEmpty else { return }
    routes.removeLast()
}
