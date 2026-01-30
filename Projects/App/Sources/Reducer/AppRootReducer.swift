//
//  AppRootReducer.swift
//  Twix
//
//  Created by 정지훈 on 1/4/26.
//

import ComposableArchitecture
import DomainAuthInterface
import Feature
import Foundation

@Reducer
struct AppRootReducer {
    @Dependency(\.tokenManager)
    var tokenManager

    private let authReducer: AuthReducer
    private let onboardingCoordinator: OnboardingCoordinator
    private let mainTabReducer: MainTabReducer

    @ObservableState
    struct State: Equatable {
        var path: PathState = .auth(AuthReducer.State())
        var isCheckingAuth: Bool = true
        var pendingInviteCode: String?

        public init() { }
    }

    @ObservableState
    @CasePathable
    public enum PathState: Equatable {
        case auth(AuthReducer.State)
        case onboarding(OnboardingCoordinator.State)
        case mainTab(MainTabReducer.State)

        var auth: AuthReducer.State? {
            if case .auth(let state) = self { return state }
            return nil
        }

        var onboarding: OnboardingCoordinator.State? {
            if case .onboarding(let state) = self { return state }
            return nil
        }

        var mainTab: MainTabReducer.State? {
            if case .mainTab(let state) = self { return state }
            return nil
        }
    }

    enum Action {
        case onAppear
        case checkAuthResult(Result<Token?, Error>)
        case checkCoupleConnectionResult(isConnected: Bool)
        case deepLinkReceived(code: String)
        case path(PathAction)
    }

    @CasePathable
    public enum PathAction {
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
        Scope(state: \.path, action: \.path) {
            Scope(state: \.auth, action: \.auth) {
                authReducer
            }
            Scope(state: \.onboarding, action: \.onboarding) {
                onboardingCoordinator
            }
            Scope(state: \.mainTab, action: \.mainTab) {
                mainTabReducer
            }
        }

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
                state.isCheckingAuth = false
                if token != nil {
                    // TODO: 실제 API 연동 시 커플 연결 여부 체크
                    // 임시로 Onboarding으로 이동 (테스트용)
                    // return .send(.checkCoupleConnectionResult(isConnected: false))
                    state.path = .mainTab(MainTabReducer.State())
                } else {
                    state.path = .auth(AuthReducer.State())
                }
                return .none

            case .checkAuthResult(.failure):
                state.isCheckingAuth = false
                state.path = .auth(AuthReducer.State())
                return .none

            case let .checkCoupleConnectionResult(isConnected):
                if isConnected {
                    state.path = .mainTab(MainTabReducer.State())
                } else {
                    // 커플 미연결 → Onboarding으로 이동
                    state.path = .onboarding(OnboardingCoordinator.State(
                        myInviteCode: "", // TODO: API에서 받아온 내 초대 코드
                        pendingReceivedCode: state.pendingInviteCode
                    ))
                    state.pendingInviteCode = nil
                }
                return .none

            case let .deepLinkReceived(code):
                state.pendingInviteCode = code

                if case .onboarding = state.path {
                    return .send(.path(.onboarding(.deepLinkReceived(code: code))))
                }
                // Auth 화면이면 로그인 후 Onboarding에서 처리됨 (pendingInviteCode 저장됨)
                return .none

            case .path(.auth(.delegate(.loginSucceeded))):
                // 로그인 성공 → 커플 연결 여부 체크
                // TODO: 실제 API 연동 시 아래 주석 해제
                // return .send(.checkCoupleConnectionResult(isConnected: false))
                state.path = .mainTab(MainTabReducer.State())
                return .none

            case .path(.onboarding(.delegate(.onboardingCompleted))):
                state.path = .mainTab(MainTabReducer.State())
                return .none

            case .path(.onboarding(.delegate(.navigateBack))):
                // Onboarding에서 뒤로가기 → Auth로 이동
                // TODO: 인증부 구현 후 삭제 또는 기능 변경 
                state.path = .auth(AuthReducer.State())
                return .none

            case .path:
                return .none
            }
        }
    }
}
