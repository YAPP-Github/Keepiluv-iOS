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

    @Dependency(\.onboardingClient)
    var onboardingClient

    @Dependency(\.authClient)
    var authClient

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
                    do {
                        let token = try await tokenManager.loadTokenFromStorage()
                        await send(.checkAuthResult(.success(token)))
                    } catch {
                        await send(.checkAuthResult(.failure(error)))
                    }
                }

            case .checkAuthResult(.success(let token)):
                if token != nil {
                    return .run { send in
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
                    state.route = .mainTab(MainTabReducer.State())

                case .coupleConnection, .profileSetup, .anniversarySetup:
                    state.route = .onboarding(OnboardingCoordinator.State(
                        initialStatus: status,
                        pendingReceivedCode: state.pendingInviteCode
                    ))
                    state.pendingInviteCode = nil
                }
                return .none

            case let .checkOnboardingStatusResult(.failure(error)):
                state.isCheckingAuth = false
                if let networkError = error as? NetworkError,
                   case .authorizationError = networkError {
                    state.route = .auth(AuthReducer.State())
                    return .none
                }

                state.route = .onboarding(OnboardingCoordinator.State(
                    pendingReceivedCode: state.pendingInviteCode
                ))
                state.pendingInviteCode = nil
                return .none

            case let .deepLinkReceived(code):
                state.pendingInviteCode = code

                if case .onboarding = state.route {
                    return .send(.route(.onboarding(.deepLinkReceived(code: code))))
                }
                return .none

            case .route(.auth(.delegate(.loginSucceeded))):
                return .run { [onboardingClient] send in
                    do {
                        let status = try await onboardingClient.fetchStatus()
                        await send(.checkOnboardingStatusResult(.success(status)))
                    } catch {
                        await send(.checkOnboardingStatusResult(.failure(error)))
                    }
                }

            case .route(.onboarding(.delegate(.onboardingCompleted))):
                state.route = .mainTab(MainTabReducer.State())
                return .none

            case .route(.onboarding(.delegate(.logoutRequested))):
                return .run { [authClient] send in
                    try? await authClient.signOut()
                    await send(.checkAuthResult(.failure(NSError(domain: "Logout", code: 0))))
                }

            case .route(.mainTab(.delegate(.logoutCompleted))),
                 .route(.mainTab(.delegate(.withdrawCompleted))):
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
