//
//  AppCoordinator.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import CoreNetworkInterface
import DomainAuthInterface
import DomainOnboardingInterface
import Feature
import Foundation

@Reducer
struct AppCoordinator {
    @Dependency(\.tokenManager)
    var tokenManager

    private let authReducer: AuthReducer
    private let onboardingCoordinator: OnboardingCoordinator
    private let mainTabReducer: MainTabReducer

    @ObservableState
    struct State: Equatable {
        var route: Route = .auth(AuthReducer.State())
        var isCheckingAuth: Bool = true
        var pendingInviteCode: String?

        public init() { }
    }

    @ObservableState
    @CasePathable
    enum Route: Equatable {
        case auth(AuthReducer.State)
        case onboarding(OnboardingCoordinator.State)
        case mainTab(MainTabReducer.State)

        var auth: AuthReducer.State? {
            get {
                if case .auth(let state) = self { return state }
                return nil
            }
            set {
                if let newValue { self = .auth(newValue) }
            }
        }

        var onboarding: OnboardingCoordinator.State? {
            get {
                if case .onboarding(let state) = self { return state }
                return nil
            }
            set {
                if let newValue { self = .onboarding(newValue) }
            }
        }

        var mainTab: MainTabReducer.State? {
            get {
                if case .mainTab(let state) = self { return state }
                return nil
            }
            set {
                if let newValue { self = .mainTab(newValue) }
            }
        }
    }

    enum Action {
        case onAppear
        case checkAuthResult(Result<Token?, Error>)
        case checkOnboardingStatusResult(Result<OnboardingStatus, Error>)
        case deepLinkReceived(code: String)
        case route(RouteAction)
    }

    @CasePathable
    enum RouteAction {
        case auth(AuthReducer.Action)
        case onboarding(OnboardingCoordinator.Action)
        case mainTab(MainTabReducer.Action)
    }

    init() {
        self.authReducer = AuthReducer()
        self.onboardingCoordinator = OnboardingCoordinator()
        self.mainTabReducer = MainTabReducer()
    }

    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .run { send in
//                    고의로 실패하여 재 로그인을 원하는 경우 아래 주석 사용
//                    키체인에 토큰이 저장되는 형식이므로, 로그아웃 기능 구현 전까지 임시 조치
//                    await send(.checkAuthResult(.failure(NSError())))
                    do {
                        let token = try await tokenManager.loadTokenFromStorage()
                        await send(.checkAuthResult(.success(token)))
                    } catch {
                        await send(.checkAuthResult(.failure(error)))
                    }
                }

            case .checkAuthResult(.success(let token)):
                if token != nil {
                    // 토큰이 있으면 onboarding/status API로 상태 확인
                    return .run { send in
                        @Dependency(\.onboardingClient) var onboardingClient
                        do {
                            let status = try await onboardingClient.fetchStatus()
                            await send(.checkOnboardingStatusResult(.success(status)))
                        } catch {
                            await send(.checkOnboardingStatusResult(.failure(error)))
                        }
                    }
                } else {
                    state.isCheckingAuth = false
                    state.route = .auth(AuthReducer.State())
                }
                return .none

            case .checkAuthResult(.failure):
                state.isCheckingAuth = false
                state.route = .auth(AuthReducer.State())
                return .none

            case let .checkOnboardingStatusResult(.success(status)):
                state.isCheckingAuth = false
                switch status {
                case .completed:
                    // 온보딩 완료 → MainTab
                    state.route = .mainTab(MainTabReducer.State())

                case .coupleConnection, .profile, .anniversary:
                    // 온보딩 미완료 → Onboarding
                    state.route = .onboarding(OnboardingCoordinator.State(
                        myInviteCode: "",
                        pendingReceivedCode: state.pendingInviteCode
                    ))
                    state.pendingInviteCode = nil
                }
                return .none

            case let .checkOnboardingStatusResult(.failure(error)):
                state.isCheckingAuth = false
                if let networkError = error as? NetworkError,
                   case .authorizationError = networkError {
                    // 인증 실패 (401) → Auth로 이동
                    state.route = .auth(AuthReducer.State())
                    return .none
                }

                // 온보딩 상태 확인 실패 → Onboarding으로 이동
                state.route = .onboarding(OnboardingCoordinator.State(
                    myInviteCode: "",
                    pendingReceivedCode: state.pendingInviteCode
                ))
                state.pendingInviteCode = nil
                return .none

            case let .deepLinkReceived(code):
                state.pendingInviteCode = code

                if case .onboarding = state.route {
                    return .send(.route(.onboarding(.deepLinkReceived(code: code))))
                }
                // Auth 화면이면 로그인 후 Onboarding에서 처리됨 (pendingInviteCode 저장됨)
                return .none

            case let .route(.auth(.delegate(.loginSucceeded(authResult)))):
                // 로그인 성공 → 신규 유저면 Onboarding, 기존 유저면 MainTab
                if authResult.isNewUser {
                    state.route = .onboarding(OnboardingCoordinator.State(
                        myInviteCode: "",
                        pendingReceivedCode: state.pendingInviteCode
                    ))
                    state.pendingInviteCode = nil
                } else {
                    state.route = .mainTab(MainTabReducer.State())
                }
                return .none

            case .route(.onboarding(.delegate(.onboardingCompleted))):
                state.route = .mainTab(MainTabReducer.State())
                return .none

            case .route(.onboarding(.delegate(.navigateBack))):
                // Onboarding에서 뒤로가기 → Auth로 이동
                // TODO: 인증부 구현 후 삭제 또는 기능 변경
                state.route = .auth(AuthReducer.State())
                return .none

            case .route:
                return .none
            }
        }
        .ifLet(\.route.auth, action: \.route.auth) {
            authReducer
        }
        .ifLet(\.route.onboarding, action: \.route.onboarding) {
            onboardingCoordinator
        }
        .ifLet(\.route.mainTab, action: \.route.mainTab) {
            mainTabReducer
        }
    }
}
